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

    modifier onlyOwner() {
        require(msg.sender == seller, "Only seller can call this function");
        _;
    }
    modifier soldOut() {
        require(numTicketsSold < maxOccupancy, "All tickets have been sold");
        _;
    }

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
        /** Check if the buyer has already bought a ticket */

        BuyersPaid[msg.sender].totalPrice = numTickets * price;
        BuyersPaid[msg.sender].numTickets = numTickets;
        BuyersPaid[msg.sender].email = emailId;
        numTicketsSold += numTickets;
    }

    function refundTicket(address buyer) public onlyOwner {
        numTicketsSold -= BuyersPaid[buyer].numTickets;
        BuyersPaid[buyer].numTickets = 0;
        BuyersPaid[buyer].totalPrice = 0;
    }

    function withdrawFunds() public onlyOwner {}

    function getBuyerAmountPaid(address buyer) public view returns (uint){
        return BuyersPaid[buyer].totalPrice;
    }

    function kill() public onlyOwner{
        
    }
}
