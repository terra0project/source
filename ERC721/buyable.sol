pragma solidity ^0.4.11;
import './update.sol';

// All functions will only work if user verified contract as operator before:
// this can be done:
// function setApprovalForAll("Adress_of_contract", "True")

contract buyable is update {

    mapping (uint256 => uint256) TokenIdtoprice;

    event Set_price_and_sell(uint256 tokenId, uint256 Price);
    event Stop_sell(uint256 tokenId);


    function set_price_and_sell(uint256 UniqueID,uint256 Price) external payable returns (address){
    TokenIdtoprice[UniqueID] = Price;
    this.approve(address(this), UniqueID);
    Set_price_and_sell(UniqueID, Price);
    }

    function stop_sell(uint256 UniqueID) external payable{
    require(TokenIdtoadress[UniqueID] == msg.sender );
    _clearTokenApproval(UniqueID);
    Stop_sell(UniqueID);
    }

    function buy(uint256 UniqueID)external payable{
    address _to =  msg.sender;
    /// add money stuff here :)
    this.transferFrom(TokenIdtoadress[UniqueID], _to, UniqueID);
    }

}
