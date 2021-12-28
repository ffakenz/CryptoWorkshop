// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./INFT.sol";

contract NFT is ERC721, Ownable, INFT {
    address minter;

    constructor(string memory _eventName, string memory _eventSymbol)
        ERC721(_eventName, _eventSymbol)
    {}

    modifier onlyMinter() {
        require(minter == _msgSender(), "Mintable: caller is not the minter");
        _;
    }

    function setMinter(address minter_) external onlyOwner {
        minter = minter_;
    }

    function create(uint256 _tokenId, address _to) external onlyMinter {
        _mint(_to, _tokenId);
    }
}
