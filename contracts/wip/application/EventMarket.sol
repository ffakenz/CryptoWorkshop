// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/IEventContract.sol";
import "../interfaces/INFTContract.sol";
import "../interfaces/IEventStoreAbstractFactory.sol";

contract NFTicketImpl is ERC721, INFTContract, Ownable {
    /**
     * @dev constructor
     */
    constructor(string memory _eventName, string memory _eventSymbol)
        ERC721(_eventName, _eventSymbol)
    {}

    /**
     * @dev externals
     */
    function createTicket(uint256 _tokenId, address _to) external onlyOwner {
        _mint(_to, _tokenId);
    }
}

contract EventContractImpl is IEventContract, Ownable {
    /**
     * @dev constructor
     */
    constructor(
        uint256 _eventId,
        uint256 _startDate,
        uint256 _ticketPrice
    ) {}

    /**
     * @dev externals
     */
    function buyTicket(uint256 _eventId) external payable onlyOwner {}
}

contract EventMarket {
    IEventContract eventContract;
    INFTContract nftContract;

    constructor(address _eventContract, address _nftContract) {
        eventContract = IEventContract(_eventContract);
        nftContract = INFTContract(_nftContract);
    }
}
