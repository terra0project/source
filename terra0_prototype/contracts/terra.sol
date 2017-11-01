pragma solidity ^0.4.2;

import "./owned.sol";
import "./token.sol";
import "./Tree_sell.sol";

contract terra0 is owned, token {
  int indexcount = 0;
  address[] public newContracts;
  //int numboftokens = 0;

struct Dataset {
  int max_age;
  uint256 price;
  }

  mapping(string => Dataset) DataTreespecs;

  struct Tree {
    int age;
    string kind;
    int mass;
    string location; /// float
    string health;
    bool dead;
    int indexvalue;
    uint256 price;
  }

mapping(int => Tree) public dataItems;

function balance_check_WT_Tree(uint i)constant returns (uint256){
return coinBalanceOf[1][newContracts[i]];
}


  function addTreeitem(int index,int age,string kind,int mass,string location,string health,bool dead)onlyOracle() external {
        uint256 pricefortree = 0;
        if (index == dataItems[index].indexvalue){
        indexcount = indexcount -1;
        }
        dataItems[index].indexvalue = index;
        dataItems[index].age = age;
        dataItems[index].kind = kind;
        dataItems[index].mass = mass;
        dataItems[index].location = location;
        dataItems[index].health = health;
        dataItems[index].dead = dead;
        pricefortree = uint256(DataTreespecs[kind].price) * uint256(mass);
        dataItems[index].price = pricefortree;
        indexcount = indexcount + 1;
        mintToken(pricefortree);

    }
    ///terra0.addTreeitem(1,200,'Eiche',42,'whateva','good','false',{gas:1000000})

    function addDataItem(string treetype,int alter,uint256 price)onlyOracle() {
    DataTreespecs[treetype].max_age = alter;
    DataTreespecs[treetype].price = price;
    }
    ///terra0.addDataItem('Eiche',99,30)

  function getmaxage(string treetype) constant returns (int) {
        return DataTreespecs[treetype].max_age;
    }

    function getvalue1(int _number) constant returns (int) {
        return dataItems[_number].age;
    }

    /*function numberdic() constant returns (int) {
        return indexcount;
    }*/
    function buy_tree(uint indexnumber) payable returns (uint amount4){
        uint amount3 = msg.value / buyPrice_Wood_Token;              // calculates the amount
        if (coinBalanceOf[1][newContracts[indexnumber]] < amount3) throw;               // checks if it has enough to sell
        coinBalanceOf[1][msg.sender] += amount3;                   // adds the amount to buyer's balance
        coinBalanceOf[1][newContracts[indexnumber]] -= amount3;                         // subtracts amount from seller's balance
        CoinTransfer(1,newContracts[indexnumber], msg.sender, amount3);
        return amount3;               // execute an event reflecting the change

    }

    function algo()onlyOracle() {
      uint256 sum = 0;
      for(int i=0;i<=indexcount;i++){
        if(dataItems[i].age > DataTreespecs[dataItems[i].kind].max_age){
        dataItems[i].dead = true;
        address newContract = new Tree_sell(string(dataItems[i].location));
        newContracts.push(newContract);
        distributeCoin(1,newContract,dataItems[i].price);
        //&& dataItems[i].dead == false
      }

    }
    }
    /*function filltree()onlyOracle(){
      distributeCoin(1,newContracts[0],90);
    }*/
  }
///terra0.addDataItem('Eiche',99,30)
///terra0.addTreeitem(1,200,'Eiche',42,'whateva','good','false',{gas:1000000})
//terra0.algo({gas:4000000})
//terra0.newContracts()
//terra0.balance_check_WT_Tree(0)
//Tree_sell.buy_tree({value : 3000000})
//terra0.buy_tree(0,{value:20000000000000000,gas:4000000})

//terra0.filltree({gas:4000000})
//terra0.filltree({gas:4000000})
//'0xc7649a4c9d5f88b96f910ee0f84094bd664e83d9'


    /*function createContract (int location) {
    }*/

    /*function addcoins(uint256 a)onlyOracle(){
    mintToken(a);
    }*/
