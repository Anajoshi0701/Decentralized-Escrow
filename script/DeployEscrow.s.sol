// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Escrow} from "../src/Escrow.sol";
import {stdJson} from "forge-std/StdJson.sol";

contract DeployEscrow is Script {
     using stdJson for string;
    function run() external returns (Escrow) {
         string memory json = vm.readFile("./escrows.json");

        address buyer = json.readAddress(".escrows[0].buyer");
        address seller = json.readAddress(".escrows[0].seller");
        address arbiter = json.readAddress(".escrows[0].arbiter");
        uint256 amount = json.readUint(".escrows[0].amount");
        uint256 duration = json.readUint(".escrows[0].duration");
        uint256 deployerPrivateKey = uint256(vm.envBytes32("PRIVATE_KEY_DEPLOYER"));

        vm.startBroadcast(deployerPrivateKey);
        Escrow escrow = new Escrow(buyer, seller, arbiter, amount, duration);

        vm.stopBroadcast();

        console.log("Escrow deployed at:", address(escrow));
        console.log("Buyer:", buyer);
        console.log("Seller:", seller);
        console.log("Arbiter:", arbiter);
        console.log("Amount:", amount);
        console.log("Duration:", duration);
        

        return escrow;
    }
}
