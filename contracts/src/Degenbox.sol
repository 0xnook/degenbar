// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract DegenBox {
  uint256 public  unlockEnd;
  uint256 public  immutable unlockPeriod;
  IERC20 public immutable boxCurrency;
  uint256 public moneyInTheBox;
  uint256 public fixedAmount;
  bool public isBroken;
  address public owner;
  uint256 stealCount;

  address[] public degens;

  event BoxStolen(address indexed stealer, address indexed victim);
  event BoxBroken(address indexed claimer, uint256 amount);
  event Donation(address indexed donor, uint256 amount);
  event Reset(address indexed rester, address[] degens);
  
  constructor(uint256 _unlockPeriod, IERC20 _boxCurrency, uint256 _fixedAmount) {
    unlockPeriod = _unlockPeriod;
    unlockEnd = block.timestamp + _unlockPeriod;
    boxCurrency = _boxCurrency;
    fixedAmount = _fixedAmount;
  }

  function steal() external {
    require(isBroken == false, "already broken");
    require(owner != msg.sender, "already owner");
    require(boxCurrency.transferFrom(msg.sender, address(this), fixedAmount));
    moneyInTheBox = moneyInTheBox + fixedAmount;
    heist();
  }

  function unlock() external onlyOwner {
    require(block.timestamp > unlockEnd || isBroken);
    uint256 payoutAmount = moneyInTheBox;
    moneyInTheBox = 0;
    reset();
    boxCurrency.transfer(msg.sender, payoutAmount);
  }

  function heist() private {
    
    uint256 prnd = uint256(blockhash(block.number-1)) + degens.length;
    uint256 breakResult =  (prnd % 1000);
    console.log("breakresult %s", breakResult);
    if (breakResult > degens.length) {//sucessfull
      unlockEnd = block.timestamp + unlockPeriod;
      address victim = owner;
      owner = msg.sender;
      bool newDegen = true;
      for (uint i=0; i< degens.length ; i++){
        if (degens[i] == msg.sender) {
          newDegen = false;
        }
      }
      if(newDegen) {
        degens.push(msg.sender);
      }
      stealCount++;
      emit BoxStolen(msg.sender, victim);
    } else {
      isBroken = true;
      emit BoxBroken(owner, moneyInTheBox);
    }
  }

  function donate(uint256 amount) external{
    require(isBroken == false, "Box already broken");
    require(boxCurrency.transferFrom(msg.sender, address(this), amount));
    moneyInTheBox = moneyInTheBox + amount;
    emit Donation(msg.sender, amount);
  }

  function restart() external{
    require(isBroken, "Box isn't broken");
    reset();
  }

  function reset() private {
    emit Reset(msg.sender, degens);
    isBroken = false;
    delete degens;
    stealCount = 0;
  }

  function getDegens() external view returns (address[] memory){
    return degens;
  }

  modifier onlyOwner() {
    require(owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }



}