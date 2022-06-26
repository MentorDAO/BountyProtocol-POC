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
  // let teamDAOContract = await ethers.getContractFactory("TeamDAO").then(res => res.deploy());
  // let projectContract = await ethers.getContractFactory("ProjectUpgradable").then(res => res.deploy());

  //Rinkeby
  // let teamDAOContract = {address: "0xaE7B970Ea9c1C9041c2E4531B931b6fd880013Bf"};
  // let projectContract = {address: "0xCf00360666178Cb0f59C59C548916de86601A816"};
  //Hub: 
  
  //Mumbai
  let teamDAOContract = {address: "0xc3B140b36f1514012F8c84823D93779673B6e366"};
  let projectContract = {address: "0x5e4E3c4Ae5E5BAd5c2Fb779e0921aE634B2b142c"};
  //Hub: 

  //Optimism Kovan
  // let teamDAOContract = {address: "0x9D4F0134898b8d1dA1Da2bc6908E57d0Ded6aC4e"};
  // let projectContract = {address: "0xF31D0B55Aff365E68535C6B83b4C4D3C72F613b7"};
  //Hub: 0x402d30e7dba9be455203a9d02bab122bc5f59549
  //Hub IMPL: 0xb36D35f902DEaE9af4a996735a9b4F8dE64a7309
  
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
