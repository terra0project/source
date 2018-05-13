var acl = artifacts.require("./acl.sol");
var buyable = artifacts.require("./buyable.sol");
var testreg = artifacts.require("./testreg.sol");
var update = artifacts.require("./update.sol");
var bloomingPool = artifacts.require("./bloomingPool.sol");

module.exports = function(deployer) {
	deployer.deploy(acl)
	.then(function(){
		return deployer.deploy(testreg)
	}).then(function(){
		return deployer.deploy(bloomingPool, [web3.eth.accounts[0]], [1])
	}).then(function(){
		return deployer.deploy(update)
	}).then(function(bloomingPool){
		return deployer.deploy(buyable, web3.eth.accounts[5],bloomingPool.address)
	})
}

// for production: INFRASTRUCTURE_POOL_ADDRESS == "0xE4a7E27867599D23CF426717cDf0a8EbB71ef8ca" instead of web3.eth.accounts[5]
