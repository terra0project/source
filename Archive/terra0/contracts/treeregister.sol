pragma solidity ^0.4.6;


contract treeregister {

  struct EntityStruct {
    bytes BCHTransactionid;
    bool isEntity;
  }


  mapping(address => mapping(bytes32 => EntityStruct)) internal entityStructs;
  mapping(address => uint)internal NumberofAssets;
  mapping(address => bool) internal KnownAdresses;
  address[] internal OwnerList;
  bytes32[] internal IDList;


  function isEntity(address entityAddress,bytes32 uniqueID) public constant returns(bool isIndeed) {
      return entityStructs[entityAddress][uniqueID].isEntity;
  }

  function isAdressknown(address entityAddress) public constant returns(bool isIndeed) {
      return KnownAdresses[entityAddress];
  }

  function getAllOwner() public constant returns(uint entityCount) {
    return OwnerList.length;
  }

  function getAllTrees() public constant returns(uint entityCount) {
    return IDList.length;
  }

  function getTreesof(address entityAddress) public constant returns(uint entityCount) {
    return NumberofAssets[entityAddress] ;
  }

  function newEntity(address entityAddress, bytes entityData) public returns(uint rowNumber, bytes32 _UniqueID) {
    bytes32 UniqueID = keccak256(entityData);
    if(isEntity(entityAddress,UniqueID)) revert();
    entityStructs[entityAddress][UniqueID].BCHTransactionid = entityData;
    entityStructs[entityAddress][UniqueID].isEntity = true;
    NumberofAssets[entityAddress]= NumberofAssets[entityAddress] +1;
    IDList.push(UniqueID);
    if  (isAdressknown(entityAddress)){
    return (0,UniqueID);
    }else{
    KnownAdresses[entityAddress] = true;
    return (OwnerList.push(entityAddress) - 1,UniqueID);  //somethingdontwork here
    }
    }

  function updateData(address entityAddress,bytes32 uniqueID,bytes entityData) public returns(bool success) {
    if(!isEntity(entityAddress,uniqueID)) revert();
    entityStructs[entityAddress][uniqueID].BCHTransactionid = entityData;
    return true;
  }

  function transferownership(address Owner, address NewOwner,bytes32 uniqueID)public returns(bool success){
    if(isEntity(Owner,uniqueID)){
    entityStructs[NewOwner][uniqueID].BCHTransactionid = entityStructs[Owner][uniqueID].BCHTransactionid;
    entityStructs[NewOwner][uniqueID].isEntity = true;
    entityStructs[Owner][uniqueID].isEntity = false;
    NumberofAssets[Owner]= NumberofAssets[Owner] -1;
    NumberofAssets[NewOwner]= NumberofAssets[NewOwner] +1; ///needs to add new ownwers
    return true;
    }
    else{
    return false;
    }
  }

}
