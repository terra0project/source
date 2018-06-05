pragma solidity ^0.4.23;

import './SafeMath.sol'; // not used
import "./acl.sol";

// infrastructure pool for terra0 flowertokens test

contract infrastructurePool is acl {

	using SafeMath for uint256;

	constructor() public {}

	function() payable {}

	function withdrawFunds(uint amount) external check(2) {
		require(amount <= this.balance);
		msg.sender.transfer(amount);
	}

}
