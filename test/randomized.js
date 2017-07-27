var Randomized = artifacts.require("./Randomized.sol");

contract("Randomized", function(accounts) {
    it("should allow registering when value is payed", function() {
        return Randomized.deployed().then(function(instance){
            return instance.setKey("abc", {value:10});
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
                "seed", 
            accounts[0], 
            "0x66a80b61b29ec044d14c4c8c613e762ba1fb8eeb0c454d1ee00ed6dedaa5b5c5", 
            "0x3f03460b3bb219c82359136ecfae99d42ed44bf21d31bc7c0507615d15de1198");
        }).then(function(isValid) {
            console.log(isValid);
            assert.isTrue(isValid);
        });
    });
});