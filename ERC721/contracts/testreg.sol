pragma solidity ^0.4.23;
import './ERC721BasicToken.sol';


contract testreg is ERC721BasicToken  {

    struct TokenStruct {
    string health;
    string blooming;
    string height;
  }

  mapping (uint256 => TokenStruct) TokenId;


}
