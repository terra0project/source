var acl = artifacts.require("./acl.sol");
var bloomingPool = artifacts.require("./bloomingPool.sol");
var buyable = artifacts.require("./buyable.sol");
var testreg = artifacts.require("./testreg.sol");
var update = artifacts.require("./update.sol");
var erc721BasicToken = artifacts.require("./ERC721BasicToken.sol");

// @dev first recipient of the bloomingPool share is the infrastructure address as it needs to be initialised with at least one address
// @dev for production: INFRASTRUCTURE_POOL_ADDRESS == "0xE4a7E27867599D23CF426717cDf0a8EbB71ef8ca" instead of web3.eth.accounts[5]

module.exports = function(deployer) {
	deployer.deploy(buyable)
	.then(function(){
		return deployer.deploy(bloomingPool, [web3.eth.accounts[6]], [1])
	})
}
