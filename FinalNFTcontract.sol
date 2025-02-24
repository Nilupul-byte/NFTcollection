// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract SimpleNFT {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 5;
    uint256 public constant PRICE = 0.00000001 ether;

    using Strings for uint256;

    mapping (uint => address) private _owners;
    mapping (address => mapping(address => bool)) private _operatorAdd;

    string baseURL = "ipfs.io/ipfs/bafybeigyxtgyjwasoz4ffsxzpicc6sf2pogx7hyuj2vntonufm4rvvsgr4/";

    // Mint Tokens
    function mint(uint256 _tokenId) external {
        require(_owners[_tokenId] == address(0), "Already Minted");
        require(_tokenId < MAX_SUPPLY, "Token Id is too Large");
        _owners[_tokenId] = msg.sender;
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "No such token");
        return owner;
    }

    // Transfer NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        address currentOwner = _owners[_tokenId];
        require(currentOwner != address(0), "Token does not exist");
        require(currentOwner == _from, "Cannot Transfer");
        require(msg.sender == _from || _operatorAdd[_from][msg.sender], "Require the Owner");

        // Reset operator approval for this transfer
        _operatorAdd[_from][msg.sender] = false;
        _owners[_tokenId] = _to;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_owners[_tokenId] != address(0), "Does not exist"); 
        return string(abi.encodePacked(baseURL, _tokenId.toString()));
    }

    // Approval
    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorAdd[msg.sender][_operator] = _approved;
    }
}
