pragma solidity ^0.4.11;
import './SaveMath.sol';
import './testreg.sol';
import './strings.sol';

contract update is testreg{

    using strings for *;

    event UpdateToken(uint256 _tokenId, string state);  /// "0,05.good.0"   1.Height  2.Health  3. Boolean Blooming

    function updatetoken(uint256 _tokenId, string state) external{
    var s = state.toSlice();
    TokenId[_tokenId].height = s.split(".".toSlice()).toString();   // part and return value is "www"
    TokenId[_tokenId].health = s.split(".".toSlice()).toString();  // part and return value is "google"
    TokenId[_tokenId].blooming = s.split(".".toSlice()).toString();

    UpdateToken(_tokenId, state);
    }
}
