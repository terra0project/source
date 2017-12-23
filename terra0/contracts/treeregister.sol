pragma solidity ^0.4.6;

///Not Tested and no ACL Implementation
/// Might merged together with an ERC721 Implementation 

contract treeregister {

  struct EntityStruct {
    uint entityData;
    bool isEntity;
  }

 mapping(address => mapping(bytes32 => EntityStruct)) public entityStructs;
 mapping(address => uint)NumberofIds;
 address[] public OwnerList;
 bytes32[] public IDList;


function isEntity(address entityAddress,bytes32 uniqueID) public
constant returns(bool isIndeed) {
      return entityStructs[entityAddress][uniqueID].isEntity;
  }

  function getAllOwner() public constant returns(uint entityCount) {
    return OwnerList.length;
  }

  function getAllTrees() public constant returns(uint entityCount) {
    return IDList.length;
  }
    function getTreesof(address entityAddress) public constant
returns(uint entityCount) {
    return NumberofIds[entityAddress] ;
  }

  function newEntity(address entityAddress, uint entityData) public
returns(uint rowNumber, bytes32 _UniqueID) {
    bytes32 UniqueID = keccak256(entityData);
    if(isEntity(entityAddress,UniqueID)) revert();
    entityStructs[entityAddress][UniqueID].entityData = entityData;
    entityStructs[entityAddress][UniqueID].isEntity = true;
    IDList.push(UniqueID);
    NumberofIds[entityAddress]+1;
    return (OwnerList.push(entityAddress) - 1,UniqueID);
  }

  function updateEntity(address entityAddress,bytes32 uniqueID,uint
entityData) public returns(bool success) {
    if(!isEntity(entityAddress,uniqueID)) revert();
    entityStructs[entityAddress][uniqueID].entityData    = entityData;
    return true;
  }

}
