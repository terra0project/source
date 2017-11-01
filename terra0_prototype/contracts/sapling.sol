pragma solidity ^0.4.7;

contract sapling {
  ///this contract is written for terra0 saplings in the NEW WORLD ORDER exhibition @ furtherfield
  ///This is part of terra0
  ///http://www.furtherfield.org/programmes/exhibition/new-world-order
  ///not finished yet

address public owner = msg.sender;
address public terra0adress = msg.sender;
bool onetime = true;
uint256 public contractinit_time = now;
uint256 public age_of_the_tree;
uint256 public value = 0;
uint256 public startprice = 853608000000000000;
uint256 factor2 = 110079510;


modifier onlyterra0 {
    if (msg.sender != terra0adress)
        throw;
    _;
}

function changestartvalues(uint256 startpricenew, uint256 factor2new ) onlyterra0{
  startprice = startpricenew;
  factor2 = factor2new;
}


function transferOwnership(address newowner)internal{
owner = newowner;
if (onetime == true){
  if (!terra0adress.send(this.balance))
      throw;
  }
  onetime = false;
}

function get_Ownership()constant returns(address){
return owner;
}
function thebalance()constant returns(uint256){
return this.balance;
}
function get_age()constant returns(uint){
return age_of_the_tree;
}
function get_value()constant returns(uint){
return value;
}

function Purchase() payable {
uint amount = msg.value;
if (value > amount) throw;
uint rest = amount - value;
if (!msg.sender.send(rest))
    throw;
transferOwnership(msg.sender);
}

function calculatevalue(){
  age_of_the_tree = now - contractinit_time;
  uint256 calval = age_of_the_tree * factor2;
  value = startprice + calval;
}

//web3.eth
//web3.eth.sendTransaction({from:web3.eth.coinbase, to:'0xdfCE4d0Ce94E3644c510EA027f2DBA838811BA1F', value: 50})

}
