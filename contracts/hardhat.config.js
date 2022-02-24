require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("hardhat-deploy");


 function getMnemonic(networkName) {
  if (networkName) {
    const mnemonic = process.env['MNEMONIC_' + networkName.toUpperCase()];
    if (mnemonic && mnemonic !== '') {
      return mnemonic;
    }
  }

  const mnemonic = process.env.MNEMONIC;
  if (!mnemonic || mnemonic === '') {
    return 'test test test test test test test test test test test junk';
  }
  return mnemonic;
}

function accounts(networkName){
  return {mnemonic: getMnemonic(networkName)};
}

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: accounts("mainnet"),
      gasPrice: 120 * 1000000000,
      chainId: 1,
    },
    localhost: {
      live: false,
      saveDeployments: true,
      tags: ["local"],
      
    },
    hardhat: {
      initialBaseFeePerGas: 0,
      accounts: accounts(),
      forking: {
        enabled: process.env.FORKING === "true",
        url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
        blockNumber: 13191833,
      },
      live: false,
      saveDeployments: true,
      chainId: 31337, // the default chain ID used by Hardhat Network's blockchain
      tags: ["test", "local"]
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: accounts("kovan"),
      chainId: 42,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      gasPrice: 20000000000,
      gasMultiplier: 2,
    },
    kovanOptimism: {
      url: 'https://kovan.optimism.io',
      accounts: accounts("kovan"),
      chainId: 69,
      live: true,
      saveDeployments: true,
      tags: ["staging"],
      //deploy: ['deploy_optimism']
    },
    optimism: {
        //url: `https://opt-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY_OPTIMISM}`,
        url: "https://mainnet.optimism.io",
        accounts: accounts("mainnet"),
        //chainId: 10,
        live: true,
        saveDeployments: true,
        deploy: ['deploy_optimism']
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  namedAccounts: {
    deployer: {
      default: 0,
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.11"
      },
    ],
  },
  paths: {
    sources: "./src",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 100000
  }
};
