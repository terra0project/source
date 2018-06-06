pragma solidity ^0.4.23;
import './testreg.sol';
import './SafeMath.sol';

/// @dev altered version of Open Zepplin's 'SplitPayment' contract

contract bloomingPool is testreg {

    using SafeMath for uint256;

    uint256 public totalShares = 0;
    uint256 public totalReleased = 0;

    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    address[] public payees;

    constructor(address[] _payees, uint256[] _shares) public payable {
        require(_payees.length == _shares.length);

        for (uint256 i = 0; i < _payees.length; i++) {
          addPayee(_payees[i], _shares[i]);
        }
    }

	function() public payable { } // fallback function for payment acceptance

    function addPayee(address _payee, uint256 _shares) internal {
		if (_payee != address(0)) {
			require(_shares > 0);
	        require(shares[_payee] == 0);

	        payees.push(_payee);
	        shares[_payee] = _shares;
	        totalShares = totalShares.add(_shares);
		}
    }

	function oracle_call() external check(1) {
		check_blooming();
		for (uint i=0;i<payees.length;i++){
			address to = payees[i];
			payout(to);
		}
		reset_shares();
		}

	function check_blooming() internal {
		for(uint i;i<101;i++) {
			if (compareStrings(TokenId[i].blooming, "1") == true) {
				addPayee(tokenOwner[i],1);
			}
		}
	}

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

	function reset_shares() internal {
		if (totalShares < 0){
			totalShares = 0;
		}
	}

	function compareStrings (string a, string b) internal returns(bool){
        return keccak256(a) == keccak256(b);
    }

}
