const {network, ethers, deployments, } = require("hardhat");

const toBytes32 = (bn) => {
  return ethers.utils.hexlify(ethers.utils.zeroPad(bn.toHexString(), 32));
};

const setStorageAt = async (address, index, value) => {
  await ethers.provider.send("hardhat_setStorageAt", [address, index, value]);
  await ethers.provider.send("evm_mine", []); // Just mines to the next block
};

async function setBalanceWithAmount(erc20Contract, slot, accounts, amount) {
  const newFormatedBalance = toBytes32(amount).toString();

  for (let i = 0; i < accounts.length; i++) {
    const index = ethers.utils.solidityKeccak256(
      ["uint256", "uint256"],
      [accounts[i], slot] // key, slot
    );

    await setStorageAt(
      erc20Contract,
      index.toString(),
      newFormatedBalance
    );
  }
};

module.exports = { setBalanceWithAmount};