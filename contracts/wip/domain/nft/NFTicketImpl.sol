// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/INFTContract.sol";

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
