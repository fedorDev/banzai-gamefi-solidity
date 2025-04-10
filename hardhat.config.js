require("@nomicfoundation/hardhat-toolbox");
const conf = require('./secret.json');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  networks: {
    testnet: {
      url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: { mnemonic: conf.mnemonic }
    },
    bsc: {
      url: "https://bsc-rpc.publicnode.com",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: { mnemonic: conf.mnemonic }
    },
    eth: {
      url: "https://rpc.mevblocker.io",
      chainId: 1,
      gasPrice: 20000000000,
      accounts: { mnemonic: conf.mnemonic }
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://bscscan.com/
    apiKey: conf.bscscanApiKey
  }
};
