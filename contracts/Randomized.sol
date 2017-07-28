pragma solidity ^0.4.4;


contract Owned {

    address public owner;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}


contract Randomized is Owned {

    uint public price;
    bool public disabled;

    function Randomized() {
        price = 0;
        disabled = true;
    }

    struct Key {
        uint entryBlockNumber;
        bytes publicKey;
    }

    mapping (address => Key) keys;

    function setKey(bytes publicKey) payable public {
        require(!disabled);
        require(msg.value >= price);
        keys[msg.sender].entryBlockNumber = block.number;
        keys[msg.sender].publicKey = publicKey;
    }

    function validate(uint seedBlockNumber, bytes seed, address sender, bytes32 crypted, bytes32 result) constant public returns (bool) {
        require(!disabled);
        if (keys[sender].entryBlockNumber >= seedBlockNumber) return false;
        if (keccak256(crypted, seed) != result) return false;
        return keccak256(seed) == privatized(crypted, keys[sender].publicKey);
    }

    function setPrice(uint newprice) public onlyOwner {
        require(disabled);
        price = newprice;
    }

    function disableContract() public onlyOwner {
        disabled = true;
    }

    function enableContract() public onlyOwner {
        disabled = false;
    }

    function privatized(bytes32 crypted, bytes publicKey) constant private returns (bytes32) {
        // Waiting for https://github.com/ethereum/EIPs/pull/198
        return crypted;
    }

}