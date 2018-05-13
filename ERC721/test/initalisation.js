var acl = artifacts.require("acl");
var bloomingPool = artifacts.require("bloomingPool");
var buyable = artifacts.require("buyable");
var testreg = artifacts.require("testreg");
var update= artifacts.require("update");

acl.setProvider(web3.currentProvider);
bloomingPool.setProvider(web3.currentProvider);
buyable.setProvider(web3.currentProvider);
testreg.setProvider(web3.currentProvider);
update.setProvider(web3.currentProvider);

var acl;
var bloom;
var buyable;
var testreg;
var update;
var balance;

acl.deployed().then(function(instance){
	acl = instance;
	console.log("\n\nacl deployed properly...")
}).then(function(){
	return bloomingPool.deployed()
}).then(function(instance){
	bloom = instance;
	console.log("bloomingPool deployed properly...")
}).then(function(){
	return buyable.deployed()
}).then(function(instance){
	buyable = instance;
	console.log("buyable deployed properly...")
}).then(function(){
	return testreg.deployed()
}).then(function(instance){
	testreg = instance;
	console.log("testreg deployed properly...")
}).then(function(){
	return update.deployed()
}).then(function(instance){
	update = instance;
	console.log("update deployed properly...")
}).then(function(){
	console.log(`\n**** addresses: bloom_pool: ${bloom.address}\nacl:${acl.address}\nbuyable: ${buyable.address}\ntestreg: ${testreg.address}\nupdate: ${update.address} ****`)
}).then(function(){
	testreg.setApprovalForAll(testreg.address,true);
}).then(function(){
	console.log("\n**** beginning minting...")
}).then(function(){
	return testreg.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}`)
}).then(function(){
	var i;
	for (i = 0; i < 101; i++) {
		testreg.Mint(web3.eth.accounts[0],"token")
		console.log(`minted token ${i}`)
		}
}).then(function(){
	return testreg.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}\n...minting finished ****`)
}).then(function(){
	acl.setRole(1,web3.eth.accounts[5])
	console.log("**** web.eth.accounts[5] ROLE set to ORACLE ****")
}).then(function(){
	process.exit()
}).catch(function(error) {
	console.log(error);
});
