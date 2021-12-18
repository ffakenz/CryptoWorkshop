// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";
import "../interfaces/IEventStoreAbstractFactory.sol";
import "../interfaces/IEventStoreAbstractFactory.sol";
import "../application/EventMarket.sol";

contract EventStoreFactoryImpl is IEventStoreAbstractFactory, Ownable {
    address[] public eventContracts;
    address[] public nftContracts;

    function createEventContract(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice
    ) external onlyOwner returns (address) {
        IEventContract eventContract = new EventContractImpl(
            _eventId,
            _startDate,
            _ticketPrice
        );
        nftContracts.push(address(eventContract));
        return address(this);
    }

    function createNFTContract(
        string memory _eventName,
        string memory _eventSymbol
    ) external onlyOwner returns (address) {
        INFTContract nftContract = new NFTicketImpl(_eventName, _eventSymbol);
        nftContracts.push(address(nftContract));
        return address(this);
    }
}
