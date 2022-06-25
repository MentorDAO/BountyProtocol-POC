import { expect } from "chai";
import { Contract, ContractReceipt, Signer } from "ethers";
import { ethers } from "hardhat";
const {  upgrades } = require("hardhat");

//Test Data
const ZERO_ADDR = '0x0000000000000000000000000000000000000000';
let test_uri = "ipfs://QmQxkoWcpFgMa7bCzxaANWtSt43J1iMgksjNnT4vM1Apd7"; //"TEST_URI";
let test_uri2 = "ipfs://TEST2";
let actionGUID = "";

describe("Mentor Protocol", function () {
  //Contract Instances
  let configContract: Contract;
  let hubContract: Contract;
  let TeamDAOContract: Contract;
  let projectContract: Contract;

  //Addresses
  let owner: Signer;
  let tester: Signer;
  let tester2: Signer;
  let tester3: Signer;
  let tester4: Signer;
  let tester5: Signer;
  let addrs: Signer[];


  before(async function () {

    //--- Deploy Assoc Repo
    this.teamDAO = await ethers.getContractFactory("TeamDAO").then(res => res.deploy());
    this.project = await ethers.getContractFactory("ProjectUpgradable").then(res => res.deploy());

    //--- Deploy Hub Upgradable (UUDP)
    hubContract = await ethers.getContractFactory("HubUpgradable").then(Contract => 
      upgrades.deployProxy(Contract,
        [
          this.teamDAO.address,
          this.project.address, 
        ],{
        // https://docs.openzeppelin.com/upgrades-plugins/1.x/api-hardhat-upgrades#common-options
        kind: "uups",
        timeout: 120000
      })
    );
    // await hubContract.deployed();
      console.log("Deployed HUB: ", hubContract.address);

    //Set Avatar Contract to Hub
    // hubContract.setAssoc("history", actionContract.address);

    //Populate Accounts
    [owner, tester, tester2, tester3, tester4, tester5, ...addrs] = await ethers.getSigners();
    //Addresses
    this.testerAddr = await tester.getAddress();
    this.tester2Addr = await tester2.getAddress();
    this.tester3Addr = await tester3.getAddress();
    this.tester4Addr = await tester4.getAddress();
    this.tester5Addr = await tester5.getAddress();
  });

  describe("Hub", function () {

    it("Should be owned by deployer", async function () {
      expect(await hubContract.owner()).to.equal(await owner.getAddress());
    });


    /**
     * Team DAO Contract
     */
    describe("TeamDAO", function () {
      
      before(async function () {
        //Simulate to Get New teamDAO Address
        let MDAOAddr = await hubContract.callStatic.teamDAOMake("Test DAO", test_uri);
        //Create New teamDAO
        let tx = await hubContract.teamDAOMake("Test DAO", test_uri);
        //Expect Valid Address
        expect(MDAOAddr).to.be.properAddress;
        //Expect Case Created Event
        await expect(tx).to.emit(hubContract, 'ContractCreated').withArgs("TeamDAO", MDAOAddr);
        //Init teamDAO Contract Object
        TeamDAOContract = await ethers.getContractFactory("TeamDAO").then(res => res.attach(MDAOAddr));
        this.TeamDAOContract = TeamDAOContract;
      });

    });
  });
});
