// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { Contract } from "ethers";
import { ethers } from "hardhat";
const {  upgrades } = require("hardhat");

let hubContract: Contract;
let DAOContract: Contract;
let ProjectContract: Contract;

async function main() {

  let hubContract;

  //--- Delpoy Contracts
  let teamDAOContract = await ethers.getContractFactory("TeamDAO").then(res => res.deploy());
  let projectContract = await ethers.getContractFactory("ProjectUpgradable").then(res => res.deploy());

  console.log("Deployed TeamDAO Contract ", teamDAOContract.address);
  console.log("Deployed Project Contract ", projectContract.address);

  //--- Deploy Hub Upgradable (UUDP)
  hubContract = await ethers.getContractFactory("HubUpgradable").then(Contract => 
    upgrades.deployProxy(Contract,
      [
        teamDAOContract.address,
        projectContract.address, 
      ],{
      kind: "uups",
      timeout: 120000
    })
  );
  // await hubContract.deployed();
  console.log("Deployed HUB: ", hubContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
