pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

error Vendor__YouMustBeTheOwner();
error Vendor__TransferFailed();

contract Vendor is Ownable {
    event BuyTokens(
        address indexed buyer,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );

    event SellTokens(
        address indexed seller,
        uint256 amountOfEth,
        uint256 amountOfTokens
    );

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    uint256 public constant tokensPerEth = 100;

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public {
        require(msg.sender == owner(), "Ownable: caller is not the owner");
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) {
            revert Vendor__TransferFailed();
        }
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 amount) public {
        uint256 amountOfEth = amount / tokensPerEth;
        yourToken.transferFrom(msg.sender, address(this), amount);
        (bool callSuccess, ) = payable(msg.sender).call{value: amountOfEth}("");
        if (!callSuccess) {
            revert Vendor__TransferFailed();
        }
        emit SellTokens(msg.sender, amountOfEth, amount);
    }
}
