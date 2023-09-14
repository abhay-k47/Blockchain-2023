const { Web3 } = require("web3");
// const Contract = require("web3-eth-contract");
const provider =
  "https://sepolia.infura.io/v3/af46804f91384731940b6271a0d6f7fe";
const contractAddress = "0xF98bFe8bf2FfFAa32652fF8823Bba6714c79eDd4";
const queryAddress = "0x328Ff6652cc4E79f69B165fC570e3A0F468fc903";
const myRoll = "20CS10001";
const myAddress = "0xA841bfcd1AFD000aF76C951B70Dd456Efd49D251";
const myPrivateKey =
  "0x53a308f8c28869c9bb8f4cb2ed9fdea1297d80b8c8773687fb78468b3b9bb4fe";

const contractABI = [
  {
    inputs: [{ internalType: "address", name: "addr", type: "address" }],
    name: "get",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getmine",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "address", name: "", type: "address" }],
    name: "roll",
    outputs: [{ internalType: "string", name: "", type: "string" }],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [{ internalType: "string", name: "newRoll", type: "string" }],
    name: "update",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const web3 = new Web3(new Web3.providers.HttpProvider(provider));
const contract = new web3.eth.Contract(contractABI, contractAddress);
const account = web3.eth.accounts.privateKeyToAccount(myPrivateKey);

async function queryRollForAddress(address) {
  try {
    const roll = await contract.methods.get(address).call();
    console.log(`Roll for address ${address}: ${roll}`);
  } catch (error) {
    console.error("Error querying roll:", error);
  }
}

async function updateRoll(newRoll) {
  try {
    const gasPrice = await web3.eth.getGasPrice();
    const nonce = await web3.eth.getTransactionCount(account.address);
    const txData = contract.methods.update(newRoll).encodeABI();

    const txObject = {
      nonce: web3.utils.toHex(nonce),
      gasLimit: web3.utils.toHex(300000),
      gasPrice: web3.utils.toHex(gasPrice),
      to: contractAddress,
      data: txData,
    };

    const signedTx = await web3.eth.accounts.signTransaction(
      txObject,
      myPrivateKey
    );

    web3.eth
      .sendSignedTransaction(signedTx.rawTransaction)
      .on("transactionHash", (txHash) => {
        console.log(`Transaction sent with hash: ${txHash}`);
      })
      .on("receipt", (receipt) => {
        console.log("Transaction receipt:", receipt);
      })
      .on("error", (error) => {
        console.error("Error updating roll:", error);
      });
    queryRollForAddress(myAddress);
  } catch (error) {
    console.error("Error updating roll:", error);
  }
}

// B.1. Query the roll for the address
queryRollForAddress(queryAddress);

// B.2. Input your own roll through the update function.
updateRoll(myRoll);
