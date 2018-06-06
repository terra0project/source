pragma solidity ^0.4.23;
import './update.sol';
import './ERC721BasicToken.sol';

contract buyable is update {

	address INFRASTRUCTURE_POOL_ADDRESS;
	address BLOOMING_POOL_ADDRESS;
    uint blooming_fee = 2;
    mapping (uint256 => uint256) TokenIdtoprice;

    event Set_price_and_sell(uint256 tokenId, uint256 Price);
    event Stop_sell(uint256 tokenId);

    constructor() public check(2){}

	function initialisation(address _infrastructure_address, address _blooming_address) public check(2){
        INFRASTRUCTURE_POOL_ADDRESS = _infrastructure_address;
        BLOOMING_POOL_ADDRESS = _blooming_address;
    }

    function set_price_and_sell(uint256 UniqueID,uint256 Price) external { // add tests
        TokenIdtoprice[UniqueID] = Price;
        approve(address(this), UniqueID);
        emit Set_price_and_sell(UniqueID, Price);
    }

    function stop_sell(uint256 UniqueID) external payable { // add tests // why payable?
        require(tokenOwner[UniqueID] == msg.sender);
        clearApproval(tokenOwner[UniqueID],UniqueID);
        emit Stop_sell(UniqueID);
    }

	function buy(uint256 UniqueID) external payable {
	    address _to =  msg.sender;
		require(TokenIdtoprice[UniqueID] == msg.value);
		uint _blooming = msg.value.div(20); // 5% to blooming
		uint _infrastructure = msg.value.div(20); // 5% to infrastructure
		uint _combined = _blooming.add(_infrastructure); // msg.value / 10
		uint _amount_for_seller = msg.value.sub(_combined); // 90% to seller
		// to_seller(tokenOwner[UniqueID], _amount_for_seller);
        require(tokenOwner[UniqueID].send(_amount_for_seller));
		/* tokenOwner[UniqueID].call.gas(99999).value(_amount_for_seller)(); */
		this.transferFrom(tokenOwner[UniqueID], _to, UniqueID);
		/* BLOOMING_POOL_ADDRESS.call.gas(99999).value(_blooming)(); */
		// to_blooming_pool(_blooming);
        require(BLOOMING_POOL_ADDRESS.send(_blooming));
		/* INFRASTRUCTURE_POOL_ADDRESS.call.gas(99999).value(_infrastructure)(); */
		// to_infrastructure_pool(_infrastructure);
        require(INFRASTRUCTURE_POOL_ADDRESS.send(_infrastructure));
    }

	function to_seller(address _to, uint _amount) private payable { // !!! THIS WAS A PUBLIC FUNCTION !!!
		// _to.call.gas(99999).value(_amount)(); // currently unoptimized for maximum gas price in development
	}

	function to_blooming_pool(uint _amount) private payable { // !!! THIS WAS A PUBLIC FUNCTION !!
		// BLOOMING_POOL_ADDRESS.call.gas(99999).value(_amount)();
	}

	function to_infrastructure_pool(uint _amount) private payable {  // !!! THIS WAS A PUBLIC FUNCTION !!
		// INFRASTRUCTURE_POOL_ADDRESS.call.gas(99999).value(_amount)();
	}

    function get_token_data(uint256 _tokenId) external view returns(string _health, string _height, string _blooming, uint256 _price, bool _buyable) {
        _health =  TokenId[_tokenId].health;
        _height = TokenId[_tokenId].height;
        _blooming = TokenId[_tokenId].blooming;
        _price = TokenIdtoprice[_tokenId];
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true; // if allowed via some other contract it will return true but not be buyable
        }
    }

    function get_token_data_buyable(uint256 _tokenId) external view returns(bool _buyable) {
        if (tokenApprovals[_tokenId] != address(0)){
            _buyable = true; // if allowed via some other contract it will return true but not be buyable
        }
    }

    function get_all_sellable_token() external view returns(bool[101] list_of_available){ // views are free
    uint i;
    for(i=0;i<101;i++) {
          if (tokenApprovals[i] != address(0)){ // not true see above
            list_of_available[i] = true;
          }else{
            list_of_available[i] = false;
          }
        }
    }

}
