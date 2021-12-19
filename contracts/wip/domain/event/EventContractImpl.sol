// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";
import "../../infrastructure/Logger.sol";

// @TODO add permissions to emitTicket using AccessControl
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
        EventStatus status;
        INFTContract nftContract;
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
        _event.status = EventStatus.Created;
        _event.nftContract = _nftContract;
        for (uint256 i = 0; i < _whitelist.length; i += 1) {
            _event.whitelist[_whitelist[i]] = true;
        }
        emit EventContractCreated(msg.sender, address(this));
    }

    /**
     * @dev payables
     */
    function buyTicket(uint256 _tokenId) external payable {
        uint256 _ticketPrice = _event.ticketPrice;
        require(msg.value >= _ticketPrice, "not enough money");

        uint256 amountPaid = msg.value.sub(_ticketPrice);
        payable(_msgSender()).transfer(amountPaid);
        _event.nftContract.createTicket(_tokenId, _msgSender());
    }
}
