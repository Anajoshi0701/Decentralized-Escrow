// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script, console} from "forge-std/script.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";

contract DeployFactory is Script {
    function run() external returns (EscrowFactory factory) {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY_DEPLOYER"));
        vm.startBroadcast(deployerPrivateKey);
        factory = new EscrowFactory();
        vm.stopBroadcast();
        console.log(" EscrowFactory deployed at:", address(factory));
    }
}