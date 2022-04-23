// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract DegenBox {
  uint256 public  unlockEnd;
  uint256 public  immutable unlockPeriod;
  uint256 public moneyInTheBox;
  IERC20 public immutable boxCurrency;
  bool public isBroken;
  uint256 private wear;
  address public owner;

  constructor(uint256 _unlockPeriod, IERC20 _boxCurrency) {
    unlockPeriod = _unlockPeriod;
    unlockEnd = block.timestamp + _unlockPeriod;
    boxCurrency = _boxCurrency;
  }

  function steal(uint256 _amount) external {
    console.log("stealing");
    require(isBroken == false, "already broken");
    require(boxCurrency.transferFrom(msg.sender, address(this), _amount));
    moneyInTheBox = moneyInTheBox + _amount;
    console.log("moneyInTheBox %s", moneyInTheBox);
    heist();
  }

  function unlock() external onlyOwner {
    require(block.timestamp > unlockEnd || isBroken);
    uint256 payoutAmount = moneyInTheBox;
    moneyInTheBox = 0;
    boxCurrency.transfer(msg.sender, payoutAmount);
  }

  function heist() private {
    wear += 1;
    uint256 prnd = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, wear)));
    uint256 breakResult =  (prnd % 1000);
    console.log("breakresult %s", breakResult);
    if (breakResult > wear) {//sucessfull
      unlockEnd = block.timestamp + unlockPeriod;
      owner = msg.sender;
      console.log("heist succesfull");
    } else {
      isBroken = true;
      console.log("heist failed");
    }
  }

  modifier onlyOwner() {
    require(owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }



}