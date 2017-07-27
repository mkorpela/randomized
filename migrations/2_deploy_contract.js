var Randomized = artifacts.require("./Randomized.sol");

module.exports = function(deployer) {
  deployer.deploy(Randomized);
};