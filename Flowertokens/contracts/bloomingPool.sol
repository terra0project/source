pragma solidity ^0.4.23;
import "./update.sol";
import "./SafeMath.sol";

/// @dev altered version of Open Zepplin's 'SplitPayment' contract for use by Blooming Pool

contract bloomingPool is update {

    using SafeMath for uint256;

    uint256 public totalShares = 0;
    uint256 public totalReleased = 0;
    bool public freeze;

    /// @dev mapping address to number of held shares
    mapping(address => uint256) public shares;

    constructor() public {
        freeze = false;
    }

    /// @ dev fallback payment function
    function() public payable { }

    /// @dev function to calculate the total shares held by a user
    /// @param _shares number of shares mapped to the unique_id of a token
    /// @param unique_id unique id of token
    function calculate_total_shares(uint256 _shares,uint256 unique_id )internal{
        shares[tokenOwner[unique_id]] = shares[tokenOwner[unique_id]].add(_shares);
        totalShares = totalShares.add(_shares);
    }

    /// @dev function called by oracle to calculate the total shares for a given token
    /// @param unique_id id number of a token
    /// @modifier check(1) checks role of entity calling function by address has ORACLE role
    function oracle_call(uint256 unique_id) external check(1){
        calculate_total_shares(1,unique_id);
    }

    /// @dev function to find the number of shares held by entity calling function
    /// @return individual_shares returns uint of shares held by entity
    function get_shares() external view returns(uint256 individual_shares){
        return shares[msg.sender];
    }

    /// @dev emergency function to freeze withdrawls from Blooming Pool contract
    /// @param _freeze boolean to set global variable allowing / not allowing withdrawls
    /// @modifier check(2) checks role of entity calling function by address has ADMIN role
    function freeze_pool(bool _freeze) external check(2){
        freeze = _freeze;
    }

    /// @dev function to reset shares of entity to 0 after withdrawl
    /// @param address denotes entity to reset shares of to 0 by address
    function reset_individual_shares(address payee)internal {
        shares[payee] = 0;
    }

    /// @dev function to remove certain number of shares from entity's total share count
    /// @param _shares number of shares to remove from entity's total
    function substract_individual_shares(uint256 _shares)internal {
        totalShares = totalShares - _shares;
    }

    /// @dev function called by entity to claim number of shares mapped to address
    function claim()public{
        payout(msg.sender);
    }

    /// @dev function to payout Eth to entity
    /// @param to address of entity to transfer Eth
    function payout(address to) internal returns(bool){
        require(freeze == false);
        address payee = to;
        require(shares[payee] > 0);

        uint256 volume = address(this).balance;
        uint256 payment = volume.mul(shares[payee]).div(totalShares);

        require(payment != 0);
        require(address(this).balance >= payment);

        totalReleased = totalReleased.add(payment);
        payee.transfer(payment);
        substract_individual_shares(shares[payee]);
        reset_individual_shares(payee);
    }

    /// @dev emergency function to withdraw Eth from contract in case of OpSec failure
    /// @param amount amount of Eth to be transferred to entity calling function
    /// @modifier check(2) checks role of entity calling function by address has ADMIN role
    function emergency_withdraw(uint amount) external check(2) {
        require(amount <= this.balance);
        msg.sender.transfer(amount);
    }

}
