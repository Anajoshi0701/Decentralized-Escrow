// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract CreateEscrows is Script {
    using stdJson for string;

    struct EscrowInput {
        address buyer;
        address seller;
        address arbiter;
        uint256 amount;
        uint256 duration;
    }

    function run() external {
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY_DEPLOYER"));
        vm.startBroadcast(deployerPrivateKey);

        // Get the most recent EscrowFactory deployment
        address mostRecentFactory = DevOpsTools.get_most_recent_deployment("EscrowFactory", block.chainid);
        console.log("Using EscrowFactory at:", mostRecentFactory);

        EscrowFactory factory = EscrowFactory(mostRecentFactory);

        string memory json = vm.readFile("./escrows.json");
        uint256 count = json.readUint(".count");
        console.log("Found", count, "escrows in escrows.json");

        for (uint256 i = 0; i < count; i++) {
            string memory path = string.concat(".escrows[", vm.toString(i), "]");

            address buyer = json.readAddress(string.concat(path, ".buyer"));
            address seller = json.readAddress(string.concat(path, ".seller"));
            address arbiter = json.readAddress(string.concat(path, ".arbiter"));
            uint256 amount = json.readUint(string.concat(path, ".amount"));
            uint256 duration = json.readUint(string.concat(path, ".duration"));

            factory.createEscrow(buyer, seller, arbiter, amount, duration);

            console.log("Escrow created (index", i, "):");
            console.log("  buyer:   ", buyer);
            console.log("  seller:  ", seller);
            console.log("  arbiter: ", arbiter);
            console.log("  amount:  ", amount / 1e18, "ETH");
            console.log("  duration:", duration, "seconds");
        }

        vm.stopBroadcast();
    }
}
