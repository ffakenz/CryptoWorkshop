// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./model/IStore.sol";
import "./model/StoreModel.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GaiaStore is IStore, Ownable, Pausable {
    using SafeMath for uint256;
    using Strings for uint256;

    /**
     * @dev contract state
     */
    StoreState store;

    /**
     * @dev constructor
     */
    constructor(address _nfticket, address[] memory _whitelist) {
        for (uint256 i = 0; i < _whitelist.length; i += 1) {
            store.whitelist[_whitelist[i]] = true;
        }
        store.nfticket = IERC721(_nfticket);
    }

    /**
     * @dev modifiers
     */
    modifier EventNotStarted(uint256 _eventId) {
        require(
            (uint64(block.timestamp) < store.events[_eventId].startDate),
            "event has already started"
        );
        _;
    }

    modifier onlyWhitelisted() {
        require(store.whitelist[msg.sender], "user not allowed");
        _;
    }

    /**
     * @dev externals
     */
    function createEvent(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        uint256[] calldata _tickets
    ) external onlyOwner whenNotPaused {
        for (uint256 i = 0; i < _tickets.length; i += 1) {
            uint256 _ticketId = _tickets[i];
            bool gaiaStoreIsOwner = store.nfticket.ownerOf(_ticketId) ==
                address(this);
            if (!gaiaStoreIsOwner) {
                string memory errorMsg = string(
                    abi.encodePacked(
                        "nfticket ",
                        _ticketId.toString(),
                        " not owned by gaiastore"
                    )
                );
                revert(errorMsg);
            }
            store.eventTickets[_eventId].push(_ticketId);
        }

        EventStatus _status = EventStatus.Created;
        store.events[_eventId] = Event({
            eventId: _eventId,
            startDate: _startDate,
            ticketPrice: _ticketPrice,
            status: _status
        });

        emit EventCreated({
            _eventId: _eventId,
            _startDate: _startDate,
            _ticketPrice: _ticketPrice,
            _status: _status,
            _tickets: _tickets
        });
    }

    /**
     * @dev payables
     */
    function buyTicket(uint256 _eventId)
        external
        payable
        onlyWhitelisted
        whenNotPaused
    {
        require(
            store.events[_eventId].status != EventStatus.Void,
            "event does not exists"
        );

        uint256 _ticketsAmount = store.eventTickets[_eventId].length;
        require(_ticketsAmount > 0, "not enough tickets");

        uint256 _ticketPrice = store.events[_eventId].ticketPrice;
        require(msg.value >= _ticketPrice, "not enough money");

        payable(msg.sender).transfer(msg.value.sub(_ticketPrice));
        uint256 _ticketId = store.eventTickets[_eventId][_ticketsAmount.sub(1)];

        store.nfticket.transferFrom(address(this), msg.sender, _ticketId);
        store.eventTickets[_eventId].pop();

        emit TicketSold({
            _ticketId: _ticketId,
            _eventId: _eventId,
            _customer: msg.sender,
            _date: block.timestamp,
            _price: _ticketPrice
        });
    }

    /**
     * @dev views
     */
    function getEvent(uint256 _eventId) external view returns (Event memory) {
        return store.events[_eventId];
    }
}
