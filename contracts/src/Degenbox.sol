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
  uint256 public stealCount;
  address public chairityAddress;
  uint256 public chairityBP;

  address[] public degens;

  event StealBox(address indexed stealer, address indexed victim, bool successful, uint256 amount);
  event Unlock(address indexed, uint256 amount);
  event Donation(address indexed donor, uint256 amount);
  event Reset(address indexed rester, address[] degens);
  event ChairityFunding(address indexed chairity, uint256 amount);
  
  constructor(uint256 _unlockPeriod, IERC20 _boxCurrency, uint256 _fixedAmount, address _charityAddress, uint256 _chairityBP) {
    unlockPeriod = _unlockPeriod;
    unlockEnd = block.timestamp + _unlockPeriod;
    boxCurrency = _boxCurrency;
    fixedAmount = _fixedAmount;
    chairityAddress = _charityAddress;
    chairityBP = _chairityBP;
  }

  function steal() external {
    require(isBroken == false, "already broken");
    require(owner != msg.sender, "already owner");
    require(boxCurrency.transferFrom(msg.sender, address(this), fixedAmount));
    moneyInTheBox = moneyInTheBox + fixedAmount;
    heist();
  }

  function unlock() external onlyOwner {
    _unlock();
  }
  function _unlock() private {
    require(block.timestamp > unlockEnd || isBroken);
    uint256 chairityAmount = moneyInTheBox * chairityBP / 1000;
    uint256 payoutAmount = moneyInTheBox - chairityAmount;
    moneyInTheBox = 0;
    boxCurrency.transfer(owner, payoutAmount);
    boxCurrency.transfer(chairityAddress, chairityAmount);
    reset();
    emit Unlock(owner, payoutAmount);
    emit ChairityFunding(chairityAddress, chairityAmount);
  }

  function heist() private {
    uint256 prnd = uint256(blockhash(block.number-1)) + degens.length;
    uint256 breakResult =  (prnd % 10);
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
      emit StealBox(msg.sender, victim, true, moneyInTheBox);
    } else {
      isBroken = true;
      emit StealBox(msg.sender, owner, false, moneyInTheBox);
    }
  }

  function donate(uint256 amount) external{
    require(isBroken == false, "Box already broken");
    require(boxCurrency.transferFrom(msg.sender, address(this), amount));
    moneyInTheBox = moneyInTheBox + amount;
    emit Donation(msg.sender, amount);
  }

  function restart() external{
    require(isBroken, "Game didn't end yet.");
    _unlock();
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