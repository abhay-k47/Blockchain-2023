import json
from web3 import Web3, HTTPProvider
from web3.auto import w3 as w3_auto

provider = 'https://sepolia.infura.io/v3/af46804f91384731940b6271a0d6f7fe'
contract_address = '0xF98bFe8bf2FfFAa32652fF8823Bba6714c79eDd4'
my_roll = '20CS10001'
my_private_key = '0x53a308f8c28869c9bb8f4cb2ed9fdea1297d80b8c8773687fb78468b3b9bb4fe'
abi =  [
  {
    "inputs": [{ "internalType": "address", "name": "addr", "type": "address" }],
    "name": "get",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function",
  },
  {
    "inputs": [],
    "name": "getmine",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function",
  },
  {
    "inputs": [{ "internalType": "address", "name": "", "type": "address" }],
    "name": "roll",
    "outputs": [{ "internalType": "string", "name": "", "type": "string" }],
    "stateMutability": "view",
    "type": "function",
  },
  {
    "inputs": [{ "internalType": "string", "name": "newRoll", "type": "string" }],
    "name": "update",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function",
  },
]

w3 = Web3(HTTPProvider(provider))
account = w3_auto.eth.account.from_key(my_private_key)
contract = w3.eth.contract(address=contract_address, abi=abi)
transaction = contract.functions.update(my_roll).build_transaction({
    'gas': 2000000,
    'gasPrice': w3.to_wei('40', 'gwei'),
    'nonce': w3.eth.get_transaction_count(account.address),
})

# Sign the transaction
signed_transaction = w3_auto.eth.account.sign_transaction(transaction, my_private_key)

# Send the transaction
tx_hash = w3.eth.send_raw_transaction(signed_transaction.rawTransaction)

# Wait for the transaction to be mined
w3.eth.wait_for_transaction_receipt(tx_hash)

print(f"Transaction sent with hash: {tx_hash.hex()}")