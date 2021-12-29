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
    mapping(uint256 => uint256) tokenPriceList;
    address client;

    modifier onlyClient() {
        require(client == _msgSender(), "caller is not the caller");
        _;
    }

    // constructor
    function initialize(
        address nft_,
        address paymentGateway_,
        address client_
    ) public onlyOwner {
        paymentGateway = IPaymentGateway(paymentGateway_);
        nft = INFT(nft_);
        client = client_;
    }

    function setTokenPrice(uint256 tokenId_, uint256 price_) public onlyClient {
        tokenPriceList[tokenId_] = price_;
    }

    function buyNFT(uint256 tokenId_, uint256 paymentId_)
        public
        returns (bool)
    {
        uint256 tokenPrice = tokenPriceList[tokenId_];
        address customer = _msgSender();
        bool paymentCompleted = paymentGateway.pay(
            customer,
            paymentId_,
            tokenPrice
        );
        if (paymentCompleted) {
            nft.create(tokenId_, customer);
            return true;
        } else {
            return false;
        }
    }
}
