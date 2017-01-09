pragma solidity ^0.4.2;
contract token {
    uint256 public supply;
    uint256 public buyPrice_WoodToken;
    address public owner;

    //mapping (uint => mapping (address => uint)) public coinBalanceOf;
    mapping (address => uint ) public coinBalanceOf;

    event CoinTransfer(address sender, address receiver, uint amount);

    /* Initializes contract with initial supply tokens to the creator of the contract */
   function token() {
     buyPrice_WoodToken = 20000000000000000;
     supply = 200000;
     owner = msg.sender;
     coinBalanceOf[this] = supply;
   }

   /*function sendCoin(uint coinType, address receiver, uint amount) returns(bool sufficient) {
     if (coinBalanceOf[coinType][msg.sender] < amount) return false;
     coinBalanceOf[coinType][msg.sender] -= amount;
     coinBalanceOf[coinType][receiver] += amount;
     CoinTransfer(coinType, msg.sender, receiver, amount);
     return true;
   }*/

   function buy() {
       uint amount = msg.value / buyPrice_WoodToken;                // calculates the amount
       if (coinBalanceOf[this] < amount) throw;               // checks if it has enough to sell
       coinBalanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
       coinBalanceOf[this] -= amount;                         // subtracts amount from seller's balance
       CoinTransfer(this, msg.sender, amount);                // execute an event reflecting the change
   }


function balance_check_self()constant returns (uint256){
  return coinBalanceOf[this];
}
function balance_check()constant returns (uint256){
  return coinBalanceOf[msg.sender];
}
//0xef2b00a741a534bf2785b2e5bdd276b8bac42c6
//web3.eth.getBalance.request('0x3333333333333333333333333333333333333333')
//var balance = web3.eth.getBalance("0x3333333333333333333333333333333333333333");
//console.log(balance); // instanceof BigNumber
//console.log(balance.toString(10)); // '1000000000000'
//console.log(balance.toNumber()); // 1000000000000

/*struct Dataset {
        int max_alter;
        int preis_pro_qm;
  }

  mapping(string => Dataset) DataTreespecs;

  struct Tree {
        int value1;
        int indexvalue;
  }

mapping(int => Tree) public dataItems;



function getvalue1(string treetype) constant returns (int) {
return DataTreespecs[treetype].max_alter;
}

function addDataItem(string treetype,int alter) {
DataTreespecs[treetype].max_alter = alter;
}


  function addTreeItem(int _value0,int _value1)onlyOwner(){
        if (_value0 == dataItems[_value0].indexvalue){
        indexcount = indexcount -1;
        }

        dataItems[_value0].indexvalue = _value0;
        dataItems[_value0].value1= _value1;
        indexcount = indexcount + 1;
  }


    function getvalue1(int _number) constant returns (int) {
        return dataItems[_number].value1;
    }


    function numberdic() constant returns (int) {
        return indexcount;
    }
    function sumvalues() constant returns (int){
     int sum = 0;
      for(int i=0;i<=indexcount;i++){
       sum = sum + dataItems[i].value1;
      }
      return sum;
    }*/
  }

//indexof.indexOf.sendTransaction("I am cool", "cool", {from:eth.coinbase,gas:3141592, gasprice:50000000000});
