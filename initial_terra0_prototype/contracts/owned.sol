pragma solidity ^0.4.2;

contract owned {
    function owned()
    { owner = msg.sender;
      oracle = msg.sender;
    }
    address public owner;
    address public oracle;

    modifier onlyOwner {
        if (msg.sender != owner)
            throw;
        _;
    }
    modifier onlyOracle {
        if (msg.sender != oracle)
            throw;
        _;
    }
    function transferOwnership_final() onlyOracle {
    owner = this;
  }
  function transferOwnership_Tree(){
  owner = msg.sender;
}
    function kill_switch() {
       if (msg.sender == owner) selfdestruct(owner);
     }
}
