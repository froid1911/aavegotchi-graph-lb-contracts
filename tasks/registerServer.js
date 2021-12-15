const { task } = require("hardhat/config");

const task1 = task("registerServer", "Registers a server for a subgraph")
.addParam("name", "Name of the Subgraph")
.addParam("server", "Server URL")
.setAction(async (args, hre) => {
    const Registry = await hre.ethers.getContractFactory("Registry");
    const provider = hre.ethers.providers.getNetwork("mumbai");
    const contract = await Registry.attach(
        "0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6"
    );

    const response = await contract.registerServer(args.name, args.server);
    console.log(response);
    
    console.log("Server registered");
});

module.exports = task1