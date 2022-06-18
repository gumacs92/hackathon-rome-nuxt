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
      // provider: () => new HDWalletProvider(mnemonic, `https://polygon-mumbai.g.alchemy.com/v2/hcFrhMzqBw5qNFrG25xGAXRU4sMciI2W`),
      provider: () => new HDWalletProvider(mnemonic, `https://polygon-mumbai.g.alchemy.com/v2/zjLFzNhk8AVv-KWTuRPzK_UTJjk9zqJi`),
      network_id: 80001,
      from: '0x4498Bdd0f655Bd1f21cd89840Ac73feb6b547bb6',
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
