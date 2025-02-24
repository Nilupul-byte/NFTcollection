// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomERC20 is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; // 1 million tokens with 18 decimals
    uint256 public constant TOKEN_PRICE = 1 ether / 1000; // 1 ETH = 1000 tokens
    uint256 public constant REFUND_RATE = 0.5 ether / 1000; // Sell 1000 tokens = 0.5 ETH

    mapping(address => bool) public blacklist; // Stores sanctioned addresses

    constructor() ERC20("CustomToken", "CTK") {
        _mint(msg.sender, 100_000 * 10**18); // Initial supply to owner
    }

    // ************* ERC20 with God-Mode *************

    function mintTokensToAddress(address recipient, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Max supply exceeded");
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(address target, uint256 newBalance) external onlyOwner {
        _burn(target, balanceOf(target)); // Burn existing balance
        _mint(target, newBalance); // Mint new balance
    }

    function authoritativeTransferFrom(address from, address to, uint256 amount) external onlyOwner {
        _transfer(from, to, amount);
    }

    // ************* ERC20 with Sanctions (Blacklist) *************

    function addToBlacklist(address user) external onlyOwner {
        blacklist[user] = true;
    }

    function removeFromBlacklist(address user) external onlyOwner {
        blacklist[user] = false;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!blacklist[from], "Sender is blacklisted");
        require(!blacklist[to], "Receiver is blacklisted");
        super._beforeTokenTransfer(from, to, amount);
    }

    // ************* ERC20 with Token Sale *************

    function buyTokens() external payable {
        uint256 amount = (msg.value * 1000) / 1 ether; // Calculate token amount based on 1 ETH = 1000 tokens
        require(totalSupply() + (amount * 10**decimals()) <= MAX_SUPPLY, "Max supply reached");

        _mint(msg.sender, amount * 10**decimals()); // Mint tokens for the sender
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance); // Withdraw ETH to the owner's address
    }

    // ************* ERC20 with Partial Refund *************

    function sellBack(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");
        uint256 refundAmount = (amount * REFUND_RATE) / (10**decimals()); // Calculate refund in ETH based on 1000 tokens
        require(address(this).balance >= refundAmount, "Contract lacks ETH");

        _burn(msg.sender, amount); // Burn tokens from the sender's account
        payable(msg.sender).transfer(refundAmount); // Transfer ETH to the sender
    }
}
