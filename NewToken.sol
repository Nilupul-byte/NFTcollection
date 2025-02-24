// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomERC20 is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; // 1 million tokens
    uint256 public constant TOKEN_PRICE = 1 ether / 1000; // 1 ETH = 100 Tokens
    uint256 public constant REFUND_RATE = 0.5 ether / 1000; // 1000 tokens = 0.5 ETH

    mapping(address => bool) public blacklist; // Stores sanctioned addresses

    constructor() ERC20("Nilupul", "NIL") Ownable(msg.sender) {
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


     function _beforeTokenTransfer(address from, address to) internal virtual {
    require(!blacklist[from], "Sender is blacklisted");
    require(!blacklist[to], "Receiver is blacklisted");
}


    // ************* ERC20 with Token Sale *************

    function buyTokens() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");

        // Calculate the number of tokens to mint
        uint256 tokensToMint = (msg.value * 100) / 1 ether; // 1 ETH = 100 Tokens

        // Scale tokens to 18 decimals
        uint256 tokensWithDecimals = tokensToMint * 10**18; 

        // Ensure max supply is not exceeded
        require(totalSupply() + tokensWithDecimals <= MAX_SUPPLY, "Max supply reached");

        // Mint the tokens and transfer them to the sender
        _mint(msg.sender, tokensWithDecimals);
    }

    // ************* ERC20 with Partial Refund *************

    function sellBack(uint256 tokenAmount) external {
        require(balanceOf(msg.sender) >= tokenAmount, "Not enough tokens");

        // Calculate the refund amount in ETH
        uint256 refundAmount = (tokenAmount * REFUND_RATE) / (10**18);
        
        require(address(this).balance >= refundAmount, "Contract lacks ETH");

        // Burn the tokens and send ETH to the user
        _burn(msg.sender, tokenAmount);
        payable(msg.sender).transfer(refundAmount);
    }

    // ************* Contract Management Functions *************

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
