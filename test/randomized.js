var Randomized = artifacts.require("./Randomized.sol");

contract("Randomized", function(accounts) {
    it("should allow registering when value is payed", function() {
        return Randomized.deployed().then(function(instance){
            instance.setPrice(10);
            instance.enableContract();
            return instance.setKey(web3.toHex("abc"), {value:10});
        });
    });
    it("should say false for an invalid random number", function() {
        return Randomized.deployed().then(function(instance){
            return instance.validate(1000, "invalid", accounts[0], "invalid", "invalid");
        }).then(function(isValid) {
            assert.isFalse(isValid);
        });
    });
    it("should say true for a valid random number", function() {
        return Randomized.deployed().then(function(instance){
            return instance.validate(1000, 
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
            instance.setKey(web3.toHex("secondKey"), {value:10});
            console.log(instance.keys);
            return instance.validate(1000, 
            web3.toHex("seed"), 
            accounts[0], 
            "0x42511dd7f19347a57ddff71656040d8f71af2f328df5f7cf5e14ea1fb4ffbcd2", 
            "0xead113545fe563407133a4ce2b2c7d1149144ba6bf66f103799b1672698d3975");
        }).then(function(isValid) {
            assert.isTrue(isValid);
        });
    })
});