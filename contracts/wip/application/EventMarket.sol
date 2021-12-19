// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../domain/interfaces/IEventContract.sol";
import "../domain/interfaces/INFTContract.sol";
import "../domain/interfaces/IEventStoreAbstractFactory.sol";
import "../infrastructure/EventStoreFactoryImpl.sol";

// @TODO contract needs money to deploy?
contract EventMarket is Ownable {
    IEventContract public eventContract;
    INFTContract public nftContract;
    IEventStoreAbstractFactory public factory;

    constructor() {
        factory = new EventStoreFactoryImpl();
    }

    function createEvent(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        string memory _eventName,
        string memory _eventSymbol,
        address[] memory _whitelist
    ) external onlyOwner {
        nftContract = factory.createNFTContract(_eventName, _eventSymbol);
        eventContract = factory.createEventContract(
            _eventId,
            _startDate,
            _ticketPrice,
            nftContract,
            _whitelist
        );
    }

    function buyTicket(uint256 _tokenId) external payable {
        eventContract.buyTicket(_tokenId);
    }
}
