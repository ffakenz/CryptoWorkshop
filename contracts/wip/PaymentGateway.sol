// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPaymentGateway.sol";

contract PaymentGateway is Ownable, IPaymentGateway {
    // model
    struct Payment {
        uint256 id;
        uint256 date;
        uint256 amount;
        address customer;
    }
    event PaymentCompleted(Payment payment);

    // state
    IERC20 usdc;
    address payable recipient;
    address store;
    mapping(address => mapping(uint256 => Payment)) payments;

    modifier onlyStore() {
        require(store == _msgSender(), "PaymentCaller: caller is not allowed");
        _;
    }

    // constructor
    function initialize(address usdc_, address recipient_) external onlyOwner {
        usdc = IERC20(usdc_);
        recipient = payable(recipient_);
    }

    function setStore(address store_) external onlyOwner {
        store = store_;
    }

    // externals
    function pay(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) external onlyStore returns (bool) {
        Payment memory payment = createPayment(customer, paymentId, amount);
        executePayment(payment);
        emit PaymentCompleted(payment);
        return true;
    }

    // internals
    function executePayment(Payment memory payment) internal {
        usdc.approve(address(this), payment.amount);
        usdc.transferFrom(payment.customer, recipient, payment.amount);
    }

    function createPayment(
        address customer,
        uint256 paymentId,
        uint256 amount
    ) internal returns (Payment memory) {
        Payment memory payment = Payment({
            id: paymentId,
            date: block.timestamp,
            amount: amount,
            customer: customer
        });
        payments[customer][paymentId] = payment;
        return payment;
    }
}
