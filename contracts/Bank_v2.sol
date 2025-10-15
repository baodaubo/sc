// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bank is ReentrancyGuard, Ownable {
    mapping(address => uint256) private _balances;
    bool public isPaused;

    event Deposited(address indexed user, uint256 amount);
    event Withdrew(address indexed user, uint256 amount);
    event Paused(address indexed admin);

    constructor(address initialOwner) Ownable(initialOwner) {
        // Initialize Ownable with the initialOwner
    }

    // Deposit ETH into the bank
    function deposit() external payable nonReentrant {
        _balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    // Withdraw ETH from the bank
    function withdraw(uint256 amount) external nonReentrant {
        require(!isPaused, "Bank is paused");
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrew(msg.sender, amount);
    }

    // Check balance
    function getBalance() external view returns (uint256) {
        return _balances[msg.sender];
    }

    // Admin functions
    function pause() external onlyOwner {
        isPaused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner {
        isPaused = false;
    }

    // Fallback to prevent accidental ETH sends
    fallback() external payable {
        revert("Use deposit() instead");
    }

    receive() external payable {
        revert("Use deposit() instead");
    }
}