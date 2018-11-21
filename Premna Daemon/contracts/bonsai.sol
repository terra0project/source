pragma solidity ^0.4.23;

/**
 * @title Bonsai
 * @dev The Bonsai contract has an attached adreess which can trigger actions, it also has varios pools
 * which can be tipped. This is more or less a wallet for a bot with diffrent pools.
 */

contract bonsai {
    address public trigger;
    mapping (string => uint256) poolbalance;
    mapping (string => uint256) portion;
    mapping (string => address) pooladresses;

/**
 * @dev The constructor sets the original `trigger` of the contract to the sender
 * account.
 */

    constructor() public {
        trigger = msg.sender;
    }

/**
  * @dev checks if value of message corresponding to set portion.
  * @param _pool string name of the pool.
  */

    modifier check_value(string pool) {
        assert (msg.value == portion[pool]);
        _;
    }

/**
  * @dev modifier for restricting functions to trigger adress
  */

    modifier restricted() {
        assert (msg.sender == trigger);
        _;
    }

/**
  * @dev set payout adress for a pool.
  * @param _pool string name of the pool, _address payout adress for pool
  */

    function set_adreses(string pool, address _address ) public  restricted {
        pooladresses[pool] = _address;
    }

/**
  * @dev set portion for a pool.
  * @param _pool string name of the pool, _pool_output input portion
  */

    function set_portion(string pool, uint256 _pool_output) public restricted {
        portion[pool] = _pool_output;
    }

/**
  * @dev tipping function for tip a specif pool.
  * @param _pool string name of the pool
  */

    function tip(string pool) public payable check_value(pool) {
        poolbalance[pool] += msg.value;
    }

/**
  * @dev function for payout a specific pool.
  * @param _pool string name of the pool
  */

    function payout_pool(string pool)public restricted {
        if(poolbalance[pool] >= portion[pool]){
            if(!pooladresses[pool].call.gas(99999).value(portion[pool])()){
                revert("transfer to address failed");
            }
            poolbalance[pool] = poolbalance[pool] - portion[pool];
      }
    }

    function check_pool(string pool) external view returns(uint256){
        return poolbalance[pool];
    }

    function check_adress(string pool) external view returns(address){
        return pooladresses[pool];
    }

}
