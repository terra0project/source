var HDWalletProvider = require("truffle-hdwallet-provider");
const dotenv = require('dotenv')
require('dotenv').config()

var mnemonic = process.env.MNEMONIC;
var infura = process.env.INFURA;

module.exports = {
	networks: {
    	development: {
    		host: "localhost",
    		port: 8545,
    		network_id: "*" // Match any network id
		},
		ropsten: {
			provider: function() {
				return new HDWalletProvider(mnemonic, `https://ropsten.infura.io/${infura}`)
			},
			network_id: 3,
			gas: 4000000
		},
		mainnet: {
			provider: function() {
				return new HDWalletProvider(mnemonic, `https://mainnet.infura.io${infura}`)
			},
			network_id: 1,
			gas: 5000000
		}
	}
};
