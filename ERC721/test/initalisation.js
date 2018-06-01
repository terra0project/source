var acl = artifacts.require("acl");
var bloomingPool = artifacts.require("bloomingPool");
var buyable = artifacts.require("buyable");
var testreg = artifacts.require("testreg");
var update = artifacts.require("update");
var erc721 = artifacts.require("ERC721BasicToken.sol");
var infrastructurePool = artifacts.require("infrastructurePool.sol");

bloomingPool.setProvider(web3.currentProvider);
buyable.setProvider(web3.currentProvider);
infrastructurePool.setProvider(web3.currentProvider);

var bloom;
var buyable;
var infra;

bloomingPool.deployed()
.then(function(instance){
	bloom = instance;
	console.log("\n\nbloomingPool deployed properly...")
}).then(function(){
	return buyable.deployed()
}).then(function(instance){
	buyable = instance;
	console.log("buyable deployed properly...")
}).then(function(){
	return infrastructurePool.deployed()
}).then(function(instance){
	infra = instance;
	console.log("infrastructurePool deployed properly...")
}).then(function(){
	console.log(`\nbloomingPool: ${bloom.address}\nbuyable: ${buyable.address}\ninfrastructurePool: ${infra.address}`)
}).then(function(){
	console.log("\nbeginning minting...")
}).then(function(){
	return buyable.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}`)
}).then(function(){
	var i;
	for (i = 0; i < 101; i++) {
		buyable._mint(web3.eth.accounts[0],i)
		console.log(`minted token ${i}`)
		}
}).then(function(){
	return buyable.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}\n...minting finished`)
}).then(function(instance){
	return buyable.getRole(web3.eth.accounts[0],{from:web3.eth.accounts[0]})
}).then(function(instance){
	console.log(`\nROLE of coinbase: ${instance.toNumber()} (ADMIN) `)
}).then(function(){
	buyable.setRole(1,web3.eth.accounts[5])
	console.log("ROLE of web.eth.accounts[5]: 1 (ORACLE)")
}).then(function(){
	buyable.initialisation(infra.address,bloom.address)
	console.log("Initialised state variables of BUYABLE CONTRACT for BLOOMING POOL and INFRASTRUCTURE POOL payouts")
}).then(function(){
	process.exit()
}).catch(function(error) {
	console.log(error);
});
