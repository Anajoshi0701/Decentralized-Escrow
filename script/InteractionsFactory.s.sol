// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {Escrow} from "../src/Escrow.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract InteractionsFactory is Script {
    function getEscrow(uint256 index) internal view returns (Escrow) {
        address factoryAddr = DevOpsTools.get_most_recent_deployment("EscrowFactory", block.chainid);
        EscrowFactory factory = EscrowFactory(factoryAddr);
        require(index < factory.getEscrowCount(), "Invalid escrow index");
        return factory.escrows(index);
    }

    function _startBroadcast(string memory rolePrefix, uint256 escrowIndex) internal {
        string memory key = string.concat(rolePrefix, vm.toString(escrowIndex));
        uint256 privateKey = vm.envUint(key);
        vm.startBroadcast(privateKey);
    }

    function deposit(uint256 index) public {
        Escrow escrow = getEscrow(index);
        uint256 amount = escrow.amount();

        _startBroadcast("PRIVATE_KEY_BUYER", index);
        escrow.deposit{value: amount}();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Buyer deposited %s ETH", index, amount / 1e18);
    }

    function release(uint256 index) public {
        Escrow escrow = getEscrow(index);

        _startBroadcast("PRIVATE_KEY_ARBITER", index);
        escrow.release();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Funds released to seller %s", index, escrow.seller());
    }

    function refund(uint256 index) public {
        Escrow escrow = getEscrow(index);

        _startBroadcast("PRIVATE_KEY_ARBITER", index);
        escrow.refund();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Funds refunded to buyer %s", index, escrow.buyer());
    }

    function disputeAsBuyer(uint256 index) public {
        Escrow escrow = getEscrow(index);

        _startBroadcast("PRIVATE_KEY_BUYER", index);
        escrow.dispute();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Dispute raised by buyer %s", index, escrow.buyer());
    }

    function disputeAsSeller(uint256 index) public {
        Escrow escrow = getEscrow(index);

        _startBroadcast("PRIVATE_KEY_SELLER", index);
        escrow.dispute();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Dispute raised by seller %s", index, escrow.seller());
    }

    function forceRefund(uint256 index) public {
        Escrow escrow = getEscrow(index);

        _startBroadcast("PRIVATE_KEY_BUYER", index);
        escrow.forceRefund();
        vm.stopBroadcast();

        console.log("Escrow[%s] => Buyer force refunded funds", index);
    }
}
