// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DegenBoxV2 {
  uint256 public  unlockEnd;
  uint256 public  immutable unlockPeriod;
  uint256 public moneyInTheBox;
  IERC20 public immutable boxCurrency;
  bool public isBroken;
  address public owner;
  uint256 public fixedAmount;

  address[] public degens;

  event StealBox(address indexed stealer, address indexed victim, bool successful, uint256 amount);
  event Unlock(address indexed owner, uint256 amount);
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
    require(boxCurrency.transferFrom(msg.sender, address(this), fixedAmount));
    moneyInTheBox = moneyInTheBox + fixedAmount;
    heist();
  }

  function unlock() external onlyOwner {
    require(block.timestamp > unlockEnd || isBroken);
    uint256 payoutAmount = moneyInTheBox;
    moneyInTheBox = 0;
    reset();
    emit Unlock(owner, payoutAmount);
    boxCurrency.transfer(msg.sender, payoutAmount);
  }

  function heist() private {
    
    uint256 prnd = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, degens.length)));
    uint256 breakResult =  (prnd % 1000);
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
    require(isBroken, "Box isn't broken");
    reset();
  }

  function reset() private {
    emit Reset(msg.sender, degens);
    isBroken = false;
    delete degens;
  }

  modifier onlyOwner() {
    require(owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }



}