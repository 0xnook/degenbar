
module.exports = async function ({ ethers, deployments, getNamedAccounts }) {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  const feeData = await ethers.provider.getFeeData();

  const { address } = await deploy("TestContract", {
    contract: "TestContract",
    from: deployer,
    args: [],
    log: true,
    maxPriorityFeePerGas: feeData.maxPriorityFeePerGas,
    maxFeePerGas: feeData.maxFeePerGas
  });
};

module.exports.tags = ["TestContract"];