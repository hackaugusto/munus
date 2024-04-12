// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Munus.sol";

contract CounterScript is Script {

    public Munus munus;

    function setUp() public {}

    function run() public {
        vm.broadcast();
        munus = new Munus();
        vm.stopBroadcast();
    }
}
