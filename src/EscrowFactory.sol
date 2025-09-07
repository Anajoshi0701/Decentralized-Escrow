// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Escrow} from "./Escrow.sol";

contract EscrowFactory {
    event EscrowCreated(
        address indexed escrowAddress,
        address indexed buyer,
        address indexed seller,
        address arbiter,
        uint256 amount,
        uint256 duration
    );

    Escrow[] public escrows;

    /// @notice Track escrows created by a buyer
    mapping(address => Escrow[]) public buyerToEscrows;
    mapping(address => Escrow[]) public sellerToEscrows;
    mapping(address => Escrow[]) public arbiterToEscrows;
    mapping(address => Escrow[]) public deployerToEscrows;

    function createEscrow(address _buyer, address _seller, address _arbiter, uint256 _amount, uint256 _duration)
        external
        returns (Escrow escrow)
    {
        escrow = new Escrow(_buyer, _seller, _arbiter, _amount, _duration);
        escrows.push(escrow);
        buyerToEscrows[_buyer].push(escrow);
        sellerToEscrows[_seller].push(escrow);
        arbiterToEscrows[_arbiter].push(escrow);
        deployerToEscrows[msg.sender].push(escrow);

        emit EscrowCreated(address(escrow), _buyer, _seller, _arbiter, _amount, _duration);
        
    }

    function getEscrowCount() external view returns (uint256) {
        return escrows.length;
    }

    function getBuyerEscrows(address buyer) external view returns (Escrow[] memory) {
    return buyerToEscrows[buyer];
}
}
