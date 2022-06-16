const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  networks: {
    loc_ganache_development: {
      network_id: "*",
      port: 7545,
      host: "127.0.0.1"
    },
    matic_mumbai: {
      provider: () => new HDWalletProvider(mnemonic, `https://polygon-mumbai.g.alchemy.com/v2/hcFrhMzqBw5qNFrG25xGAXRU4sMciI2W`),
      network_id: 80001,
      //from: '0xEed63211B522d264d2EaFa59540114eb073491f6',
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
