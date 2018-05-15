pragma solidity ^0.4.23;
import './update.sol';

contract buyable is update {

	address public INFRASTRUCTURE_POOL_ADDRESS;
	address public BLOOMING_POOL_ADDRESS;
	address public ERC721_ADDRESS;
    uint blooming_fee = 2;
    mapping (uint256 => uint256) TokenIdtoprice;

    event sell(uint256 tokenId, uint256 Price);
    event sell_stop(uint256 tokenId);

    constructor(address _infrastructure_address, address _blooming_address, address _erc_address) public check(2) {
        INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
        BLOOMING_POOL_ADDRESS = _blooming_address;
		ERC721_ADDRESS = _erc_address;
    }

    function set_price_and_sell(uint256 _uniqueID, uint256 _price) external {
		TokenIdtoprice[_uniqueID] = _price;
	    this.approve(this, _uniqueID);
		emit sell(_uniqueID, _price);
    }

    function stop_sell(uint256 UniqueID) external payable {
    require(tokenOwner[UniqueID] == msg.sender );
    clearApproval(tokenOwner[UniqueID],UniqueID);
    emit sell_stop(UniqueID);
    }

function buy(uint256 UniqueID) external payable {
// 		    uint _total = msg.value;
// 			if (_total !=TokenIdtoprice[UniqueID]){
// 				revert();
// 			} else {
// 				uint _blooming = (_total / 20);
// 			    uint _infrastructure = (_blooming / 20);
// 				uint _amount_for_seller = msg.value.sub(_blooming + _infrastructure);
// 				address _seller = tokenOwner[UniqueID];
// 				_seller.transfer(_amount_for_seller);
			    this.transferFrom(tokenOwner[UniqueID], msg.sender, UniqueID);
			 //   BLOOMING_POOL_ADDRESS.transfer(_blooming);
			 //   INFRASTRUCTURE_POOL_ADDRESS.transfer(_infrastructure);
	    }

    function get_token_data(uint256 _tokenId) external view returns(string _health,string _height, string _blooming,uint256 _price, bool _buyable ){
    _health =  TokenId[_tokenId].health;
    _height = TokenId[_tokenId].height;
    _blooming = TokenId[_tokenId].blooming;
    _price = TokenIdtoprice[_tokenId];
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true;
        }
    }

    function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable ){
    if (tokenApprovals[_tokenId] != address(0)){
        _buyable = true;
        }
    }

    function get_all_sellable_token() external view returns(bytes1[101] list_of_available){
    uint i;
    for(i=0;i<101;i++) {
          if (tokenApprovals[i] != address(0)){
            list_of_available[i] = 0x01;
          }else{
            list_of_available[i] = 0x00;
          }
        }
    }

}
