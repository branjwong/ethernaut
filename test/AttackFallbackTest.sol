// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {AttackFallback} from "../src/AttackFallback.sol";
import {Fallback} from "../victims/Fallback.sol";

contract FallbackAttackTest is Test {
    Fallback victim;
    AttackFallback attackFallback;

    address ATTACKER = makeAddr("attacker");

    function setUp() public {
        victim = new Fallback();

        vm.prank(ATTACKER);
        attackFallback = new AttackFallback(victim);
    }

    function test_canAttackFallback() public {
        vm.deal(address(attackFallback), 0.0001 ether);
        vm.deal(ATTACKER, 0.0001 ether);

        vm.prank(ATTACKER);
        attackFallback.attack{value: 0.0001 ether}(0.0001 ether);

        vm.prank(ATTACKER);
        attackFallback.withdraw();

        assertEq(address(victim).balance, 0);
        assertEq(address(ATTACKER).balance, 0.0002 ether);
        assertEq(victim.owner(), address(attackFallback));
    }
}
