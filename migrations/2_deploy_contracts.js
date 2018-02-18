var ExampleERC721 = artifacts.require("./ExampleERC721.sol");

module.exports = function(deployer) {
  deployer.deploy(ExampleERC721);
};