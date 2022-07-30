require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
    solidity: "0.8.8",
    namedAccounts: {
      deployer: {
        default: 0,
      },
    },
};
