// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";
import "../../infrastructure/Logger.sol";

contract EventContractImpl is Logger, IEventContract, Ownable {
    using SafeMath for uint256;
    using Strings for uint256;

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

    modifier onlyWhitelisted(address customer) {
        require(_event.whitelist[customer], "user not allowed");
        _;
    }

    /**
     * @dev constructor
     */
    event EventContractCreated(address owner, address addr);

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
        emit EventContractCreated(msg.sender, address(this));
    }

    /**
     * @dev payables
     */
    function emitTicket(uint256 _tokenId, address customer)
        external
        onlyWhitelisted(customer)
    {
        _event.nftContract.createTicket(_tokenId, customer);
    }

    /**
     * @dev views
     */
    function getTicketPrice(uint256 _tokenId) external view returns (uint256) {
        return _event.ticketPrice;
    }
}
