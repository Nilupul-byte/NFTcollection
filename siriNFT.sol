// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenZeppelinNFT is ERC721, Ownable {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant PRICE = 0.00000001 ether;

     string baseURL = "ipfs.io/ipfs/bafybeigqgtmsfvecsihusxuaqdx3mhjjdi5dpaga7u4eauhttoty3i7nme/";

   constructor() payable ERC721("SIRI NFT", "SIRI") Ownable (msg.sender) {

   }

   function mint() external payable {
      require(tokenSupply < MAX_SUPPLY, "supply used up");
      require(msg.value == PRICE, "Wrong Price");
     
     tokenSupply++;
     _mint(msg.sender, tokenSupply);
   }

  function viewBalance() external view returns (uint256) {
    return address(this).balance;
  } 

  function _baseURI() internal pure override returns (string memory) {
    return "ipfs.io/ipfs/bafybeigqgtmsfvecsihusxuaqdx3mhjjdi5dpaga7u4eauhttoty3i7nme/";
  }

   function withdraw() external onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  } 
}