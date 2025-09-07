// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Escrow} from "../src/Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;

    address public buyer = address(1);
    address public seller = address(2);
    address public arbiter = address(3);
    uint256 public amount = 1 ether;
    uint256 public duration = 7 days;

    function setUp() public {
        vm.deal(buyer, 10 ether);
        vm.prank(buyer);
        escrow = new Escrow(buyer, seller, arbiter, amount, duration);
    }

    function testDeposit() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        assertEq(address(escrow).balance, amount);
    }

    function testDepositOnlyBuyer() public {
        hoax(seller, 10 ether);
        vm.expectRevert(Escrow.Escrow__NotBuyer.selector);
        escrow.deposit{value: amount}();
    }

    function testReleaseToSeller() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        uint256 sellerBalanceBefore = seller.balance;

        vm.prank(arbiter);
        escrow.release();

        assertEq(seller.balance, sellerBalanceBefore + amount);
    }

    function testRefundToBuyer() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        uint256 buyerBalanceBefore = buyer.balance;

        vm.prank(arbiter);
        escrow.refund();

        assertEq(buyer.balance, buyerBalanceBefore + amount);
    }

    function testDisputeAndResolve() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        vm.prank(seller);
        escrow.dispute();

        uint256 buyerBalanceBefore = buyer.balance;

        vm.prank(arbiter);
        escrow.resolveDispute(false);

        assertEq(buyer.balance, buyerBalanceBefore + amount);
    }

    function testForceRefundAfterDeadline() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        vm.warp(block.timestamp + duration + 1);

        uint256 buyerBalanceBefore = buyer.balance;

        vm.prank(buyer);
        escrow.forceRefund();

        assertEq(buyer.balance, buyerBalanceBefore + amount);
    }

    function testForceRefundBeforeDeadlineFails() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        vm.expectRevert(Escrow.Escrow__DeadlinePassed.selector);

        vm.prank(buyer);
        escrow.forceRefund();
    }

    function testDepositWrongAmount() public {
        vm.expectRevert(abi.encodeWithSelector(Escrow.Escrow__InvalidAmount.selector, amount, amount - 0.1 ether));
        vm.prank(buyer);
        escrow.deposit{value: amount - 0.1 ether}();
    }

    function testMultipleDeposits() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        vm.expectRevert(
            abi.encodeWithSelector(Escrow.Escrow__InvalidState.selector, Escrow.State.UNFUNDED, Escrow.State.FUNDED)
        );

        hoax(buyer, 10 ether);
        escrow.deposit{value: amount}();
    }

    function testExternalReceive() public {
        (bool success,) = address(escrow).call{value: 1 ether}("");
        assertFalse(success);
    }

    function testNonParticipantCannotDispute() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        address stranger = address(99);
        vm.prank(stranger);
        vm.expectRevert(Escrow.Escrow__NotParticipant.selector);
        escrow.dispute();
    }

    function testDepositChangesState() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();
        assertEq(uint256(escrow.currentState()), uint256(Escrow.State.FUNDED));
    }

    function testReleaseChangesState() public {
        vm.prank(buyer);
        escrow.deposit{value: amount}();
        vm.prank(arbiter);
        escrow.release();
        assertEq(uint256(escrow.currentState()), uint256(Escrow.State.COMPLETE));
    }
}
