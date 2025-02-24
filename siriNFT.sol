// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenSeaNFT is ERC721, Ownable {
    uint256 public totalSupply;
    uint256 public constant MAX_SUPPLY = 10;
    string private constant BASE_URI = "ipfs.io/ipfs/bafybeigqgtmsfvecsihusxuaqdx3mhjjdi5dpaga7u4eauhttoty3i7nme/";

    constructor() ERC721("SIRI NFT", "SIRI") Ownable(msg.sender) {}

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");
        
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function _baseURI() internal pure override returns (string memory) {
        return BASE_URI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
