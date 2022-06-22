require('dotenv').config()
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    loc_ganache_development: {
      network_id: "*",
      port: 7545,
      host: "127.0.0.1"
    },
    matic_mumbai: {
      // provider: () => new HDWalletProvider(mnemonic, `https://polygon-mumbai.g.alchemy.com/v2/hcFrhMzqBw5qNFrG25xGAXRU4sMciI2W`),
      provider: () => new HDWalletProvider(process.env.ADDRESS_SECRET_MNEMONIC, `https://polygon-mumbai.g.alchemy.com/v2/zjLFzNhk8AVv-KWTuRPzK_UTJjk9zqJi`),
      network_id: 80001,
      from: process.env.ADDRESS_DEPLOY_FROM,
      //confirmations: 2,
      gas:4500000,
      gasPrice:10000000000,
      timeoutBlocks: 200,
      // disableConfirmationListener: true,
      //skipDryRun: true
    },
  },
  mocha: {},
  compilers: {
    solc: {
      version: "0.8.14"
    }
  }
};
