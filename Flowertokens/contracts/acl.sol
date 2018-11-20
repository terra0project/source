pragma solidity ^0.4.23;

/**
* This is the first version of a simple ACL / Permission Management System
* It might differentiate from other Permission Management Systems and therefore be more restrictive in the following points:
* Every User can just have one Role
* No new Roles can be generated
* Therefore all possible Roles must be defined at the beginning
 */

contract acl{

    enum Role {
        USER,
        ORACLE,
        ADMIN
    }

    /// @dev mapping address to particular role
    mapping (address=> Role) permissions;

    /// @dev constructor function to map deploying address to ADMIN role
    constructor() public {
        permissions[msg.sender] = Role(2);
    }

    /// @dev function to map address to certain role
    /// @param rolevalue uint to set role as either USER, ORACLE, or ADMIN
    /// @param entity address to be mapped to particlar role
    function setRole(uint8 rolevalue,address entity)external check(2){
        permissions[entity] = Role(rolevalue);
    }

    /// @dev function to return role of entity based on address
    /// @param entity address of entity who's role is to be returned
    /// @return returns role of entity
    function getRole(address entity)public view returns(Role){
        return permissions[entity];
    }

    /// @dev function modifier to check entity can call smart contract function
    modifier check(uint8 role) {
        require(uint8(getRole(msg.sender)) == role);
        _;
    }
}
