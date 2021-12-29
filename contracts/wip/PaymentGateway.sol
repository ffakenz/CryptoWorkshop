// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPaymentGateway.sol";

contract PaymentGateway is Ownable, IPaymentGateway {
    using Strings for uint256;

    // state
    IERC20 usdc;
    address payable recipient;
    address store;
    mapping(address => mapping(uint256 => PaymentGatewayStructs.Payment)) payments;
    mapping(uint256 => bool) paymentsIds;

    // constructor
    function initialize(address usdc_, address payable recipient_)
        public
        onlyOwner
    {
        usdc = IERC20(usdc_);
        recipient = recipient_;
    }

    // externals
    function pay(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) public returns (bool) {
        require(paymentsIds[paymentId] == false, "payment exists");
        PaymentGatewayStructs.Payment memory payment = createPayment(
            customer,
            paymentId,
            amount
        );
        executePayment(payment);
        paymentsIds[paymentId] = true;
        emit PaymentCompleted(payment);
        return true;
    }

    // internals
    event Log(string msg);

    function executePayment(PaymentGatewayStructs.Payment memory payment)
        internal
    {
        emit Log(string(abi.encodePacked("[HERE]", payment.amount.toString())));
        usdc.approve(address(this), payment.amount); // @TODO
        usdc.transferFrom(payment.customer, recipient, payment.amount);
    }

    function createPayment(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) internal returns (PaymentGatewayStructs.Payment memory) {
        PaymentGatewayStructs.Payment memory payment = PaymentGatewayStructs
            .Payment({
                id: paymentId,
                date: block.timestamp,
                amount: amount,
                customer: customer
            });
        payments[customer][paymentId] = payment;
        return payment;
    }
}
