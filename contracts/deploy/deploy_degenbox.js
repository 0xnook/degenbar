module.exports = async function ({ ethers, deployments, getNamedAccounts }) {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  //const boxCurrency = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889"; //eth boba rinkeby
  const boxCurrency = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"; //dai polygon
  const period = 604800; // 7 days
  const fixedAmount = ethers.utils.parseEther("5");

  const feeData = await ethers.provider.getFeeData();

   // get max fees from gas station
let maxFeePerGas = ethers.BigNumber.from(40000000000) // fallback to 40 gwei
let maxPriorityFeePerGas = ethers.BigNumber.from(40000000000) // fallback to 40 gwei
try {
    const { data } = await axios({
        method: 'get',
        url: 'https://gasstation-mainnet.matic.network/v2'
    })
    maxFeePerGas = ethers.utils.parseUnits(
        Math.ceil(data.fast.maxFee) + '',
        'gwei'
    )
    maxPriorityFeePerGas = ethers.utils.parseUnits(
        Math.ceil(data.fast.maxPriorityFee) + '',
        'gwei'
    )
} catch {
    // ignore
}


  const { address } = await deploy("DegenBox", {
    contract: "DegenBoxV2",
    from: deployer,
    args: [
      period,
      boxCurrency,
      fixedAmount
    ],
    log: true,
    maxPriorityFeePerGas: maxPriorityFeePerGas,
    maxFeePerGas: maxFeePerGas,
  });


  // auto verify on etherscan
  await hre.run("etherscan-verify", {
  });
};

module.exports.tags = ["DegenBox"];;