// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TicketBooking {
    struct Buyer {
        uint totalPrice;
        uint numTickets;
        string email;
    }
    address public seller;
    uint public numTicketsSold;
    uint public maxOccupancy;
    uint public price;
    mapping(address => Buyer) BuyersPaid;

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this function");
        _;
    }
    modifier soldOut() {
        require(numTicketsSold < maxOccupancy, "All tickets have been sold");
        _;
    }

    event Deposit(address from, uint amount);
    event Refund(address to, uint amount);

    constructor(uint _maxOccupancy, uint _price) {
        seller = msg.sender;
        numTicketsSold = 0;
        maxOccupancy = _maxOccupancy;
        price = _price;
    }

    function buyTickets(
        string memory emailId,
        uint numTickets
    ) public payable soldOut {
        require(
            numTicketsSold + numTickets <= maxOccupancy,
            "Not enough tickets left"
        );
        uint totalPrice = numTickets * price;
        require(msg.value >= totalPrice, "Not enough ether sent");
        /** Check if the buyer has already bought a ticket */
        if (BuyersPaid[msg.sender].numTickets > 0) {
            BuyersPaid[msg.sender].numTickets += numTickets;
            BuyersPaid[msg.sender].totalPrice += totalPrice;
        } else {
            BuyersPaid[msg.sender].email = emailId;
            BuyersPaid[msg.sender].numTickets = numTickets;
            BuyersPaid[msg.sender].totalPrice = totalPrice;
        }
        numTicketsSold += numTickets;
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }
        emit Deposit(msg.sender, totalPrice);
    }

    function refundTicket(address buyer) public onlySeller {
        require(address(this).balance >= BuyersPaid[buyer].totalPrice, "Not enough balance");
        numTicketsSold -= BuyersPaid[buyer].numTickets;
        payable(buyer).transfer(BuyersPaid[buyer].totalPrice);
        emit Refund(buyer, BuyersPaid[buyer].totalPrice);
        delete BuyersPaid[buyer];
    }

    function withdrawFunds() public onlySeller {
        payable(seller).transfer(address(this).balance);
    }

    function getBuyerAmountPaid(address buyer) public view returns (uint) {
        return BuyersPaid[buyer].totalPrice;
    }

    function kill() public onlySeller {
        selfdestruct(payable(seller));
    }
}
