/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers") ;

require("@nomiclabs/hardhat-waffle");
require('./tasks/publishSubgraph');
require('./tasks/registerServer');

module.exports = {
  solidity: "0.8.0",
  networks: {
    mumbai: {
      url: process.env.MATIC_URL,
      accounts: [process.env.PRIVATE_KEY],
      // blockGasLimit: 20000000,
      blockGasLimit: 20000000,
      gasPrice: 1000000000,
      timeout: 90000,
    },
  }
};
