// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";

contract DeployFactory is Script {
    function run() external returns (EscrowFactory factory) {
        uint256 deployerPrivateKey;
        uint256 chainId = block.chainid;
        if (chainId == 11155111) {
            deployerPrivateKey = uint256(vm.envBytes32("SEPOLIA_PRIVATE_KEY"));
            console.log("Using Sepolia private key");
        } else {
            deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY_DEPLOYER"));
            console.log("Using Anvil/deployer private key");
        }
        vm.startBroadcast(deployerPrivateKey);
        factory = new EscrowFactory();
        vm.stopBroadcast();
        console.log(" EscrowFactory deployed at:", address(factory));
    }
}
