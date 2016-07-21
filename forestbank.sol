contract token {
    uint256 public numCoinTypes;
    uint256 public supply;
    uint256 public buyPrice_WoodToken;
    uint256 public sellPrice_Terra0_Token;
    address public owner;

    mapping (uint => mapping (address => uint)) public coinBalanceOf;

    event CoinTransfer(uint coinType, address sender, address receiver, uint amount);

    /* Initializes contract with initial supply tokens to the creator of the contract */
   function token() {
     buyPrice_WoodToken = 20000000000000000;
     sellPrice_Terra0_Token = 20000000000000000;
     supply = 200000;
     owner = msg.sender;
     numCoinTypes = 2;
     for (uint k=0; k<numCoinTypes; ++k) {
       coinBalanceOf[k][msg.sender] = supply;
     }
   }

   function sendCoin(uint coinType, address receiver, uint amount) returns(bool sufficient) {
     if (coinBalanceOf[coinType][msg.sender] < amount) return false;
     /* if (coinBalanceOf[coinType][receiver]  + amount < coinBalanceOf[coinType][receiver]) throw;*/
     coinBalanceOf[coinType][msg.sender] -= amount;
     coinBalanceOf[coinType][receiver] += amount;
     CoinTransfer(coinType, msg.sender, receiver, amount);
     return true;
   }


   function sell(uint256 amount) {
       if (coinBalanceOf[0][msg.sender] < amount ) throw;        // checks if the sender has enough to sell
       coinBalanceOf[0][this] += amount;                         // adds the amount to owner's balance
       coinBalanceOf[0][msg.sender] -= amount;                   // subtracts the amount from seller's balance
       if (!msg.sender.send(amount * sellPrice_Terra0_Token)) {        // sends ether to the seller
           coinBalanceOf[0][msg.sender] += amount;
       }
       CoinTransfer(0,msg.sender, this, amount);                // executes an event reflecting on the change
   }

   function buy() {
       uint amount = msg.value / buyPrice_WoodToken;                // calculates the amount
       if (coinBalanceOf[1][this] < amount) throw;               // checks if it has enough to sell
       coinBalanceOf[1][msg.sender] += amount;                   // adds the amount to buyer's balance
       coinBalanceOf[1][this] -= amount;                         // subtracts amount from seller's balance
       CoinTransfer(1,this, msg.sender, amount);                // execute an event reflecting the change
   }
 }
