const task1 = task("publishSubgraph", "Publishes a subgraph hash")
.addParam("name", "Name of the Subgraph")
.addParam("hash", "hash of the subgraph")
.setAction(async (args, hre) => {
    const Registry = await hre.ethers.getContractFactory("Registry");
    const provider = hre.ethers.providers.getNetwork("mumbai");
    const contract = await Registry.attach(
        "0xbc0ff7879f771cd1798ed9771a3b560be756c8e1"
    );

    await contract.publishSubgraph(args.name, args.hash);

    console.log("Subgraph published");
});

module.exports = task1