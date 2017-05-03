pragma solidity ^0.4.7;

contract sapling {
  ///this contract is written for terra0 saplings in the NEW WORLD ORDER exhibition @ furtherfield
  ///This is part of terra0
  ///http://www.furtherfield.org/programmes/exhibition/new-world-order
  ///not finished yet

uint public age_of_the_tree = now;
uint8 value = 1;
address public owner;
address public terra0adress;
uint block_time;
bool onetime = true;

function owned(){
owner = this;
terra0adress = msg.sender;
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
  age_of_the_tree =  ((age_of_the_tree - now)*uint(-1))  * 1 minutes;
  //value =
  //return age_of_the_tree;
  //uint new_time = last_block_number
  //last_block_number + ((future_time - time_now) / block_time)
}

//web3.eth
//web3.eth.sendTransaction({from:web3.eth.coinbase, to:'0xdfCE4d0Ce94E3644c510EA027f2DBA838811BA1F', value: 50})

}
