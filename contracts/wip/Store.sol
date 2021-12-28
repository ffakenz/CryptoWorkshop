// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IPaymentGateway.sol";
import "./INFT.sol";

contract Store is Ownable {
    IPaymentGateway paymentGateway;
    INFT nft;

    // constructor
    function initialize(address nft_, address paymentGateway_)
        external
        onlyOwner
    {
        paymentGateway = IPaymentGateway(paymentGateway_);
        nft = INFT(nft_);
    }

    function buyNFT(uint256 tokenId, uint256 amount) external returns (bool) {
        address customer = _msgSender();
        bool paymentCompleted = paymentGateway.pay(customer, amount);
        if (paymentCompleted) {
            nft.create(tokenId, customer);
            return true;
        } else {
            return false;
        }
    }
}
