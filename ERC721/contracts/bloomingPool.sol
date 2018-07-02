pragma solidity ^0.4.23;
import "./update.sol";
import "./SafeMath.sol";

/// @dev altered version of Open Zepplin's 'SplitPayment' contract

contract bloomingPool is update {

    using SafeMath for uint256;

    uint256 public totalShares = 0;
    uint256 public totalReleased = 0;

    mapping(address => uint256) public shares;
    //mapping(address => uint256) public released;

    constructor() public {}

    function() public payable { } // fallback function for payment acceptance


    function calculate_total_shares(uint256 _shares,uint256 unique_id )internal{
        shares[tokenOwner[unique_id]] = shares[tokenOwner[unique_id]].add(_shares);
        totalShares = totalShares.add(_shares);
    }

    function oracle_call(uint256 unique_id) external check(1){
        calculate_total_shares(1,unique_id);
    }

    function get_shares() external view returns(uint256 individual_shares){
        return shares[msg.sender];
    }

    function reset_individual_shares(address payee)internal {
        shares[payee] = 0;
    }

    function substract_individual_shares(uint256 _shares)internal {
        totalShares = totalShares - _shares;
    }


    function claim()public{
        payout(msg.sender);
    }

    function payout(address to) internal returns(bool){
        address payee = to;
        require(shares[payee] > 0);

        uint256 volume = address(this).balance;   ///totalReleased need to go :(
        uint256 payment = volume.mul(shares[payee]).div(totalShares);
        /* uint256 totalReceived = address(this).balance.add(totalReleased);
        uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]); */

        require(payment != 0);
        require(address(this).balance >= payment);

        //released[payee] = released[payee].add(payment);
        totalReleased = totalReleased.add(payment);
        payee.transfer(payment);
        substract_individual_shares(shares[payee]);
        reset_individual_shares(payee);
    }


}
