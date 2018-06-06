var HDWalletProvider = require("truffle-hdwallet-provider");
const dotenv = require('dotenv')

var mnemonic = process.env.MNEMONIC;
var infura = process.env.INFURA;

module.exports = {
	networks: {
    	development: {
    		host: "localhost",
    		port: 8545,
    		network_id: "*" // Match any network id
		}
	},
		ropsten: {
			provider: function() {
				return new HDWalletProvider(mnemonic, `https://ropsten.infura.io/${infura}`)
			},
			network_id: 3
		}
};
