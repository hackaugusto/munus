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
        address payable alice = payable(address(0x01));

        assertEq(alice.balance, 0);

        bytes32 hash1 = "1";
        vm.expectEmit(address(munus));
        emit Munus.DonationReceived(alice, hash1, 1e15);
        munus.trampoline{value:1e15}(hash1, alice);
        assertEq(alice.balance, 1e15);

        bytes32 hash2 = "2";
        vm.expectEmit(address(munus));
        emit Munus.DonationReceived(alice, hash2, 1e16);
        munus.trampoline{value:1e16}(hash2, alice);
        assertEq(alice.balance, 1e15 + 1e16);

        bytes32 hash3 = "3";
        vm.expectEmit(address(munus));
        emit Munus.DonationReceived(alice, hash3, 1e17);
        munus.trampoline{value:1e17}(hash3, alice);
        assertEq(alice.balance, 1e15 + 1e16 + 1e17);
    }

    function test_trampolineInvalidValueFails() public {
        address payable alice = payable(address(0x01));

        // 1 milli eth is the minimum
        bytes32 hash5 = "5";
        vm.expectRevert(Munus.InvalidAmount.selector);
        munus.trampoline{value:1e14}(hash5, alice);

        // Make sure values below/above the target are not accepted
        bytes32 hash6 = "6";
        vm.expectRevert(Munus.InvalidAmount.selector);
        munus.trampoline{value:1e15 - 1}(hash6, alice);

        bytes32 hash7 = "7";
        vm.expectRevert(Munus.InvalidAmount.selector);
        munus.trampoline{value:1e15 + 1}(hash7, alice);
    }

    function test_trampolineSameHashTwiceFails() public {
        bytes32 hash8 = "8";
        address payable alice = payable(address(0x01));
        munus.trampoline{value:1e15}(hash8, alice);

        vm.expectRevert(Munus.HashAlreadyUsed.selector);
        munus.trampoline{value:1e15}(hash8, alice);
    }
}
