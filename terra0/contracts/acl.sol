pragma solidity ^0.4.23;

//This is the first version of a simple ACL / Permission Management System
//It might differentiate from other Permission Management Systems and therefore be more restrictive in the following points:
// Every User can just have one Role (similar to a state machine)
// No new Roles "Positions" can be generated
// Therefore all possible Roles must be defined at the beginning


contract acl{

    enum Role {
        USER,
        ORACLE,
        ADMIN
    }

    mapping (address=> Role) permissions;

    constructor(){
    permissions[msg.sender] = Role(2);
    }

    function setRole(uint8 rolevalue,address entity)external check(2){
    permissions[entity] = Role(rolevalue);
    }

    function getRole(address entity)public view returns(Role){
        return permissions[entity];
    }

    modifier check(uint8 role) {
         require(uint8(getRole(msg.sender)) == role);
        _;
    }
}
