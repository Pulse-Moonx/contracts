// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./PulseToken.sol";
                               
/**
 _ __ ___   ___   ___  _ __ __  __
| '_ ` _ \ / _ \ / _ \| '_ \\ \/ /
| | | | | | (_) | (_) | | | |>  < 
|_| |_| |_|\___/ \___/|_| |_/_/\_\

**/                                

contract PulseProtocol {
    PulseToken public pulseToken;
    uint256 public deadline;
    bool public activityCompleted;
    mapping(address => bool) public eligibility;

    uint256 private DEADLINE_1 = 1714878000; // 05/05/2024 UTC
    uint256 private DEADLINE_2 = 1715050800; // 07/05/2024 UTC

    event ActivityCompleted(address indexed account);
    event TokenMinted(address indexed account);

    constructor(address _pulseTokenAddress) {
        pulseToken = PulseToken(_pulseTokenAddress);
    }

    modifier activityDeadlinePassed() {
        uint256 startOfDayDeadline1 = (DEADLINE_1 / 86400) * 86400; // 86400 segundos em um dia
        uint256 startOfDayDeadline2 = (DEADLINE_2 / 86400) * 86400;

        uint256 startOfDayTimestamp = (block.timestamp / 86400) * 86400;

        if (
            startOfDayTimestamp < startOfDayDeadline1 ||
            startOfDayTimestamp > startOfDayDeadline2
        ) {
            revert("Activity deadline not met");
        }
        _;
    }

    function completeActivity(
        address _address
    ) external activityDeadlinePassed {
        if (activityCompleted) {
            revert("Activity already completed");
        }

        if (!eligibility[_address]) {
            revert("Address not eligible to complete activity");
        }

        activityCompleted = true;
        emit ActivityCompleted(_address);
    }

    function mintToken(address _address) external activityDeadlinePassed {
        if (!activityCompleted) {
            revert("Activity not completed");
        }
        if (!eligibility[_address]) {
            revert("Address not eligible to mint token");
        }

        pulseToken.mint(_address, 1);
        emit TokenMinted(_address);
    }

    function setEligibility(address _address, bool _eligible) external {
        eligibility[_address] = _eligible;
    }

    function setDeadline(
        uint256 _newDeadlineOne,
        uint256 _newDeadlineTwo
    ) external {
        if (_newDeadlineOne >= _newDeadlineTwo) {
            revert("New deadline one must be before new deadline two");
        }
        if (_newDeadlineOne <= block.timestamp) {
            revert("New deadline one must be in the future");
        }
        if (_newDeadlineTwo <= block.timestamp) {
            revert("New deadline two must be in the future");
        }

        DEADLINE_1 = _newDeadlineOne;
        DEADLINE_2 = _newDeadlineTwo;
    }
}
