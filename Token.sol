//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomERC20 is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18; // 1 million tokens
    uint256 public constant TOKEN_PRICE = 1 ether / 1000 * 10**18; // 1 ETH = 1000 tokens with 18 decimals

    // Define refund rate as 0.5 ETH per 1000 tokens
uint256 public constant REFUND_RATE = (0.5 ether * 10**18) / 1000; // 1000 tokens = 0.5 ETH


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

    // Calculate the number of tokens to mint based on the sent ETH
    uint256 tokensToMint = (msg.value * 1000) / 1 ether; // 1 ETH = 1000 Tokens

    // Scale tokens to 18 decimals
    uint256 tokensWithDecimals = tokensToMint * 10**18; // Scale by 18 decimals to match token's precision
    
    // Check if minting the tokens exceeds the max supply
    require(totalSupply() + tokensWithDecimals <= MAX_SUPPLY, "Max supply reached");

    // Mint the tokens and transfer them to the sender
    _mint(msg.sender, tokensWithDecimals);
}



  



    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // ************* ERC20 with Partial Refund *************






function sellBack(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Not enough tokens");
        uint256 refundAmount = (amount * REFUND_RATE) / (1000 * 10**decimals());
        require(address(this).balance >= refundAmount, "Contract lacks ETH");

        _burn(msg.sender, amount);
        payable(msg.sender).transfer(refundAmount);
    }





    //balance

    function checkBalance(address account) public view returns (uint256) {
    return balanceOf(account);
}

//contract balance
function getContractBalance() public view returns (uint256) {
    return address(this).balance;
}


}