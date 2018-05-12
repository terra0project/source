var acl = artifacts.require("./acl.sol");
var blooming_pool = artifacts.require("./blooming_pool.sol");
var buyable = artifacts.require("./buyable.sol");
var erc721 = artifacts.require("ERC721.sol");
var SplitPayment = artifacts.require("./SplitPayment.sol");
var testreg = artifacts.require("./testreg.sol");
var update = artifacts.require("./update.sol");

module.exports = function(deployer) {
	return deployer.deploy(acl)
	.then(function(){
		return deployer.deploy(erc721)
	}).then(function(){
		return deployer.deploy(SplitPayment)
	}).then(function(){
		return deployer.deploy(testreg)
	}).then(function(){
		return deployer.deploy(blooming_pool)
	}).then(function(){
		return deployer.deploy(buyable, blooming_pool.address, "0xE4a7E27867599D23CF426717cDf0a8EbB71ef8ca")
	}).then(function(){
		return deployer.deploy(update)
	}).catch(function(error) {
  		console.log(error);
	});
}
