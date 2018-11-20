pragma solidity ^0.4.23;
import "./bloomingPool.sol";
import "./ERC721BasicToken.sol";

/**
* Functions for purchase and selling of Flowertokens, as well as viewing availability of tokens. 
 */

contract buyable is bloomingPool {

    address INFRASTRUCTURE_POOL_ADDRESS;
    mapping (uint256 => uint256) TokenIdtosetprice;
    mapping (uint256 => uint256) TokenIdtoprice;

    event Set_price_and_sell(uint256 tokenId, uint256 Price);
    event Stop_sell(uint256 tokenId);

    constructor() public {}

    /// @dev function to set INFRASTRUCTURE_POOL_ADDRESS global var to address of deployed infrastructurePool contract
    /// @param _infrastructure_address address of deployed infrastructurePool contract
    /// @modifier check(2) checks role of entity calling function by address has ADMIN role
    function initialisation(address _infrastructure_address) public check(2){
        INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
    }

    /// @dev function to set the price of a Flowertoken and also put it up for sale
    /// @param UniqueID unique identification number of Flowertoken to be sold
    /// @param Price price Flowertoken is to be sold for
    function set_price_and_sell(uint256 UniqueID,uint256 Price) external {
        approve(address(this), UniqueID);
        TokenIdtosetprice[UniqueID] = Price;
        emit Set_price_and_sell(UniqueID, Price);
    }

    /// @dev function to take Flowertoken which is for sale off the market
    /// @param UniqueID unique identification number of Flowertoken to be sold
    function stop_sell(uint256 UniqueID) external payable{
        require(tokenOwner[UniqueID] == msg.sender);
        clearApproval(tokenOwner[UniqueID],UniqueID);
        emit Stop_sell(UniqueID);
    }

    /// @dev function to purchase Flowertoken
    /// @param UniqueID unique identification number of Flowertoken to be sold
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

    /// @dev function which returns the price and availability of specified Flowertoken
    /// @param _tokenId unique identification number of Flowertoken to be sold
    /// @return price and availability of specified Flowertoken
    function get_token_data(uint256 _tokenId) external view returns(uint256 _price, uint256 _setprice, bool _buyable){
        _price = TokenIdtoprice[_tokenId];
        _setprice = TokenIdtosetprice[_tokenId];
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true;
        }
    }

    /// @dev function which returns availability of specified Flowertoken
    /// @param _tokenId unique identification number of Flowertoken to be sold
    /// @return returns boolean denoting availability of specified Flowertoken
    function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable) {
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true;
        }
    }

    /// @dev function which returns array denoting availability of all Flowertokens
    /// @return array denoting availability of all Flowertokens
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

    /// @dev function which returns array denoting whether entity calling function is owner of each Flowertoken
    /// @return array denoting ownership of each Flowertoken
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
