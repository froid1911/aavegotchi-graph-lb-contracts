// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Registry is Ownable {

    // subgraphName => subgraphHash
    mapping(string => string) subgraphHashesPending;

    // subgraphName => subgraphHash
    mapping(string => string) subgraphHashesCurrent;

    // subgraphId => servers[]
    mapping(string => address) serversOwnedBy;

    // subgraphId => servers[]
    mapping(string => string[]) syncedServers;

    event SubgraphPublished(string _name, string _hash);
    event ServerAdded(string _server, address _owner);
    event SubgraphSynced(string _name, string _hash, string _server);

    modifier serverOwnedBy(string memory _server) {
        require(msg.sender == serversOwnedBy[_server]);
        _;
    }

    function registerServer(string memory _server, address _owner) onlyOwner public {
        serversOwnedBy[_server] = _owner;
        emit ServerAdded(_server, _owner);
    }

    function publishSubgraph(string memory _name, string memory _hash) onlyOwner public {
        subgraphHashesPending[_name] = _hash;
        emit SubgraphPublished(_name, _hash);
    }

    function getServers(string calldata _name) view public returns (string[] memory) {
        return syncedServers[subgraphHashesCurrent[_name]];
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(bytes(a)) == keccak256(bytes(b)));
    } 

    function subgraphSynced(string memory _name, string memory _hash, string memory _server) serverOwnedBy(_server) public {
        string memory current = subgraphHashesCurrent[_name];
        string memory pending = subgraphHashesPending[_name];

        // activate pending subgraph
        if(compareStrings(pending, _hash) && !compareStrings(current, _hash)) {
            subgraphHashesCurrent[_name] = _hash;
        }

        syncedServers[_hash].push(_server);
        emit SubgraphSynced(_name, _hash, _server);
    }
}