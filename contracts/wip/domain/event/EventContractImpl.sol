// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/IEventContract.sol";

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
