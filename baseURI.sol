// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenSeaNFT is ERC721, Ownable {
    uint256 public totalSupply;
    uint256 public constant MAX_SUPPLY = 10;
    string private baseTokenURI;  

constructor(string memory baseURI_) ERC721("SIRI NFT", "SIRI") Ownable(msg.sender) {
    baseTokenURI = baseURI_;  // Use a different name for the constructor parameter
}

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");
        
       _safeMint(msg.sender, totalSupply);
        totalSupply++;
        
    }


    function _baseURI() internal view override returns (string memory) {
    return baseTokenURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
