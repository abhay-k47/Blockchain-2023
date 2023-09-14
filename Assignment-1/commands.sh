# Create a new account on mainnet
geth account new
# Create a new account on sepolia testnet
geth --sepolia account new 
# List all accounts on mainnet
geth account list
# List all accounts on sepolia testnet
geth --sepolia account list

# Dump the configuration of the sepolia testnet
geth --sepolia dumpconfig > sepolia-config.toml

# Start the sepolia testnet
geth --sepolia --http --http.api eth,web3 --config sepolia-config.toml --datadir sepolia-datadir --allow-insecure-unlock --unlock <ACCOUNT_ADDRESS> --password <PASSWORD> 2> geth-logs.log
# Attach to the geth console
geth attach ./sepolia-datadir/geth.ipc
# Start the sepolia testnet with the console
geth console --sepolia --http --http.api eth,web3 --config sepolia-config.toml --datadir sepolia-datadir 2> geth-logs.log
# Extracting the private key from the keyfile
web3 account extract --keyfile ~/.ethereum/sepolia/keystore/<KEYFILE> --password <PASSWORD>

# Generate ABI and BIN files from the Solidity contract
solc --abi --bin <CONTRACT>.sol --overwrite -o build

# NodeJS Project Setup
npm init -y
npm install web3
# Run the NodeJS script
node <SCRIPT>.js

# Python Project Setup
pip3 install web3
# Run the Python script
python3 <SCRIPT>.py
