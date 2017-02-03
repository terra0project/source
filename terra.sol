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


   /*function buy() payable returns (uint amount2){
       uint amount1 = msg.value / buyPrice_Wood_Token;              // calculates the amount
       if (coinBalanceOf[1][this] < amount1) throw;               // checks if it has enough to sell
       coinBalanceOf[1][msg.sender] += amount1;                   // adds the amount to buyer's balance
       coinBalanceOf[1][this] -= amount1;                         // subtracts amount from seller's balance
       CoinTransfer(1,this, msg.sender, amount1);
       return amount1;               // execute an event reflecting the change
   }*/

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
