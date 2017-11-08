var Randomized = artifacts.require("./Randomized.sol");

contract("Randomized", function(accounts) {
    it("should allow registering", function() {
        return Randomized.deployed().then(function(instance){
            return instance.setKey(web3.toHex("abc"));
        });
    });
    it("should say false for an invalid random number", function() {
        return Randomized.deployed().then(function(instance){
            return instance.validate(web3.eth.blockNumber, "invalid", accounts[0], "invalid", "invalid");
        }).then(function(isValid) {
            assert.isFalse(isValid);
        });
    });
    it("should say true for a valid random number", function() {
        return Randomized.deployed().then(function(instance){
            return instance.validate(web3.eth.blockNumber+1, 
            web3.toHex("seed"), 
            accounts[0], 
            "0x42511dd7f19347a57ddff71656040d8f71af2f328df5f7cf5e14ea1fb4ffbcd2", 
            "0xead113545fe563407133a4ce2b2c7d1149144ba6bf66f103799b1672698d3975");
        }).then(function(isValid) {
            assert.isTrue(isValid);
        });
    });
    it("should allow changing public key and validating old stuff with old key", function() {
        return Randomized.deployed().then(function(instance){
            web3.currentProvider.sendAsync({
                jsonrpc: "2.0",
                method: "evm_mine",
                id: 12345
              }, function(err, result) {
                instance.setKey(web3.toHex("secondKey"));
                instance.validate(web3.eth.blockNumber, // The old key is still valid on this block although the key has been reSet
                web3.toHex("seed"), 
                accounts[0], 
                "0x42511dd7f19347a57ddff71656040d8f71af2f328df5f7cf5e14ea1fb4ffbcd2", 
                "0xead113545fe563407133a4ce2b2c7d1149144ba6bf66f103799b1672698d3975").then(function(isValid) {
                    assert.isTrue(isValid);
                });
              });
        })
    })
});