// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/test.sol";
import {console} from "forge-std/console.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {Escrow} from "../src/Escrow.sol";

contract EscrowFactoryTest is Test {
    address buyer = address(0xBEEF);
    address seller = address(0xCAFE);
    address arbiter = address(0xABCD);
    uint256 amount = 1 ether;
    uint256 duration = 7 days;
    EscrowFactory factory;

    function setUp() public {
        factory = new EscrowFactory();
    }

    function testEscrowCreatedCorrectly() public {
        Escrow escrow = factory.createEscrow(buyer, seller, arbiter, amount, duration);

        assertEq(factory.getEscrowCount(), 1);

        assertEq(escrow.buyer(), buyer);
        assertEq(escrow.seller(), seller);
        assertEq(escrow.arbiter(), arbiter);
        assertEq(escrow.amount(), amount);
    }

    function testMultipleEscrows() public {
        Escrow e1 = factory.createEscrow(buyer, seller, arbiter, amount, duration);
        Escrow e2 = factory.createEscrow(buyer, address(0x1234), arbiter, 2 ether, 10 days);

        assertEq(factory.getEscrowCount(), 2);

        Escrow[] memory buyerEscrows = factory.getBuyerEscrows(buyer);
        assertEq(buyerEscrows.length, 2);
        assertEq(address(buyerEscrows[0]), address(e1));
        assertEq(address(buyerEscrows[1]), address(e2));
    }

    function testEscrowCreatedViaFactoryWorks() public {
        Escrow escrow = factory.createEscrow(buyer, seller, arbiter, amount, duration);

        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: amount}();

        uint256 sellerBalBefore = seller.balance;
        vm.prank(arbiter);
        escrow.release();
        assertEq(seller.balance, sellerBalBefore + amount);
    }

    function testZeroAmountReverts() public {
        vm.expectRevert(Escrow.Escrow__ZeroAmount.selector);
        factory.createEscrow(buyer, seller, arbiter, 0, duration);
    }

    function testEscrowCreatedEvent() public {
        vm.expectEmit(false, true, true, true);
        emit EscrowFactory.EscrowCreated(address(0), buyer, seller, arbiter, amount, duration);

        factory.createEscrow(buyer, seller, arbiter, amount, duration);
    }
}
// vm.expectEmit(true, true, true, true);
