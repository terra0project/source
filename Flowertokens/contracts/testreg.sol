pragma solidity ^0.4.23;
import "./ERC721BasicToken.sol";

/**
* Minimal token registry for Flowertokens linking each token to its accompanying metadata 
 */

contract testreg is ERC721BasicToken  {

    struct TokenStruct {
        string token_uri;
    }

    /// @dev mapping of token identification number to uri containing metadata
    mapping (uint256 => TokenStruct) TokenId;

}
