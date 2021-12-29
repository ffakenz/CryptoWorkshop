// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./INFT.sol";

contract NFT is ERC721, Ownable, INFT {
    address _minter;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    modifier onlyMinter() {
        require(_minter == _msgSender(), "Mintable: caller is not the minter");
        _;
    }

    function initialize(address minter_) external onlyOwner {
        _minter = minter_;
    }

    function create(uint256 tokenId_, address to_) external onlyMinter {
        _safeMint(to_, tokenId_);
    }
}
