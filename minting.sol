// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20ToNFT is ERC721, Ownable {
    IERC20 public immutable erc20Token;
    uint256 public totalSupply;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public constant MINT_COST = 10 * 10**18; // 10 ERC-20 tokens

    constructor(address _erc20Token) ERC721("SIRI NFT", "SIRI") Ownable(msg.sender) {
        erc20Token = IERC20(_erc20Token);
    }

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");

        // Ensure the user has approved the transfer
        require(erc20Token.transferFrom(msg.sender, address(this), MINT_COST), "ERC20 transfer failed");

        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function withdrawERC20() external onlyOwner {
        uint256 balance = erc20Token.balanceOf(address(this));
        require(balance > 0, "No tokens to withdraw");
        erc20Token.transfer(owner(), balance);
    }
}
