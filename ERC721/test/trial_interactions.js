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
var returndata;

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
	return erc721.deployed()
}).then(function(instance){
	erc721 = instance;
}).then(function(){
	console.log(`\n\nbloomingPool: ${bloom.address}\nacl:${acl.address}\nbuyable: ${buyable.address}\ntestreg: ${testreg.address}\nupdate: ${update.address}\nerc721: ${erc721.address}`)
}).then(function(instance){
	return acl.getRole(web3.eth.accounts[0],{from:web3.eth.accounts[0]})
}).then(function(instance){
	console.log(`\nROLE of coinbase: ${instance.toNumber()} (ADMIN) `)
}).then(function(){
	acl.setRole(1,web3.eth.accounts[5])
}).then(function(instance){
	return acl.getRole(web3.eth.accounts[5],{from:web3.eth.accounts[0]})
}).then(function(instance){
	console.log(`ROLE of web3.eth.accounts[5]: ${instance.toNumber()} (ORACLE) `)
}).then(function(){ // <-------------------------- change TESTREG to ERC721 from here on ------------------
	buyable.setApprovalForAll(buyable.address,true)
	console.log("\nBeginning token checks before transferals... \n...coinbase approved BUYABLE CONTRACT for transferal of all tokens")
}).then(function(){
	return erc721.balanceOf(web3.eth.accounts[0])
}).then(function(instance){
	balance = instance.toNumber();
}).then(function(){
	console.log(`...tokens owned by coinbase: ${balance}`)
}).then(function(){
	return buyable.isApprovedForAll(web3.eth.accounts[0],buyable.address)
}).then(function(instance){
	console.log(`...is BUYABLE CONTRACT approved to transfer tokens from coinbase? ${instance.toString().toUpperCase()} `)
}).then(function(){
	return buyable.get_token_data_buyable(1);
}).then(function(instance){
	returndata = instance;
}).then(function(){
	console.log(`...is token 1 buyable? ${returndata.toString().toUpperCase()}`)
}).then(function(){
	return buyable.get_all_sellable_token()
}).then(function(instance){
	console.log(`...all sellable tokens: ${instance}`)
}).then(function(){
	return buyable.get_token_data(1)
}).then(function(instance){
	console.log(`...token data for token 1: ${instance}`)
}).then(function(){
	return buyable.get_token_data_buyable(1)
}).then(function(instance){
	console.log(`... is token 1 buyable? ${instance.toString().toUpperCase()}`)
}).then(function(){
	console.log(`\nPreparing token 1 for sale...`)
}).then(function(){
	return erc721.ownerOf(1)
}).then(function(instance){
	console.log(`owner of token 1: ${instance}`)
	console.log(`coinbase address: ${web3.eth.accounts[0]}`)
}).then(function(){
	return buyable.getApproved(1)
}).then(function(instance){
	console.log(`approved address for token 1: ${instance}`)
}).then(function(){
	return buyable.isApprovedForAll(web3.eth.accounts[0], buyable.address)
}).then(function(instance){
	console.log(`is BUYABLE CONTRACT approved for transferal from coinbase? ${instance.toString().toUpperCase()}`)
}).then(function(){
	return buyable.isApprovedForAll(web3.eth.accounts[0],buyable.address)
}).then(function(instance){
	console.log(`is BUYABLE CONTRACT approved for transferals from coinbase? ${instance.toString().toUpperCase()}`)
}).then(function(){
	buyable.set_price_and_sell(1,100,{from:web3.eth.accounts[0]})
}).then(function(){
	return buyable.get_token_data_buyable(1);
}).then(function(instance){
	returndata = instance;
}).then(function(){
	console.log(`...is token 1 buyable? ${returndata.toString().toUpperCase()}`)
}).then(function(){
	return buyable.get_all_sellable_token()
}).then(function(instance){
	console.log(`...all sellable tokens: ${instance}`)
}).then(function(){
	return buyable.get_token_data(1)
}).then(function(instance){
	console.log(`...token data for token 1: ${instance}`)
}).then(function(){
	return buyable.get_token_data_buyable(1)
}).then(function(instance){
	console.log(`... is token 1 buyable? ${instance.toString().toUpperCase()}`)
}).catch(function(error) {
	console.log(error);
})

// }).then(function(){
// 	buyable.set_price_and_sell(1,100)
// 	console.log(`...called set_price_and_sell()`)
// }).then(function(instance){
// 	console.log(instance)
// }).catch(function(error){
// 	console.log(error)
// })
// .then(function(){
// 	return buyable.get_token_data_buyable(1);
// }).then(function(instance){
// 	returndata = instance;
// }).then(function(){
// 	console.log(`...is token 1 buyable? ${returndata.toString().toUpperCase()}`)
// }).then(function(){
// 	return buyable.get_all_sellable_token()
// }).then(function(instance){
// 	console.log(`...all sellable tokens: ${instance}`)
// }).then(function(){
// 	return buyable.get_token_data(1)
// }).then(function(instance){
// 	console.log(`...token data for token 1: ${instance}`)
// }).then(function(){
// 	return buyable.get_token_data_buyable(1)
// }).then(function(instance){
// 	console.log(`... is token 1 buyable? ${instance.toString().toUpperCase()}`)


// .then(function(){
// 	buyable.buy(3,{from:web3.eth.accounts[1], gas:50000000, value:100});
// }).then(function(){
// 	return erc721.balanceOf(web3.eth.accounts[0])
// }).then(function(instance){
// 	balance = instance.toNumber();
// }).then(function(){
// 	console.log(`tokens owned by coinbase: ${balance}`)
// }).then(function(){
// 	return erc721.balanceOf(web3.eth.accounts[1])
// }).then(function(instance){
// 	balance = instance.toNumber();
// }).then(function(){
// 	console.log(`tokens owned by web3.eth.accounts[1]: ${balance}`)
// }).then(function(){
// 	return bloom.balance({from:web3.eth.accounts[0]})
// }).then(function(instance){
// 	balance = instance.toNumber();
// }).then(function(){
// 	console.log(`balance of bloomingPool: ${balance} ETHER`)
// })

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
