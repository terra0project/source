pragma solidity ^0.4.23;
import './SafeMath.sol';
import './ERC721.sol';
import './acl.sol';

contract testreg is ERC721, ERC721Metadata, acl  {

  using SafeMath for uint256;

  uint public numTokensTotal;

  event Transfer(address from, address to, uint256 tokenId);
  event Approval(address owner, address approved, uint256 tokenId);

  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);


  struct TokenStruct {
    string BCHTransactionid;
    bool isEntity;
    string health;
    string blooming;
    string height;
  }

  mapping (uint256 => TokenStruct) TokenId;

  mapping(address => uint256[]) ListofUniqueTokenIds;

  mapping (uint256 => address) TokenIdtoadress;

  mapping(uint256 => uint256) internal Pointer_TokenId;

  mapping(uint256 => address) internal TokenIdToApprovedAddress;

  mapping (address => mapping(address => bool)) internal OwnerToOperator;



function _writedata(address entityAddress, string entityData,uint256 UniqueID ) public{
    TokenId[UniqueID].BCHTransactionid = entityData;
    TokenId[UniqueID].isEntity = true;
    TokenIdtoadress[UniqueID]=entityAddress;
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
    require(TokenIdToApprovedAddress[_tokenId] == msg.sender || OwnerToOperator[TokenIdtoadress[_tokenId]][msg.sender]  == true ); /// || TokenIdToApprovedAddress[_tokenId] == address(this) );    /// its dangerous, probally not ERC721 conform
    require(TokenIdtoadress[_tokenId] == _from);
    require(_to != address(0));

    transferownership(_from, _to, _tokenId);

    emit Approval(_from, 0, _tokenId);
    emit Transfer(_from, _to, _tokenId);
    }


function approve(address _approved, uint256 _tokenId) external payable{
    require (TokenId[_tokenId].isEntity== true);   //entity exists and is tracked // OwnerToOperator[[TokenIdtoadress[_tokenId]]][msg.sender]
    require(msg.sender == TokenIdtoadress[_tokenId] || OwnerToOperator[TokenIdtoadress[_tokenId]][msg.sender]  == true ); ////// // || msg.sender == address(this)  );  //its dangerous, probally not ERC721 conform

    if (_getApproved(_tokenId) != address(0) || _approved != address(0)) {
            _approve(_approved, _tokenId);
            emit Approval(msg.sender, _approved, _tokenId);
        }
}



function setApprovalForAll(address _to, bool _approved) external {
    require(_to != msg.sender);
    OwnerToOperator[msg.sender][_to] = _approved;
}


function isApprovedForAll(address _owner, address _operator) external view returns (bool){
    return OwnerToOperator[_owner][_operator];
}


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
    return "flowertokens_test";
}

function symbol() external pure returns (string _symbol){
    return "TTT";
}

function tokenURI(uint256 _tokenId) external view returns (string){
    return TokenId[_tokenId].BCHTransactionid ;
}

/// ERC721TokenReceiver Needs to be implemented as well as save tranfer
/// Mint function

function Mint(address entityAddress, string entityData) external check(2) returns (uint256 _UniqueID) {
    uint256 UniqueID = numTokensTotal.add(1) ;
    _writeownership(entityAddress,UniqueID);
    _writedata(entityAddress,entityData,UniqueID);
    numTokensTotal= numTokensTotal.add(1);
    return UniqueID;
    }

//// Safe Transfer Methods

}
