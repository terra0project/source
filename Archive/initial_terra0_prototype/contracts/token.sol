pragma solidity ^0.4.2;

import "./owned.sol";

contract token is owned {
    uint256 public numCoinTypes;
    uint256 public supply_Wood_Token;
    uint256 public supply_Terra0_Token;
    uint256 public buyPrice_Wood_Token;
    uint256 public sellPrice_Terra0_Token;
    //address public owner;
    uint256 public totalSupply_Wood_Token;
    uint256 public totalSupply_Terra0_Token;

    mapping (uint => mapping (address => uint)) public coinBalanceOf;

    event CoinTransfer(uint coinType, address sender, address receiver, uint amount);

    /* Initializes contract with initial supply tokens to the creator of the contract */
   function token() {
     buyPrice_Wood_Token = 20000000000000000;
     sellPrice_Terra0_Token = 20000000000000000;
     supply_Wood_Token = 0;
     supply_Terra0_Token = 20000000;
     owner = msg.sender;
     numCoinTypes = 2;
     totalSupply_Wood_Token = supply_Wood_Token;
     totalSupply_Terra0_Token = supply_Terra0_Token;
     coinBalanceOf[0][msg.sender] = supply_Terra0_Token;
     coinBalanceOf[1][this] = supply_Wood_Token;
   }

   function sendCoin(uint coinType, address receiver, uint amount) returns(bool sufficient) {
     if (coinBalanceOf[coinType][msg.sender] < amount) return false;
     /* if (coinBalanceOf[coinType][receiver]  + amount < coinBalanceOf[coinType][receiver]) throw;*/
     coinBalanceOf[coinType][msg.sender] -= amount;
     coinBalanceOf[coinType][receiver] += amount;
     CoinTransfer(coinType, msg.sender, receiver, amount);
     return true;
   }

   function distributeCoin(uint coinType, address receiver, uint amount) returns(bool sufficient) {
     if (coinBalanceOf[coinType][this] < amount) return false;
     /* if (coinBalanceOf[coinType][receiver]  + amount < coinBalanceOf[coinType][receiver]) throw;*/
     coinBalanceOf[coinType][this] -= amount;
     coinBalanceOf[coinType][receiver] += amount;
     CoinTransfer(coinType, this, receiver, amount);
     return true;
   }


   function sell(uint amount)public returns (uint revenue){
    if (coinBalanceOf[0][msg.sender] < amount ) throw;        // checks if the sender has enough to sell
    coinBalanceOf[0][this] += amount;                         // adds the amount to owner's balance
    coinBalanceOf[0][msg.sender] -= amount;                   // subtracts the amount from seller's balance
    revenue = amount * sellPrice_Terra0_Token;
    if (!msg.sender.send(revenue)) {                   // sends ether to the seller: it's important
        throw;                                         // to do this last to prevent recursion attacks
    } else {
        CoinTransfer(0,this, msg.sender, amount);             // executes an event reflecting on the change
        return revenue;                                 // ends function and returns
    }
}



   function mintToken(uint256 mintedAmount) onlyOracle {
       totalSupply_Wood_Token += mintedAmount;
       coinBalanceOf[1][this] += mintedAmount;
       CoinTransfer(1,0, this, mintedAmount);
   }

function balance_check_self_WT()constant returns (uint256){
  return coinBalanceOf[1][this];
}
function balance_check_WT()constant returns (uint256){
  return coinBalanceOf[1][msg.sender];
}
function balance_check_self_TT()constant returns (uint256){
return coinBalanceOf[0][this];
}
function balance_check_TT()constant returns (uint256){
return coinBalanceOf[0][msg.sender];
}
}
