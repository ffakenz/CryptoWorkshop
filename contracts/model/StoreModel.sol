// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

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
    uint256 startDate; //@TODO
    uint256 ticketPrice;
    EventStatus status;
}

struct StoreState {
    mapping(uint256 => Event) events;
    mapping(uint256 => uint256[]) eventTickets;
    mapping(address => bool) whitelist;
    IERC721 nfticket;
}
