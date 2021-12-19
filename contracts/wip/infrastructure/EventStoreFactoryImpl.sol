// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../domain/interfaces/IEventContract.sol";
import "../domain/interfaces/INFTContract.sol";
import "../domain/interfaces/IEventStoreAbstractFactory.sol";
import "../domain/interfaces/IEventStoreAbstractFactory.sol";
import "../domain/event/EventContractImpl.sol";
import "../domain/nft/NFTicketImpl.sol";

// @TODO contract needs money to deploy?
contract EventStoreFactoryImpl is IEventStoreAbstractFactory, Ownable {
    /**
     * @dev constructor
     */
    event EventStoreFactoryCreated(address owner, address addr);

    constructor() {
        emit EventStoreFactoryCreated(msg.sender, address(this));
    }

    /**
     * @dev externals
     */
    function createEventContract(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        INFTContract _nftContract,
        address[] memory _whitelist
    ) external onlyOwner returns (IEventContract) {
        IEventContract eventContract = new EventContractImpl(
            _eventId,
            _startDate,
            _ticketPrice,
            _nftContract,
            _whitelist
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
