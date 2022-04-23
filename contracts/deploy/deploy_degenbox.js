module.exports = async function ({ ethers, deployments, getNamedAccounts }) {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  //const boxCurrency = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"; //wmatic mumbai
  const boxCurrency = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"; //link rinkeby
  const period = 100;
  const fixedAmount = ethers.utils.parseEther("1");

  const feeData = await ethers.provider.getFeeData();

  const { address } = await deploy("DegenBox", {
    contract: "DegenBox",
    from: deployer,
    args: [
      period,
      boxCurrency,
      fixedAmount
    ],
    log: true,
    maxPriorityFeePerGas: feeData.maxPriorityFeePerGas,
    maxFeePerGas: feeData.maxFeePerGas
  });


  // auto verify on etherscan
  await hre.run("etherscan-verify", {
  });
};

module.exports.tags = ["DegenBox"];;