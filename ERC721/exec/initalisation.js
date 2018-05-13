acl.setProvider(web3.currentProvider);
blooming_pool.setProvider(web3.currentProvider);
buyable.setProvider(web3.currentProvider);
ERC721.setProvider(web3.currentProvider);
SplitPayment.setProvider(web3.currentProvider);
testreg.setProvider(web3.currentProvider);
update.setProvider(web3.currentProvider);

/// @dev deployed contracts
var acl;
var bloom;
var buyable;
var erc;
var testreg;
var update;

acl.deployed()
.then(function(instance){
	acl = instance;
}).then(function(){
	return blooming_pool.deployed()
}).then(function(instance){
	bloom = instance;
}).then(function(){
	return buyable.deployed()
}).then(function(instance){
	buyable = instance;
}).then(function(){
	return ERC721.deployed()
}).then(function(instance){
	erc = instance;
}).then(function(){
	return testreg.deployed()
}).then(function(instance){
	testreg = instance;
}).then(function(){
	return update.deployed()
}).then(function(instance){
	update = instance;
}).then(function(){
	console.log(`bloom_pool: ${bloom.address}\nacl:${acl.address}\nbuyable: ${buyable.address}\nERC721: ${erc.address}
		\ntestreg: ${testreg.address}\nupdate: ${update.address}`)
}).catch(function(error) {
	console.log(error);
});
