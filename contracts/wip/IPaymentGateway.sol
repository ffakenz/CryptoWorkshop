// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library PaymentGatewayStructs {
    struct Payment {
        uint256 id;
        uint256 date;
        uint256 amount;
        address customer;
    }
}

interface IPaymentGateway {
    event PaymentCompleted(PaymentGatewayStructs.Payment payment);

    function pay(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) external returns (bool);
}
