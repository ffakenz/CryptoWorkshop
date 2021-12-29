// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library PaymentGatewayStructs {
    struct Payment {
        uint256 id;
        uint256 date;
        uint256 amount;
        address customer;
        bool status;
    }
}

interface IPaymentGateway {
    event PaymentCompleted(PaymentGatewayStructs.Payment payment);

    function pay(uint256 paymentId, uint256 amount) external returns (bool);

    function findPayment(uint256 paymentId)
        external
        view
        returns (PaymentGatewayStructs.Payment memory);
}
