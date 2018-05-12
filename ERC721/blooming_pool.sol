pragma solidity ^0.4.23;
import './SplitPayment.sol';
import './buyable.sol';

/**
@title blooming_pool (abstraction layer atop certain functions from Open Zepplin's 'Split Payment'
	contract)
@dev Contract that pays funds owed to multiple payees who own tokens representing
	blooming flowers. Triggered by oracle every 24 hours. Pays out ETH according to proportion of
	of payee's held shares before resetting share count to 0.
*/

contract blooming_pool is SplitPayment, buyable {

	function oracle_call() /*modifier necessary*/ {
		check_blooming();
		for (uint i;i<payees.length;i++){
			address to = payees[i];
			payout(to);
		}
		reset_shares();
		}

	function check_blooming() internal {
		for(uint i;i<100;i++) {
			if (compareStrings(TokenId[i].blooming, "1") == true) {
				addPayee(TokenIdtoadress[i],1);
			}
		}
	}

	/// @dev (mostly) recycled code from claim() function in SplitPayment.sol which has been commented out
	function payout(address to) internal returns(bool){
		address payee = to;
		require(shares[payee] > 0);

	    uint256 totalReceived = address(this).balance.add(totalReleased);
	    uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);

	    require(payment != 0);
	    require(address(this).balance >= payment);

	    released[payee] = released[payee].add(payment);
	    totalReleased = totalReleased.add(payment);

	    payee.transfer(payment);
	}

	/// @dev this function shouldn't be necessary after payout loop in oracle_call but just in case..
	function reset_shares() internal{
		if (totalShares < 0){
			totalShares = 0;
		}
	}

	function compareStrings (string a, string b) view returns (bool){
       return keccak256(a) == keccak256(b);
   }

}
