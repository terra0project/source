pragma solidity ^0.4.23;
import './update.sol';

// All functions will only work if user verified contract as operator before:
// this can be done:
// function setApprovalForAll("Adress_of_contract", "True")

contract buyable is update {

    address BLOOMING_POOL_ADDRESS;
    address INFRASTRUCTURE_POOL_ADDRESS;
    uint blooming_fee = 2;
    mapping (uint256 => uint256) TokenIdtoprice;

    event Set_price_and_sell(uint256 tokenId, uint256 Price);
    event Stop_sell(uint256 tokenId);

    constructor(address _infrastructure_address, address _blooming_address){
        INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
        BLOOMING_POOL_ADDRESS = _blooming_address;
    }

    function set_price_and_sell(uint256 UniqueID,uint256 Price) external payable returns (address){
    TokenIdtoprice[UniqueID] = Price;
    this.approve(address(this), UniqueID);
    emit Set_price_and_sell(UniqueID, Price);
    }

    function stop_sell(uint256 UniqueID) external payable{
    require(TokenIdtoadress[UniqueID] == msg.sender );
    _clearTokenApproval(UniqueID);
    emit Stop_sell(UniqueID);
    }

    function buy(uint256 UniqueID)external payable{
    address _to =  msg.sender;
    uint _total = msg.value;
    uint _blooming = (_total / 20);
    uint _infrastructure = (_blooming / 20);
    this.transferFrom(TokenIdtoadress[UniqueID], _to, UniqueID);
    BLOOMING_POOL_ADDRESS.transfer(_blooming);
    INFRASTRUCTURE_POOL_ADDRESS.transfer(_infrastructure);
    }

    function get_token_data(uint256 _tokenId) external view returns(string _health,string _height, string _blooming,uint256 _price, bool _buyable ){
    _health =  TokenId[_tokenId].health;
    _height = TokenId[_tokenId].height;
    _blooming = TokenId[_tokenId].blooming;
    _price = TokenIdtoprice[_tokenId];
    if (TokenIdToApprovedAddress[_tokenId] != address(0)){
        _buyable = true;
    }
}

    function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable ){
    if (TokenIdToApprovedAddress[_tokenId] != address(0)){
        _buyable = true;
    }
    }

    function get_all_sellable_token()external view returns(bytes1[101] list_of_available){
    for(uint i;i<101;i++) {
          if (TokenIdToApprovedAddress[i-1] != address(0)){
            list_of_available[i] = 0x01;
          }else{
            list_of_available[i] = 0x00;
          }
        }
    }

}
