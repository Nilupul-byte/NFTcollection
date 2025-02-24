// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract SimpleNFT {

    uint256 public constant MAX_SUPPLY = 5;

    using Strings for uint256;

    mapping (uint => address) private _owners;

    string baseURL = "ipfs.io/ipfs/bafybeibd6khtm2joz2tuie6bu2ifkdvrng5f4y4r77vnkvkgrc6j5xsfvi/";

    // Mint Tokens
    function mint(uint256 _tokenId) external {
        require(_owners[_tokenId] == address(0), "Already Minted");
        require(_tokenId < MAX_SUPPLY, "Token Id is too Large");
        _owners[_tokenId] = msg.sender;
    }



    // Transfer Tokenslolo
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        address currentOwner = _owners[_tokenId];
        require(currentOwner != address(0), "Token does not exist");
        require(currentOwner == _from, "Not the owner");
        _owners[_tokenId] = _to;
    }

    // Get Token URI
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_owners[_tokenId] != address(0), "Does not exist"); 
        return string(abi.encodePacked(baseURL, _tokenId.toString()));
    }
}
