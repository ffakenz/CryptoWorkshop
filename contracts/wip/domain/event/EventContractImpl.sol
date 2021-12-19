// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";

contract EventContractImpl is IEventContract, Ownable {
    enum EventStatus {
        Void,
        Created,
        SalesStarted,
        SalesSuspended,
        SalesFinished,
        Completed,
        Settled,
        Cancelled
    }

    struct Event {
        uint256 eventId;
        uint256 startDate;
        uint256 ticketPrice;
        INFTContract nftContract;
        EventStatus status;
        mapping(address => bool) whitelist;
    }

    /**
     * @dev contract state
     */
    Event public _event;

    /**
     * @dev modifiers
     */
    modifier EventNotStarted() {
        require(
            (uint64(block.timestamp) < _event.startDate),
            "event has already started"
        );
        _;
    }

    modifier onlyWhitelisted() {
        require(_event.whitelist[msg.sender], "user not allowed");
        _;
    }

    /**
     * @dev constructor
     */
    constructor(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        INFTContract _nftContract,
        address[] memory _whitelist
    ) {
        _event.eventId = _eventId;
        _event.startDate = _startDate;
        _event.ticketPrice = _ticketPrice;
        _event.nftContract = _nftContract;
        _event.status = EventStatus.Created;
        for (uint256 i = 0; i < _whitelist.length; i += 1) {
            _event.whitelist[_whitelist[i]] = true;
        }
    }

    /**
     * @dev externals
     */
    function buyTicket(uint256 _tokenId) external payable onlyOwner {}
}
