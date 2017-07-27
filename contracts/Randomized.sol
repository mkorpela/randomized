pragma solidity ^0.4.4;

contract Randomized {

    address public owner;

    function Randomized() {
        owner = msg.sender;
    }

    struct Key {
        uint entryBlockNumber;
        bytes publicKey;
    }

    mapping (address => Key) keys;

    function setKey(bytes publicKey) {
        keys[msg.sender].entryBlockNumber = block.number;
        keys[msg.sender].publicKey = publicKey;
    }

    function validate(uint seedBlockNumber, bytes seed, address sender, bytes32 crypted, bytes32 result) constant returns (bool) {
        if (keys[sender].entryBlockNumber >= seedBlockNumber) return false;
        if (keccak256(crypted, seed) != result) return false;
        return keccak256(seed) == this.privatized(crypted, keys[sender].publicKey);
    }

    function privatized(bytes32 crypted, bytes publicKey) constant returns (bytes32) {
        // Waiting for https://github.com/ethereum/EIPs/pull/198
        return 123;
    }

}