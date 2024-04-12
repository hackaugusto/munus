// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Munus} from "../src/Munus.sol";

contract MunusTest is Test {
    Munus munus;

    function setUp() public {
        munus = new Munus();
    }

    function test_trampoline() public {
        bytes32 hash = "0";
        address payable alice = payable(address(0x01));
        munus.trampoline(hash, alice);
    }

    function test_transfer() public {
        address payable alice = payable(address(0x01));

        assertEq(alice.balance, 0);

        bytes32 hash1 = "1";
        munus.trampoline{value:3}(hash1, alice);
        assertEq(alice.balance, 3);

        bytes32 hash2 = "2";
        munus.trampoline{value:7}(hash2, alice);
        assertEq(alice.balance, 10);
    }

    function test_trampolineTwiceFails() public {
        bytes32 hash = "3";
        address payable alice = payable(address(0x01));
        munus.trampoline{value:3}(hash, alice);

        vm.expectRevert(Munus.SecretAlreadyUsed.selector);
        munus.trampoline{value:7}(hash, alice);
    }
}
