// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string public message;

    event MessageChanged2(address indexed who, string oldMsg, string newMsg);

    constructor(string memory _msg) {
        message = _msg;
    }

    function setMessage(string memory _new) public {
        string memory old = message;
        message = _new;
        emit MessageChanged2(msg.sender, old, _new);
    }

     function setMessage2(string memory _new) public {
        string memory old = message;
        message = _new;
        emit MessageChanged2(msg.sender, old, _new);
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}
