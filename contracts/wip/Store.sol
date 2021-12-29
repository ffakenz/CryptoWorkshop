// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IPaymentGateway.sol";
import "./INFT.sol";

contract Store is Ownable {
    IPaymentGateway _paymentGateway;
    INFT _nft;
    mapping(uint256 => uint256) _tokenPriceList;
    address _client;

    modifier onlyClient() {
        require(_client == _msgSender(), "caller is not the caller");
        _;
    }

    // constructor
    function initialize(
        address nft_,
        address paymentGateway_,
        address client_
    ) public onlyOwner {
        _paymentGateway = IPaymentGateway(paymentGateway_);
        _nft = INFT(nft_);
        _client = client_;
    }

    function setTokenPrice(uint256 tokenId_, uint256 price_) public onlyClient {
        _tokenPriceList[tokenId_] = price_;
    }

    function claimNFT(uint256 tokenId_, uint256 paymentId_)
        public
        returns (bool)
    {
        address customer = _msgSender();
        uint256 tokenPrice = _tokenPriceList[tokenId_];
        PaymentGatewayStructs.Payment memory payment = _paymentGateway
            .findPayment(paymentId_);
        require(payment.amount >= tokenPrice, "payment amount is not enough");
        _nft.create(tokenId_, customer);
        return true;
    }
}
