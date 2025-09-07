/// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DeployEscrow} from "./DeployEscrow.s.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {Escrow} from "../src/Escrow.sol";

contract Interactions is Script {
    function getEscrow() internal view returns (Escrow) {
        address recentEscrow = DevOpsTools.get_most_recent_deployment("Escrow", block.chainid);
        return Escrow(payable(recentEscrow));
    }

    function _startBroadcast(string memory role) internal {
        uint256 privateKey = vm.envUint(role);
        vm.broadcast(privateKey);
    }

    function deposit() public {
        Escrow escrow = getEscrow();
        uint256 amount = escrow.amount();
        _startBroadcast("PRIVATE_KEY_BUYER0");
        escrow.deposit{value: amount}();
        console.log("Buyer deposited %s ETH into Escrow at %s", amount / 1e18, address(escrow));
    }

    function release() public {
        Escrow escrow = getEscrow();
        _startBroadcast("PRIVATE_KEY_ARBITER0");
        escrow.release();
        console.log("Funds released to seller: ", escrow.seller());
    }

    function refund() public {
        Escrow escrow = getEscrow();
        _startBroadcast("PRIVATE_KEY_ARBITER0");
        escrow.refund();
        console.log("Funds refunded to buyer: ", escrow.buyer());
    }

    function disputeAsBuyer() public {
        Escrow escrow = getEscrow();
        _startBroadcast("PRIVATE_KEY_BUYER0");
        escrow.dispute();
        console.log("dispute raised by buyer: ", escrow.buyer());
    }

    function disputeAsSeller() public {
        Escrow escrow = getEscrow();
        _startBroadcast("PRIVATE_KEY_SELLER0");
        escrow.dispute();
        console.log("dispute raised by seller: ", escrow.seller());
    }

    function forceRefund() public {
        Escrow escrow = getEscrow();
        _startBroadcast("PRIVATE_KEY_BUYER0");
        escrow.forceRefund();
        console.log("Buyer force refunded funds");
    }
}
