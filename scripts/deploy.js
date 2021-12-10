const { ethers } = require("hardhat");
async function main() {
    // We get the contract to deploy
    const Registry = await ethers.getContractFactory("Registry");
    const registry = await Registry.deploy();
  
    console.log("Registry deployed to:", registry.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });