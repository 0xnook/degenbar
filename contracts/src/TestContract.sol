
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "redstone-evm-connector/lib/contracts/message-based/PriceAware.sol";

contract TestContract is PriceAware {

 function redstoneGetLastPrice() public view returns(uint) {
        uint usdchf = getPriceFromMsg(bytes32("CHF"));
        return usdchf;
  }

  function isSignerAuthorized(address _receviedSigner) public override virtual view returns (bool) {
    // Put your logic of signers authorisation here
    // You can check check evm addresses for providers at: https://api.redstone.finance/providers
    return _receviedSigner == 0x0C39486f770B26F5527BBBf942726537986Cd7eb; // redstone main demo provider
   
  }
}