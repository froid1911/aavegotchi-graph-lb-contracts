const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Registry contract", function () {

    let owner, hardhatRegistry;

    it("Deployment should set owner of contract to deployer address", async function () {
        [owner] = await ethers.getSigners();
        const Registry = await ethers.getContractFactory("Registry");
        hardhatRegistry = await Registry.deploy();
        const ownerContract = await hardhatRegistry.owner();
        expect(ownerContract).to.equal(owner.address);
    });

    it("Emits SubgraphDeployed event if subgraph hash is added", async function () {
        const subgraphName = "aavegotchi-core-matic";
        const subgraphHash = "abc";
        await expect(hardhatRegistry.publishSubgraph(subgraphName, subgraphHash))
            .to.emit(hardhatRegistry, 'SubgraphDeployed')
            .withArgs(subgraphName, subgraphHash);
    })

    it("Emits ServerAdded event if server is added", async function () {
        const subgraphName = "aavegotchi-core-matic";
        const server = "abc";
        await expect(hardhatRegistry.registerServer(subgraphName, server))
            .to.emit(hardhatRegistry, 'ServerAdded')
            .withArgs(subgraphName, server);
    })

    it("Doesn't emit ServerAdded event if server is already added", async function () {
        const subgraphName = "aavegotchi-core-matic";
        const server = "abc";
        await expect(hardhatRegistry.registerServer(subgraphName, server))
            .to.not.emit(hardhatRegistry, 'ServerAdded')
            .withArgs(subgraphName, server);
    })
});