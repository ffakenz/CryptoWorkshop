// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../interfaces/INFTContract.sol";

// @TODO add permissions to createTicket using AccessControl
contract NFTicketImpl is ERC721, INFTContract, Ownable {
    struct NFT {
        string _eventName;
        string _eventSymbol;
    }

    /**
     * @dev contract state
     */
    NFT public _nft;

    /**
     * @dev constructor
     */
    event NFTContractCreated(address owner, address addr);

    constructor(string memory _eventName, string memory _eventSymbol)
        ERC721(_eventName, _eventSymbol)
    {
        _nft = NFT({_eventName: _eventName, _eventSymbol: _eventSymbol});
        emit NFTContractCreated(msg.sender, address(this));
    }

    /**
     * @dev externals
     */
    function createTicket(uint256 _tokenId, address _to) external {
        _mint(_to, _tokenId);
    }
}
