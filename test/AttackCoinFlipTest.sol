// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {AttackCoinFlip} from "../src/AttackCoinFlip.sol";
import {CoinFlip} from "../victims/CoinFlip.sol";

contract CoinFlipAttackTest is Test {
    CoinFlip victim;
    AttackCoinFlip attackCoinFlip;

    address ATTACKER = makeAddr("attacker");

    function setUp() public {
        victim = new CoinFlip();

        vm.prank(ATTACKER);
        attackCoinFlip = new AttackCoinFlip(victim);
    }

    function test_canAttackCoinFlip() public {
        // vm.roll(block.number + 1);

        attackCoinFlip.attack();
        uint256 consecutiveWins = victim.consecutiveWins();

        assertEq(consecutiveWins, 10);
    }
}
