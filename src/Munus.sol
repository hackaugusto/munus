// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Munus {
    mapping(bytes32 => bool) public secrets;

    function setSecret(bytes32 secret) public {
        bytes32 hash = keccak256(abi.encodePacked(secret));
        require(secrets[hash] == false);
        secrets[hash] = true;
    }
}
