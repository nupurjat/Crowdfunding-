// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFunding {
    address public owner;
    uint public goal;
    uint public totalFunds;

    mapping(address => uint) public contributions;

    constructor(uint _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Contribute to the crowdfunding campaign
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Withdraw funds if goal is reached
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not reached");
        payable(owner).transfer(address(this).balance);
    }

    // Function 3 (optional utility): Check contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}

