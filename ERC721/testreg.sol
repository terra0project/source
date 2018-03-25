pragma solidity ^0.4.11;
import './SaveMath.sol';
import './ERC721.sol';

contract testreg is ERC721 {

  using SafeMath for uint256;

  uint public numTokensTotal;

  event Transfer(address from, address to, uint256 tokenId);
  event Approval(address owner, address approved, uint256 tokenId);

  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
    // event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved); ??

  struct TokenStruct {
    string BCHTransactionid;
    bool isEntity;
    bool verified;
  }

  mapping (uint256 => TokenStruct) TokenId;

  mapping(address => uint256[]) ListofUniqueTokenIds;

  mapping (uint256 => address) TokenIdtoadress;

  mapping(uint256 => uint256) internal Pointer_TokenId;

  mapping(uint256 => address) internal TokenIdToApprovedAddress;

  mapping(address => mapping(address => bool)) internal OwnerToOperator;


function _writedata(address entityAddress, string entityData,uint256 UniqueID ) public{
    TokenId[UniqueID].BCHTransactionid = entityData;
    TokenId[UniqueID].isEntity = true;
    TokenIdtoadress[UniqueID]=entityAddress;
    }

function newEntity(address entityAddress, string entityData) public returns(uint256 _UniqueID) {
    uint256 UniqueID = numTokensTotal.add(1) ;  ///uint256 UniqueID = numTokensTotal +1
    //if(isEntity(UniqueID)) revert();
    _writeownership(entityAddress,UniqueID);
    _writedata(entityAddress,entityData,UniqueID);
    numTokensTotal= numTokensTotal.add(1);
    return UniqueID;
    }

function _writeownership (address entityAddress,uint256 UniqueID ) public {
    ListofUniqueTokenIds[entityAddress].push(UniqueID);
    Pointer_TokenId[UniqueID] = ListofUniqueTokenIds[entityAddress].length-1;
    TokenIdtoadress[UniqueID]= entityAddress;
    }

function _removetoken (address Owner,uint256 uniqueID)public returns (uint256 list){
    require( TokenIdtoadress[uniqueID] == Owner); //check if token belongs to owner
    uint256 _Pointer = Pointer_TokenId[uniqueID]; //needs require otherwise will always delete index 0
    uint256 lastelement = ListofUniqueTokenIds[Owner][ListofUniqueTokenIds[Owner].length-1];
    ListofUniqueTokenIds[Owner][_Pointer] = lastelement ; ///overwrite element with last element
    delete lastelement; ///delete last element
    ListofUniqueTokenIds[Owner].length--;
    return ListofUniqueTokenIds[Owner].length;
    }

/// ERC721 Functions
function balanceOf(address _owner) external view returns (uint256 balance){
    return ListofUniqueTokenIds[_owner].length;
  }

 function ownerOf(uint256 _tokenId) external view returns (address){
    return TokenIdtoadress[_tokenId];
 }


 function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
    require (TokenId[_tokenId].isEntity== true);
    require(TokenIdToApprovedAddress[_tokenId] == msg.sender);
    require(TokenIdtoadress[_tokenId] == _from);
    require(_to != address(0));

    transferownership(_from, _to, _tokenId);

    Approval(_from, 0, _tokenId);
    Transfer(_from, _to, _tokenId);
    }

function approve(address _approved, uint256 _tokenId) external payable{
    require (TokenId[_tokenId].isEntity== true);   //entity exists and is tracked
    require(msg.sender == TokenIdtoadress[_tokenId]);
    /// require(msg.sender != _to); Why?

    if (_getApproved(_tokenId) != address(0) || _approved != address(0)) {
            _approve(_approved, _tokenId);
            Approval(msg.sender, _approved, _tokenId);
        }
}

///@dev Throws unless `msg.sender` is the current NFT owner. SUPER WEIRD

function setApprovalForAll(address _operator, bool _approved) external{
    //require(TokenIdToApprovedAddress[_tokenId] == msg.sender);
    for (uint i = 0; i < ListofUniqueTokenIds[msg.sender].length; i++){
        if (TokenIdtoadress[ListofUniqueTokenIds[msg.sender][i]] == TokenIdToApprovedAddress[i]){
            OwnerToOperator[TokenIdToApprovedAddress[i]][_operator] == _approved;
        }
    }
}


function isApprovedForAll(address _owner, address _operator) external view returns (bool){
    return OwnerToOperator[_owner][_operator];
}

    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none

function getApproved(uint256 _tokenId) external view returns (address){
    require (TokenId[_tokenId].isEntity== true);
    return TokenIdToApprovedAddress[_tokenId];
}


/// Internal functions

function transferownership(address Owner, address NewOwner,uint256 uniqueID)internal{
    _removetoken(Owner,uniqueID);
    _clearTokenApproval(uniqueID);
    _writeownership(NewOwner,uniqueID);
  }


function _getApproved(uint256 _tokenId) internal view returns (address _approved){
    return TokenIdToApprovedAddress[_tokenId];
    }


function _approve(address _to, uint256 _tokenId)internal{
    TokenIdToApprovedAddress[_tokenId] = _to;
    }


function _clearTokenApproval(uint256 _tokenId)internal{
    TokenIdToApprovedAddress[_tokenId] = address(0);
    }

///  Metadata Interface Function
/// pls read https://solidity.readthedocs.io/en/latest/contracts.html#abstract-contracts

function name() external pure returns (string _name){
    return "tulip0";
}

function symbol() external pure returns (string _symbol){
    return "TTT";
}

function tokenURI(uint256 _tokenId) external view returns (string){
    return TokenId[_tokenId].BCHTransactionid ;
}

/// ERC721TokenReceiver Needs to be implemented as well as save tranfer
/// Mint function

function Mint(address entityAddress, string entityData) public returns(uint256 _UniqueID) {
    uint256 UniqueID = numTokensTotal +1 ;
    //if(isEntity(UniqueID)) revert();
    _writeownership(entityAddress,UniqueID);
    _writedata(entityAddress,entityData,UniqueID);
    numTokensTotal= numTokensTotal +1;
    return UniqueID;
    }

//// Safe Transfer Methods

function isContract(address addr) internal view returns (bool) {
  uint size;
  assembly { size := extcodesize(addr) }
  return size > 0;
}

/* function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable{
   require (TokenId[_tokenId].isEntity== true);
   require(TokenIdToApprovedAddress[_tokenId] == msg.sender);
   require(TokenIdtoadress[_tokenId] == _from);
   require(_to != address(0));

   transferownership(_from, _to, _tokenId);
   //if (isContract(address _to) == true){

   //}
   Approval(_from, 0, _tokenId);
   Transfer(_from, _to, _tokenId);
   }


function callcontract(address _to,uint256 _tokenId, bytes data )internal returns(bytes4){
   address watch_addr  = _to;
   bytes4 backdata = watch_addr.call(bytes4(sha3("onERC721Received(address,uint256,bytes)")), this, _tokenId, data);
   return backdata;
}


function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4){
   return bytes4(keccak256(_from,_tokenId,data));
} */

}
