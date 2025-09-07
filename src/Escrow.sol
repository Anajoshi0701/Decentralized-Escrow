// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Escrow is ReentrancyGuard {
    address public immutable buyer;
    address public immutable seller;
    address public immutable arbiter;
    uint256 public immutable amount;
    uint256 public immutable deadline;

    error Escrow__NotBuyer();
    error Escrow__NotArbiter();
    error Escrow__InvalidState(State expected, State actual);
    error Escrow__InvalidAmount(uint256 expected, uint256 actual);
    error Escrow__TransferFailed(address to, uint256 amount);
    error Escrow__NotParticipant();
    error Escrow__DeadlinePassed();
    error Escrow__InvalidForceRefundState(State actual);
    error Escrow__InvalidAddress();
    error Escrow__ZeroAmount();
    error Escrow__InvalidDuration();
    error Escrow__InvalidArbiter();

    receive() external payable {
        revert();
    }

    enum State {
        UNFUNDED,
        FUNDED,
        COMPLETE,
        REFUNDED,
        DISPUTED
    }

    State public currentState;

    event Deposited(address indexed buyer, uint256 amount);
    event Released(address indexed seller, uint256 amount);
    event Refunded(address indexed buyer, uint256 amount);
    event Disputed(address indexed by);
    event DisputeResolved(address indexed arbiter, bool releasedToSeller);
    event ForceRefunded(address indexed buyer, uint256 amount);

    constructor(address _buyer, address _seller, address _arbiter, uint256 _amount, uint256 _duration) {
        if (_buyer == address(0) || _seller == address(0) || _arbiter == address(0)) {
            revert Escrow__InvalidAddress();
        }
        if (_amount == 0) revert Escrow__ZeroAmount();
        if (_duration == 0) revert Escrow__InvalidDuration();
         if (_arbiter == _buyer || _arbiter == _seller) {
        revert Escrow__InvalidArbiter();
    }
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        amount = _amount;
        deadline = block.timestamp + _duration;
        currentState = State.UNFUNDED;
    }

    modifier onlyBuyer() {
        if (msg.sender != buyer) revert Escrow__NotBuyer();
        _;
    }

    modifier onlyArbiter() {
        if (msg.sender != arbiter) revert Escrow__NotArbiter();
        _;
    }

    modifier inState(State expected) {
        if (currentState != expected) revert Escrow__InvalidState(expected, currentState);
        _;
    }

    function deposit() external payable onlyBuyer inState(State.UNFUNDED) {
        if (msg.value != amount) revert Escrow__InvalidAmount(amount, msg.value);
        if (block.timestamp > deadline) revert Escrow__DeadlinePassed();

        currentState = State.FUNDED;
        emit Deposited(msg.sender, msg.value);
    }

    function release() external onlyArbiter inState(State.FUNDED) nonReentrant {
        _safeTransfer(seller, amount);
        currentState = State.COMPLETE;
        emit Released(seller, amount);
    }

    function refund() external onlyArbiter inState(State.FUNDED) nonReentrant {
        _safeTransfer(buyer, amount);
        currentState = State.REFUNDED;
        emit Refunded(buyer, amount);
    }

    function dispute() external inState(State.FUNDED) {
        if (msg.sender != buyer && msg.sender != seller) {
            revert Escrow__NotParticipant();
        }

        currentState = State.DISPUTED;
        emit Disputed(msg.sender);
    }

    function resolveDispute(bool releaseToSeller) external onlyArbiter inState(State.DISPUTED) nonReentrant {
        if (releaseToSeller) {
            _safeTransfer(seller, amount);
            currentState = State.COMPLETE;
        } else {
            _safeTransfer(buyer, amount);
            currentState = State.REFUNDED;
        }
        emit DisputeResolved(msg.sender, releaseToSeller);
    }

    function forceRefund() external onlyBuyer nonReentrant {
        if (block.timestamp < deadline) revert Escrow__DeadlinePassed();
        if (currentState != State.FUNDED && currentState != State.DISPUTED) {
            revert Escrow__InvalidForceRefundState(currentState);
        }

        _safeTransfer(buyer, amount);
        currentState = State.REFUNDED;
        emit ForceRefunded(buyer, amount);
    }

    function _safeTransfer(address to, uint256 value) internal {
        (bool success,) = to.call{value: value}("");
        if (!success) revert Escrow__TransferFailed(to, value);
    }
}
//UNFUNDED → FUNDED → COMPLETE/REFUNDED/DISPUTED
