import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { vars } from "hardhat/config";


const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      chainId: 11155111,
      url: "https://purple-shy-dew.ethereum-sepolia.quiknode.pro/7bac9d41d67feb82ce301013f735a0a7e9d7b27a",
      accounts: ["d33212bbe413f052b014d52931d21de7f74284e45f89c3e6b8cc1d01178a4e09"],
    },
  },
  etherscan: {
    apiKey: 'U1ZDTMW7YTF1SKRYPD1X6PF45MF49P6ZEN',
  },
};

export default config;
