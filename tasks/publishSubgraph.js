const { task } = require("hardhat/config");

const task1 = task("publishSubgraph", "Publishes a subgraph hash")
.addParam("name", "Name of the Subgraph")
.addParam("hash", "hash of the subgraph")
.setAction(async (args, hre) => {
    const Registry = await hre.ethers.getContractFactory("Registry");
    const provider = hre.ethers.providers.getNetwork("mumbai");
    const contract = await Registry.attach(
        "0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6"
    );

    await contract.publishSubgraph(args.name, args.hash);

    console.log("Subgraph published");
});

module.exports = task1