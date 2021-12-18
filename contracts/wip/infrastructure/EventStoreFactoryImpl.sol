// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";
import "../interfaces/IEventStoreAbstractFactory.sol";
import "../interfaces/IEventStoreAbstractFactory.sol";
import "../domain/event/EventContractImpl.sol";
import "../domain/nft/NFTicketImpl.sol";

contract EventStoreFactoryImpl is IEventStoreAbstractFactory, Ownable {
    function createEventContract(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice
    ) external onlyOwner returns (IEventContract) {
        IEventContract eventContract = new EventContractImpl(
            _eventId,
            _startDate,
            _ticketPrice
        );
        return eventContract;
    }

    function createNFTContract(
        string memory _eventName,
        string memory _eventSymbol
    ) external onlyOwner returns (INFTContract) {
        INFTContract nftContract = new NFTicketImpl(_eventName, _eventSymbol);
        return nftContract;
    }
}
