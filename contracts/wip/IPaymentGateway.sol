// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPaymentGateway {
    function pay(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) external returns (bool);
}
