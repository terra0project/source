pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./Ownable.sol";

contract infrastructurePool is Ownable {

    using SafeMath for uint256;

    constructor() public {}

    function() payable {}

    function withdrawFunds(uint amount) external onlyOwner {
        require(amount <= this.balance);
        msg.sender.transfer(amount);
    }

}
