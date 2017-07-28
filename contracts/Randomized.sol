pragma solidity ^0.4.4;


contract Owned {
    address public owner;
    address private ownerCandidate;
    bytes32 private ownerCandidateKeyHash;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyOwnerCandidate(bytes32 key) {
        require(msg.sender == ownerCandidate);
        require(keccak256(key) == ownerCandidateKeyHash);
        _;
    }

    function transferOwnership(address candidate, bytes32 keyHash)
        public
        onlyOwner
    {
        ownerCandidate = candidate;
        ownerCandidateKeyHash = keyHash;
    }

    function acceptOwnership(bytes32 key)
        external
        onlyOwnerCandidate(key)
    {
        owner = ownerCandidate;
    }
}


contract Randomized is Owned {

    uint public price;

    function Randomized() {
        price = 10;
    }

    struct Key {
        uint entryBlockNumber;
        bytes publicKey;
    }

    mapping (address => Key) keys;

    function setKey(bytes publicKey) payable public {
        require(msg.value >= price);
        keys[msg.sender].entryBlockNumber = block.number;
        keys[msg.sender].publicKey = publicKey;
    }

    function validate(uint seedBlockNumber, bytes seed, address sender, bytes32 crypted, bytes32 result) constant public returns (bool) {
        if (keys[sender].entryBlockNumber >= seedBlockNumber) return false;
        if (keccak256(crypted, seed) != result) return false;
        return keccak256(seed) == privatized(crypted, keys[sender].publicKey);
    }

    function privatized(bytes32 crypted, bytes publicKey) constant private returns (bytes32) {
        // Waiting for https://github.com/ethereum/EIPs/pull/198
        return crypted;
    }

}