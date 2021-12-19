// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../domain/interfaces/IEventContract.sol";
import "../domain/interfaces/INFTContract.sol";
import "../domain/interfaces/IEventStoreAbstractFactory.sol";
import "../infrastructure/EventStoreFactoryImpl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../infrastructure/Logger.sol";

// @TODO contract needs money to deploy?
contract EventMarket is Logger, Ownable {
    using SafeMath for uint256;
    using Strings for uint256;

    mapping(uint256 => IEventContract) public eventContracts;
    mapping(uint256 => INFTContract) public nftContracts;
    IEventStoreAbstractFactory public factory;

    /**
     * @dev constructor
     */
    event EventMarketCreated(address owner, address addr, address factory);

    constructor() {
        factory = new EventStoreFactoryImpl();
        emit EventMarketCreated(msg.sender, address(this), address(factory));
    }

    /**
     * @dev externals
     */
    function createEvent(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice,
        string memory _eventName,
        string memory _eventSymbol,
        address[] memory _whitelist
    ) external onlyOwner {
        INFTContract nftContract = factory.createNFTContract(
            _eventName,
            _eventSymbol
        );
        nftContracts[_eventId] = nftContract;
        eventContracts[_eventId] = factory.createEventContract(
            _eventId,
            _startDate,
            _ticketPrice,
            nftContract,
            _whitelist
        );
    }

    /**
     * @dev payables
     */
    function buyTicket(uint256 _tokenId, uint256 _eventId) external payable {
        IEventContract eventContract = eventContracts[_eventId];
        uint256 _ticketPrice = eventContract.getTicketPrice(_tokenId);
        require(msg.value >= _ticketPrice, "not enough money");

        uint256 amountPaid = msg.value.sub(_ticketPrice);
        payable(_msgSender()).transfer(amountPaid);
        eventContract.emitTicket(_tokenId, _msgSender());
    }
}
