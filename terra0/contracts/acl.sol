pragma solidity 0.4.18;

//This is the first version of a simple ACL / Permission Management System
//It might differentiate from other Permission Management Systems and therefore be more restrictive in the following points:
// Every User can just have one Role (similar to a state machine)
// No new Roles "Positions" can be generated
// Therefore all possible Roles must be defined at the beginning


contract acl{

    enum Role {
        ANON,
        USER,
        ORACLE,
        ROOT
    }

    mapping(address => mapping (address=> Role)) permissions;

    function acl() internal {
        permissions[this][msg.sender] = Role(3);
    }


    function setRole(
        uint8 rolevalue,
        address app,
        address entity
    ) check(3) external
    {
      require(uint8(Role.ROOT) >= rolevalue);
      permissions[app][entity] = Role(rolevalue);
    }


    function getRole(
        address app,
        address entity
    )internal returns(Role)
    {
        return permissions[app][entity];
    }


   function getPermission(
       uint8 role,
       address app,
       address entity
    )public returns(bool actual_Permission)
    {
    if(uint8(getRole(app,entity)) == role )
    {
        return true;
    } else {
        return false;
    }
    }


    modifier check(uint8 role) {
         require(uint8(getRole(this,msg.sender)) == role);
        _;
    }
}
