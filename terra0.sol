pragma solidity ^0.4.2;
contract terra0 {
  int indexcount = 0;
  address public owner = msg.sender;

  modifier onlyOwner() {
      if (msg.sender != owner) {
          throw;
      }
      _;
  }

struct Dataset {
  int max_age;
  int price;
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
  }

mapping(int => Tree) public dataItems;


  function addTreeitem(int index,int age,string kind,int mass,string location,string health,bool dead)onlyOwner() external {
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
        indexcount = indexcount + 1;
    }
    ///terra0.addTreeitem(1,200,'Eiche',42,'whateva','good','false',{gas:300000})

    function addDataItem(string treetype,int alter,int price)onlyOwner() {
    DataTreespecs[treetype].max_age = alter;
    DataTreespecs[treetype].price = price;
    }
    ///terra0.addDataItem('Eiche',99,30)

    function getmaxage(string treetype) constant returns (int) {
        return DataTreespecs[treetype].max_age;
    }
    ///terra0.getmaxage()
    function getvalue1(int _number) constant returns (int) {
        return dataItems[_number].age;
    }

    function numberdic() constant returns (int) {
        return indexcount;
    }
    function sumvalues() constant returns (int){
     int sum = 0;
      for(int i=0;i<=indexcount;i++){
       sum = sum + dataItems[i].mass;
      }
        return sum;
    }

    function algo()onlyOwner() constant returns (int) {
      int sum = 0;
      int total_mass = 0;
      for(int i=0;i<=indexcount;i++){
        if(dataItems[i].age > DataTreespecs[dataItems[i].kind].max_age){
        total_mass = total_mass + dataItems[i].mass;
        dataItems[i].dead = true;
        sum =sum +1;

      }
    }
        return sum;
    }

  }
