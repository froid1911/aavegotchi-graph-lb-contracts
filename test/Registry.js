const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Registry contract", function () {

    let owner, hardhatRegistry;
    const subgraphName = "aavegotchi-core-matic";
    const server = "abc";
    const subgraphHash = "abc";

    it("Deployment should set owner of contract to deployer address", async function () {
        [owner] = await ethers.getSigners();
        const Registry = await ethers.getContractFactory("Registry");
        hardhatRegistry = await Registry.deploy();
        const ownerContract = await hardhatRegistry.owner();
        expect(ownerContract).to.equal(owner.address);
    });

    it("Emits SubgraphDeployed event if subgraph hash is added", async function () {
        await expect(hardhatRegistry.publishSubgraph(subgraphName, subgraphHash))
            .to.emit(hardhatRegistry, 'SubgraphDeployed')
            .withArgs(subgraphName, subgraphHash);
    })

    it("Emits ServerPublished event if server is added", async function () {
        await expect(hardhatRegistry.registerServer(subgraphName, server))
            .to.emit(hardhatRegistry, 'ServerPublished')
            .withArgs(subgraphName, server);
    })

    it("Doesn't emit ServerPublished event if server is already added", async function () {
        await expect(hardhatRegistry.registerServer(subgraphName, server))
            .to.not.emit(hardhatRegistry, 'ServerPublished')
            .withArgs(subgraphName, server);
    })

    it("Emits SubgraphSynced event if subgraphSynced function is called", async function () {
        let servers = await hardhatRegistry.getServers(subgraphName)
        expect(servers).to.contain(server)
    })

    it("Fetches Servers for specific subgraph with synced servers", async function () {
        let servers = await hardhatRegistry.getServers(subgraphName)
        expect(servers).to.contain(server)
    })
});