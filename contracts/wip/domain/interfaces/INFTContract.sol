// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INFTContract {
    function createTicket(uint256 _tokenId, address _to) external;
}
