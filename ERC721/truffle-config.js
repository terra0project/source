var HDWalletProvider = require("truffle-hdwallet-provider");
// const dotenv = require('dotenv')
// require('dotenv').config()

// var mnemonic = process.env.MNEMONIC;
// var infura = process.env.INFURA;

module.exports = {
	networks: {
    	development: {
    		host: "localhost",
    		port: 8545,
    		network_id: "*" // Match any network id
		}
	}
};
