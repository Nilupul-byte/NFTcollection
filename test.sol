// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    string private message;

    // Function to set a message
    function setMessage(string memory _message) public {
        message = _message;
    }

    // Function to get the message
    function getMessage() public view returns (string memory) {
        return message;
    }
}