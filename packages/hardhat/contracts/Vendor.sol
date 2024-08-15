pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  uint256 public constant tokensPerEth = 100;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  address public _owner;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
    _owner = msg.sender;
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable {
    uint256 tokenAmount = msg.value * tokensPerEth;
    yourToken.transfer(msg.sender, tokenAmount);
    emit BuyTokens(msg.sender, msg.value, tokenAmount);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public {
    require(msg.sender == _owner, "Only the owner can withdraw");
    payable(_owner).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public {
    require(yourToken.balanceOf(msg.sender) >= _amount, "Insufficient balance");
    uint256 ethAmount = _amount / tokensPerEth;
    require(address(this).balance >= ethAmount, "Contract does not have enough ETH to fulfill the transaction");

    yourToken.transferFrom(msg.sender, address(this), _amount);
    payable(msg.sender).transfer(ethAmount);
    emit SellTokens(msg.sender, _amount, ethAmount);
  }
}
