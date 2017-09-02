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
        bytes32 publicKey;
    }

    mapping (address => Key[]) keys;

    function setKey(bytes32 publicKey) payable public {
        require(!disabled);
        require(msg.value >= price);
        Key[] storage senderKeys = keys[msg.sender];
        require(senderKeys.length == 0 || senderKeys[senderKeys.length-1].entryBlockNumber < block.number);
        senderKeys.push(Key(block.number, publicKey));
    }

    function validate(uint seedBlockNumber, bytes32 seed, address sender, bytes32 crypted, bytes32 result) constant public returns (bool) {
        require(!disabled);
        if (keccak256(crypted, seed) != result) 
            return false;
        Key memory key = findKey(keys[sender], seedBlockNumber);
        if (key.entryBlockNumber >= seedBlockNumber) 
            return false;
        return keccak256(seed) == privatized(crypted, key.publicKey);
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

    function findKey(Key[] addressKeys, uint seedBlockNumber) constant private returns (Key) {
        uint x = addressKeys.length;
        while (x > 0) {
            x -= 1;
            if (seedBlockNumber > addressKeys[x].entryBlockNumber) {
                return addressKeys[x];
            } 
        }
        return Key(0, 0x0);
    }

    function privatized(bytes32 crypted, bytes32 publicKey) constant private returns (bytes32) {
        // Waiting for https://github.com/ethereum/EIPs/pull/198
        // And specifically this from geth (and same from other clients): 
        // https://github.com/ethereum/go-ethereum/blob/104375f398bdfca88183010cc3693e377ea74163/core/vm/contracts.go#L56
        // For now using just a simple bitwise xor to get the bidirectional mapping for testing
        return crypted ^ publicKey;
    }

}