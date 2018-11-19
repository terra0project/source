var acl = artifacts.require("./acl.sol");
var bloomingPool = artifacts.require("./bloomingPool.sol");
var buyable = artifacts.require("./buyable.sol");
var testreg = artifacts.require("./testreg.sol");
var update = artifacts.require("./update.sol");
var erc721BasicToken = artifacts.require("./ERC721BasicToken.sol");
var infrastructurePool = artifacts.require("./infrastructurePool.sol")
var ownable = artifacts.require("./Ownable.sol")

module.exports = function(deployer) {
	deployer.deploy(buyable)
	deployer.deploy(infrastructurePool)
}
