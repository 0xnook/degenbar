const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setBalanceWithAmount } = require("./helper");

describe("DegenBox", function () {
  let degenBox;

  let deployer
  let owner;
  let sig1;
  let sig2;
  let sig3;
  let sig4;
  let sig5;
  let accounts;
  let signers;

  const daiAddress = "0x6b175474e89094c44da98b954eedeac495271d0f";

  before(async () => {
    [deployer,owner,sig1,sig2,sig3,sig4,sig5] = await ethers.getSigners();
    signers = [owner,sig1,sig2,sig3,sig4,sig5];
    accounts = [owner.address,sig1.address,sig2.address,sig3.address,sig4.address,sig5.address];

    const DegenBox = await ethers.getContractFactory("DegenBox");
    degenBox = await DegenBox.deploy(1000000, daiAddress);
    await degenBox.deployed();

    daiContract = await ethers.getContractAt("IERC20",daiAddress);
    await daiContract.connect(sig1).approve(degenBox.address, "0x8000000000000000000000000000000000000000000000000000000000000000");

    await setBalanceWithAmount(daiAddress, 2, accounts, ethers.utils.parseEther("10000"));
  })
  it("Should play multiple times", async function () {

    for(let i = 0; i<100; i++){
      degenBox.connect(sig1).steal(ethers.utils.parseEther("5"));
      await ethers.provider.send("evm_increaseTime", [100]);
      await ethers.provider.send("evm_mine");
    }
  });
});
