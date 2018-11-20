pragma solidity ^0.4.23;
import "./testreg.sol";

/**
* Functions to update metadata link for tokens and token minting on project initialisation
 */

contract update is testreg {

    event UpdateToken(uint256 _tokenId, string new_uri);

    /// @dev function to update the uri linked to a specified Flowertoken
    /// @param _tokenId unique identification number for specified Flowertoken
    /// @param new_uri new uri linking metadata to specified Flowertoken
    /// @modifier check(1) checks role of entity calling function by address has ORACLE role
    function updatetoken(uint256 _tokenId, string new_uri) external check(1){
        TokenId[_tokenId].token_uri = new_uri;

        emit UpdateToken(_tokenId, new_uri);
    }

    /// @dev function to mint Flowertokens with initial uri
    /// @param _to entity given ownership of minted Flowertoken
    /// @param _tokenId unique identification number for specified Flowertoken
    /// @param new_uri new uri linking metadata to specified Flowertoken
    /// @modifier check(2) checks role of entity calling function by address has ADMIN role
    function _mint_with_uri(address _to, uint256 _tokenId, string new_uri) external check(2) {
        require(_to != address(0));
        addTokenTo(_to, _tokenId);
        numTokensTotal = numTokensTotal.add(1);
        TokenId[_tokenId].token_uri = new_uri;
        emit Transfer(address(0), _to, _tokenId);
    }
}
