pragma solidity ^0.4.2;

import "./owned.sol";

contract Tree_sell is owned {
string Location;


  function Tree_sell (string location) {
      Location = location;

  }
  /*function ownership_transfer() {
  transferOwnership_Tree();

  }*/
  function returndata()public constant returns (string){
    return Location;
  }
  /*function buy_tree()payable public returns (string){
    token c = new token();
    c.buy();
    return Location;
  }*/
}
