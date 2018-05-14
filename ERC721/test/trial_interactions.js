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
}).then(function(){
	return bloomingPool.deployed()
}).then(function(instance){
	bloom = instance;
}).then(function(){
	return buyable.deployed()
}).then(function(instance){
	buyable = instance;
}).then(function(){
	return testreg.deployed()
}).then(function(instance){
	testreg = instance;
}).then(function(){
	return update.deployed()
}).then(function(instance){
	update = instance;
}).then(function(){
	console.log(`addresses: bloom_pool: ${bloom.address}acl:${acl.address}buyable: ${buyable.address}testreg: ${testreg.address}update: ${update.address}`)
}).then(function(instance){
	console.log(`ROLE of coinbase: ${instance.toNumber()} (ADMIN)...`)
}).then(function(instance){
	return acl.getRole(web3.eth.accounts[5],{from:web3.eth.accounts[0]})
}).then(function(instance){
	console.log(`ROLE of web3.eth.accounts[5]: ${instance.toNumber()} (ORACLE) `)
}).then(function(){
	testreg.setApprovalForAll(testreg.address,true,{from:web3.eth.accounts[0]})
	console.log("Beginning admin for selling... called setApprovalForAll from coinbase")
}).then(function(){
	return testreg.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}`)
}).then(function(){
	buyable.set_price_and_sell(3,web3.toWei(100,"ether")),{from:web3.eth.accounts[0]})
	console.log(`coinbase approved token 3 for selling`)
}).then(function(){
	testreg.setApprovalForAll(testreg.address,true,{from:web3.eth.accounts[1]})
	console.log("called setApprovalForAll from web3.eth.accounts[1]")
}).then(function(){
	buyable.buy(3,{from:web3.eth.accounts[1], value:web3.toWei(100,"ether")})
}).then(function(){
	return testreg.balanceOf(web3.eth.accounts[0])
	console.log("accounts[1] bought flowerToken 3")
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by coinbase: ${balance}`)
}).then(function(){
	return testreg.balanceOf(web3.eth.accounts[1])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`tokens owned by web3.eth.accounts[1]: ${balance}`)
}).then(function(){
	return bloom.balance({from:web3.eth.accounts[0]})
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`balance of bloomingPool: ${balance} ETHER`)
}).then(function(){
	process.exit()
}).catch(function(error) {
	console.log(error);
});


/*
acc[0]
	- testreg.setApprovalForAll(testreg.address,true)
	- check balanceOf(self) == 100
	- set_for_sale(ALL_TULIPS) == true
			||||||||||||||||||||DONE|||||||||||||||||||||||
accounts[1]:
	- testreg.setApprovalForAll(testreg.address,true)
	- buy token
	- check balanceOf(self) == 1
	- check balanceOf(coinbase) == 99
	- check balance of bloomingPool
	- check balance of infrastructure (web3.eth.accounts[6])
	- set_price_and_sell(THIS_FLOWER)
	- set_price_and_sell(NOT_THIS_FLOWER) <—- this should fail
accounts[2]:
	- testreg.setApprovalForAll(testreg.address,true)
	- check acc.[1]’s flower token data
	- buy acc.[1]’s flower
	- check balanceOf(self) == 1
	- check (now acc.[2]’s) flower token data <—- this should be the same
	- check balanceOf(coinbase) == 99
	- check balanceOf(acc.[1]) == 0
	- check balance of bloomingPool
	- check balance of infrastructure (web3.eth.accounts[6])
	- set_price_and_sell(THIS_FLOWER)
	- stop_sell(THIS_FLOWER)
accounts[3]:
	- try and buy acc.[2]’s flower <—- this should fail
	- check balance of bloomingPool
	- check balance of infrastructure (web3.eth.accounts[6])
*/
