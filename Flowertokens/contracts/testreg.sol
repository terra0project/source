pragma solidity ^0.4.23;
import "./ERC721BasicToken.sol";


contract testreg is ERC721BasicToken  {

	// @param

    struct TokenStruct {
        string token_uri;
    }

    mapping (uint256 => TokenStruct) TokenId;

}
