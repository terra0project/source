pragma solidity ^0.4.11;
import './testreg.sol';

contract buyable is testreg {

    mapping (uint256 => uint256) TokenIdtoprice;

    function set_price_and_sell(uint256 UniqueID,uint256 Price) external payable returns (address){
    TokenIdtoprice[UniqueID] = Price;
    this.approve(address(this), UniqueID);
    }

    function stop_sell(uint256 UniqueID) external payable{
    require(TokenIdtoadress[UniqueID] == msg.sender );
    _clearTokenApproval(UniqueID);
    }

    function buy(uint256 UniqueID)external payable{
    address _to =  msg.sender;
    /// add money stuff here :)
    this.transferFrom(TokenIdtoadress[UniqueID], _to, UniqueID);
    }

    function return_adress()returns (address self){
    ///just a temp function
    return address(this);
    }
}
