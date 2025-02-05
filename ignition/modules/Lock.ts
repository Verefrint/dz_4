// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LockModule = buildModule("LockModule", (m) => {
  const lock = m.contract("DimaToken", ["0x94fD0181973d7304b7654C4c0AdED1b5a140Db7D"], undefined);

  return { lock };
});

export default LockModule;
