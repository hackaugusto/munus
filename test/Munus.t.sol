// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Munus} from "../src/Munus.sol";

contract MunusTest is Munus {
    Munus public munus;

    function setUp() public {
        munus = new Munus();
    }

    function test_setSecret() public {
        bytes32 secret = "0";
        munus.setSecret(secret);
    }

    function testFail_setSecretTwiceFails() public {
        bytes32 secret = "1";
        munus.setSecret(secret);
        munus.setSecret(secret);
    }
}
