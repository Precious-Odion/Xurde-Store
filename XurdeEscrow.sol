// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XurdeEscrow {
    address public buyer;
    address public seller;
    uint public amount;
    bool public isFunded;
    bool public isCompleted;

    constructor(address _buyer, address _seller, uint _amount) {
        buyer = _buyer;
        seller = _seller;
        amount = _amount;
        isFunded = false;
        isCompleted = false;
    }

    function fund() public payable {
        require(msg.sender == buyer, "Only buyer can fund");
        require(!isFunded, "Already funded");
        require(msg.value == amount, "Incorrect amount");
        isFunded = true;
    }

    function confirmReceived() public {
        require(msg.sender == buyer, "Only buyer can confirm");
        require(isFunded, "Not funded");
        require(!isCompleted, "Already completed");
        payable(seller).transfer(amount);
        isCompleted = true;
    }

    function cancel() public {
        require(msg.sender == buyer || msg.sender == seller, "Not authorized");
        require(!isCompleted, "Already completed");
        payable(buyer).transfer(amount);
        isCompleted = true;
    }
}
