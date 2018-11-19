pragma solidity ^0.4.23;
import "./bloomingPool.sol";
import "./ERC721BasicToken.sol";

contract buyable is bloomingPool {

    address INFRASTRUCTURE_POOL_ADDRESS;
    mapping (uint256 => uint256) TokenIdtosetprice;
    mapping (uint256 => uint256) TokenIdtoprice;

    event Set_price_and_sell(uint256 tokenId, uint256 Price);
    event Stop_sell(uint256 tokenId);

    constructor() public {}

    function initialisation(address _infrastructure_address) public check(2){
        INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
    }

    function set_price_and_sell(uint256 UniqueID,uint256 Price) external {
        approve(address(this), UniqueID);
        TokenIdtosetprice[UniqueID] = Price;
        emit Set_price_and_sell(UniqueID, Price);
    }

    function stop_sell(uint256 UniqueID) external payable{
        require(tokenOwner[UniqueID] == msg.sender);
        clearApproval(tokenOwner[UniqueID],UniqueID);
        emit Stop_sell(UniqueID);
    }

    function buy(uint256 UniqueID) external payable {
        address _to = msg.sender;
        require(TokenIdtosetprice[UniqueID] == msg.value);
        TokenIdtoprice[UniqueID] = msg.value;
        uint _blooming = msg.value.div(20);
        uint _infrastructure = msg.value.div(20);
        uint _combined = _blooming.add(_infrastructure);
        uint _amount_for_seller = msg.value.sub(_combined);
        require(tokenOwner[UniqueID].call.gas(99999).value(_amount_for_seller)());
        this.transferFrom(tokenOwner[UniqueID], _to, UniqueID);
        if(!INFRASTRUCTURE_POOL_ADDRESS.call.gas(99999).value(_infrastructure)()){
            revert("transfer to infrastructurePool failed");
		}
    }

    function get_token_data(uint256 _tokenId) external view returns(uint256 _price, uint256 _setprice, bool _buyable){
        _price = TokenIdtoprice[_tokenId];
        _setprice = TokenIdtosetprice[_tokenId];
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true;
        }
    }

    function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable) {
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true;
        }
    }

    function get_all_sellable_token()external view returns(bool[101] list_of_available){
        uint i;
        for(i = 0;i<101;i++) {
            if (tokenApprovals[i] != address(0)){
                list_of_available[i] = true;
          }else{
                list_of_available[i] = false;
          }
        }
    }
    function get_my_tokens()external view returns(bool[101] list_of_my_tokens){
        uint i;
        address _owner = msg.sender;
        for(i = 0;i<101;i++) {
            if (tokenOwner[i] == _owner){
                list_of_my_tokens[i] = true;
          }else{
                list_of_my_tokens[i] = false;
          }
        }
    }

}
