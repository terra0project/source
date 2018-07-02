pragma solidity ^0.4.23;
import "./testreg.sol";

contract update is testreg {

    event UpdateToken(uint256 _tokenId, string new_uri);

    function updatetoken(uint256 _tokenId, string new_uri) external check(1){
        TokenId[_tokenId].token_uri = new_uri;

        emit UpdateToken(_tokenId, new_uri);
    }

    function _mint_with_uri(address _to, uint256 _tokenId, string new_uri) external check(2) {
        require(_to != address(0));
        addTokenTo(_to, _tokenId);
        numTokensTotal = numTokensTotal.add(1);
        TokenId[_tokenId].token_uri = new_uri;
        emit Transfer(address(0), _to, _tokenId);
    }
}
