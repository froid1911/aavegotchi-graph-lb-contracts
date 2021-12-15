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
    mapping(string => address) serversOwnedBy;

    // subgraphId => servers[]
    mapping(string => string[]) syncedServers;

    event SubgraphPublished(string _name, string _hash);
    event ServerAdded(string _server, address _owner);
    event SubgraphSynced(string _name, string _hash, string _server);

    function registerServer(string memory _server, address memory _owner) onlyOwner public {
        address memory owner = serversOwnedBy[_server];
        require(owner == address(0), "Server already registered");
        serversOwnedBy[_server] = _owner;
        emit ServerAdded(_server, _owner);
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
            if(!serverExists) {
                return;
            }
        }

        syncedServers[_hash].push(_server);
        emit SubgraphSynced(_name, _hash, _server);
    }
}