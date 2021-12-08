// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Registry is Ownable {

    // subgraphName => subgraphHash
    mapping(string => string) subgraphHashes;

    // subgraphName => servers[]
    mapping(string => string[]) subgraphServers;

    event SubgraphDeployed(string _name, string _hash);
    event ServerAdded(string _name, string _server);


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
        subgraphHashes[_name] = _hash;
        emit SubgraphDeployed(_name, _hash);
    }

    function getServers(string calldata _name) view public returns (string[] memory) {
        return subgraphServers[_name];
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(bytes(a)) == keccak256(bytes(b)));
    } 


}