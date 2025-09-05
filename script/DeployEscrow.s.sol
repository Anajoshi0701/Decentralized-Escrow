// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Escrow} from "../src/Escrow.sol";

contract DeployEscrow is Script {
    function run() external returns (Escrow) {
        address seller = vm.envAddress("SELLER");
        address arbiter = vm.envAddress("ARBITER");
        uint256 amount = vm.envUint("AMOUNT");
        uint256 duration = vm.envUint("DURATION");
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY_BUYER"));

        vm.startBroadcast(deployerPrivateKey);

        Escrow escrow = new Escrow(seller, arbiter, amount, duration);

        vm.stopBroadcast();

        console.log("Escrow deployed at:", address(escrow));
        console.log("Seller:", seller);
        console.log("Arbiter:", arbiter);
        console.log("Amount:", amount);
        console.log("Duration:", duration);

        return escrow;
    }
}
