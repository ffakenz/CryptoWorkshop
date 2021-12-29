// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./INFT.sol";

contract NFT is ERC721, Ownable, INFT {
    address minter;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {}

    modifier onlyMinter() {
        require(minter == _msgSender(), "Mintable: caller is not the minter");
        _;
    }

    function initialize(address minter_) external onlyOwner {
        minter = minter_;
    }

    function create(uint256 _tokenId, address _to) external onlyMinter {
        _safeMint(_to, _tokenId);
    }
}
