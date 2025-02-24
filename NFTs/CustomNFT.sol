// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OpenZeppelinNFT is ERC721 {
    uint256 public tokenSupply = 0;
    uint256 public constant MaxSupply = 5;

    constructor() ERC721("NewNFT", "NN") {}

    function mint() external {
        require(tokenSupply < MaxSupply, "Tokens Sold Out");
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function withdraw() external {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    receive() external payable {} // Allow the contract to receive ETH
}
