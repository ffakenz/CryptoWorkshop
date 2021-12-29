// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPaymentGateway.sol";

contract PaymentGateway is Ownable, IPaymentGateway {
    // state
    IERC20 _usdc;
    address payable _recipient;
    mapping(uint256 => PaymentGatewayStructs.Payment) _payments;

    // constructor
    function initialize(address usdc_, address payable recipient_)
        public
        onlyOwner
    {
        _usdc = IERC20(usdc_);
        _recipient = recipient_;
    }

    // views
    function findPayment(uint256 paymentId)
        public
        view
        returns (PaymentGatewayStructs.Payment memory)
    {
        return _payments[paymentId];
    }

    // externals
    function pay(uint256 paymentId_, uint256 amount_) public returns (bool) {
        address customer = _msgSender();
        PaymentGatewayStructs.Payment memory payment = createPayment(
            customer,
            paymentId_,
            amount_
        );
        _usdc.transferFrom(customer, _recipient, amount_);
        emit PaymentCompleted(payment);
        return true;
    }

    // internals
    function createPayment(
        address customer_,
        uint256 paymentId_,
        uint256 amount_
    ) internal returns (PaymentGatewayStructs.Payment memory) {
        require(_payments[paymentId_].status == false, "payment exists");
        PaymentGatewayStructs.Payment memory payment = PaymentGatewayStructs
            .Payment({
                id: paymentId_,
                date: block.timestamp,
                amount: amount_,
                customer: customer_,
                status: true
            });
        _payments[paymentId_] = payment;
        return payment;
    }
}
