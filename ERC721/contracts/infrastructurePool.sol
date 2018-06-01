pragma solidity ^0.4.23;

import './SafeMath.sol';
import "./acl.sol";

// infrastructure pool for terra0 flowertokens test

contract infrastructurePool is acl {

	using SafeMath for uint256;

	constructor() public {}

	function() payable {}

	function withdrawFunds() external check(2) {
		// fund withdrawal for admin account

	}
}
