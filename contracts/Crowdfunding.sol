// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint public fundingGoal;
    uint public totalRaised;
    uint public deadline;
    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        fundingGoal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function 1: Contribute ETH
    function contribute() external payable {
        require(block.timestamp < deadline, "Funding period has ended");
        require(msg.value > 0, "Must send ETH to contribute");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    // Function 2: Withdraw funds if goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalRaised >= fundingGoal, "Funding goal not reached");
        payable(owner).transfer(address(this).balance);
    }

    // Function 3: Refund contributors if goal not met by deadline
    function refund() external {
        require(block.timestamp >= deadline, "Funding period not ended yet");
        require(totalRaised < fundingGoal, "Goal was reached, no refunds");

        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions found");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Function 4: Get contract balance
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    // Function 5: Get time remaining for the campaign
    function timeLeft() external view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
