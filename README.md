# CryptoWorkshop

## Prerequisites
1. Install npm
https://nodejs.org/es/download/

2. Install Visual Code
https://code.visualstudio.com/Download

2.1 Install Solidity extension for Visual Code
https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity

3. Install Truffle 
`npm install truffle -g`

4. Install Ganache
`npm install ganache-cli -g`

## How to setup

#### Install npm packages
Install all dependencies
`npm install`

## How to run local test
1. Run local env
`truffle develop`

2. Run tests 
`truffle test`

## How to run local deployment
1. Run local blockchain
`ganache-cli`
2. Run local deployment
`truffle deploy --network development`

## How to run on the testnet

#### Testnet prerequisites
1. Download release from https://github.com/ObsidianLabs/BSC-Studio/releases
2. Create your Metamask account https://metamask.io/
5. Copy and paste your Metamask mnemonic to the .secret file
3. Setup Binance Studio https://github.com/LemosTestagrossa/CryptoWorkshop/issues/2#issuecomment-988303101
4. Add the Metamask Account to Binance Studio https://github.com/LemosTestagrossa/CryptoWorkshop/issues/2#issuecomment-988397125
6. Deploy a contract https://github.com/LemosTestagrossa/CryptoWorkshop/issues/2#issuecomment-988392379
7. Interact with the contract: https://github.com/LemosTestagrossa/CryptoWorkshop/issues/2#issuecomment-988399511
