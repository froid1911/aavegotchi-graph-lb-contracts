// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Registry is Ownable {


    struct SubgraphHash {
        string current;
        string last;
    }

    // subgraphName => subgraphHash
    mapping(string => string) subgraphHashesPending;

    // subgraphName => subgraphHash
    mapping(string => string) subgraphHashesCurrent;

    // subgraphId => servers[]
    mapping(string => string[]) subgraphServers;

    // subgraphId => servers[]
    mapping(string => string[]) syncedServers;

    event SubgraphPublished(string _name, string _hash);
    event ServerAdded(string _name, string _server);
    event SubgraphSynced(string _name, string _hash, string _server);

    function registerServer(string memory _subgraphName, string memory _server) onlyOwner public {
        string[] memory servers = subgraphServers[_subgraphName];
        for(uint i=0;i<servers.length; i++) {
            bool serverExists = compareStrings(servers[i], _server);
            if(serverExists) {
                return;
            }
        }

        subgraphServers[_subgraphName].push(_server);
        emit ServerAdded(_subgraphName, _server);
    }

    function publishSubgraph(string memory _name, string memory _hash) onlyOwner public {
        subgraphHashesPending[_name] = _hash;
        emit SubgraphPublished(_name, _hash);
    }

    function getServers(string calldata _name) view public returns (string[] memory) {

        // fetch 

        return subgraphServers[_name];
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(bytes(a)) == keccak256(bytes(b)));
    } 

    function subgraphSynced(string memory _name, string memory _hash, string memory _server) onlyOwner public {
        string[] memory servers = syncedServers[_hash];
        for(uint i=0;i<servers.length; i++) {
            bool serverExists = compareStrings(servers[i], _server);
            if(serverExists) {
                return;
            }
        }

        syncedServers[_hash].push(_server);
        emit SubgraphSynced(_name, _hash, _server);
    }
}