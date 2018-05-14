var acl = artifacts.require("acl");
var bloomingPool = artifacts.require("bloomingPool");
var buyable = artifacts.require("buyable");
var testreg = artifacts.require("testreg");
var update = artifacts.require("update");
var erc721 = artifacts.require("ERC721BasicToken.sol");

acl.setProvider(web3.currentProvider);
bloomingPool.setProvider(web3.currentProvider);
buyable.setProvider(web3.currentProvider);
testreg.setProvider(web3.currentProvider);
update.setProvider(web3.currentProvider);
erc721.setProvider(web3.currentProvider);

var acl;
var bloom;
var buyable;
var testreg;
var update;
var balance;
var erc721;

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
	return erc721.deployed()
}).then(function(instance){
	erc721 = instance;
	console.log("erc721 deployed properly...")
}).then(function(){
	console.log(`\nbloomingPool: ${bloom.address}\nacl:${acl.address}\nbuyable: ${buyable.address}\ntestreg: ${testreg.address}\nupdate: ${update.address}\nerc721: ${erc721.address}`)
}).then(function(){
	console.log("\nbeginning minting...")
}).then(function(){
	return erc721.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}`)
}).then(function(){
	var i;
	for (i = 0; i < 101; i++) {
		erc721._mint(web3.eth.accounts[0],i)
		console.log(`minted token ${i}`)
		}
}).then(function(){
	return erc721.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`...minting finished \ntokens owned by coinbase: ${balance}`)
}).then(function(instance){
	return acl.getRole(web3.eth.accounts[0],{from:web3.eth.accounts[0]})
}).then(function(instance){
	console.log(`ROLE of coinbase: ${instance.toNumber()} (ADMIN) `)
}).then(function(){
	acl.setRole(1,web3.eth.accounts[5])
	console.log("ROLE of web.eth.accounts[5]: 1 (ORACLE)")
}).then(function(){
	process.exit()
}).catch(function(error) {
	console.log(error);
});
