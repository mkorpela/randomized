pragma solidity ^0.4.4;


contract Randomized {

    struct Key {
        uint entryBlockNumber;
        bytes32 publicKey;
    }

    mapping (address => Key[]) keys;

    function setKey(bytes32 publicKey) public {
        Key[] storage senderKeys = keys[msg.sender];
        require(senderKeys.length == 0 || senderKeys[senderKeys.length-1].entryBlockNumber < block.number);
        senderKeys.push(Key(block.number, publicKey));
    }

    function validate(uint seedBlockNumber, bytes32 seed, address sender, bytes32 crypted, bytes32 result) constant public returns (bool) {
        if (keccak256(crypted, seed) != result) 
            return false;
        Key memory key = findKey(keys[sender], seedBlockNumber);
        if (key.entryBlockNumber >= seedBlockNumber) 
            return false;
        return keccak256(seed) == privatized(crypted, key.publicKey);
    }

    function findKey(Key[] addressKeys, uint seedBlockNumber) constant private returns (Key) {
        uint x = addressKeys.length;
        //TODO: These are in order => use binary search
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