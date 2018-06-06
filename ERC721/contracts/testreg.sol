pragma solidity ^0.4.23;
import './ERC721BasicToken.sol';


contract testreg is ERC721BasicToken  {

	// @param growth_rate = 'growth rate in last 24hrs' returns 0 or 1
    struct TokenStruct {
    string growth_rate;
    string blooming;
    string height;
  }

  mapping (uint256 => TokenStruct) TokenId;

}
