// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEventStoreAbstractFactory {
    function createEventContract(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice
    ) external returns (address);

    function createNFTContract(
        string memory _eventName,
        string memory _eventSymbol
    ) external returns (address);
}
