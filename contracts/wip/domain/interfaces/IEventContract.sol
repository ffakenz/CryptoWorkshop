// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEventContract {
    function emitTicket(uint256 _tokenId, address customer) external;

    function getTicketPrice(uint256 _tokenId) external view returns (uint256);
}
