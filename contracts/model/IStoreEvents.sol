// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StoreModel.sol";

interface IStoreEvents {
    
    event EventCreated(
        uint256 indexed _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        EventStatus indexed _status,
        uint256[] _tickets
    );

    event TicketSold(
        uint256 indexed _ticketId,
        uint256 indexed _eventId,
        address _customer,
        uint256 _date,
        uint256 _price
    );    
}
