//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// import "./public/interfaces/IOpenRepo.sol";
// import "./interfaces/ICommon.sol";
import "./interfaces/IHub.sol";
import "./interfaces/IProject.sol";
import "./interfaces/ITeamDAO.sol";
import "./abstract/ContractBase.sol";

/**
 * Hub Contract
 */
contract HubUpgradable is 
        IHub 
        , Initializable
        , ContractBase
        , OwnableUpgradeable 
        , UUPSUpgradeable
        , ERC165Upgradeable
    {

    //---Storage

    // Arbitrary contract designation signature
    string public constant override symbol = "MENTORHUB";

    address public beaconProject;
    address public beaconTeamDAO;

    //Deployed Contracts
    mapping(address => bool) internal _teamDAOs;
    mapping(address => address) internal _projects;

    //--- Functions
 
    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IHub).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    /// Inherit owner from Protocol's config
    function owner() public view override(IHub, OwnableUpgradeable) returns (address) {
        return OwnableUpgradeable.owner();
    }

    /// Upgrade Permissions
    function _authorizeUpgrade(address newImplementation) internal onlyOwner override { }

    /// Initializer
    function initialize (
        address TeamDAOContract,
        address projectContract
    ) public initializer {
        //Initializers
        __Ownable_init();
        __UUPSUpgradeable_init();
        //Set Contract URI
        // _setContractURI(uri_);
        //Init DAO Contract Beacon
        UpgradeableBeacon _beaconM = new UpgradeableBeacon(TeamDAOContract);
        beaconTeamDAO = address(_beaconM);
        //Init Project Contract Beacon
        UpgradeableBeacon _beaconP = new UpgradeableBeacon(projectContract);
        beaconProject = address(_beaconP);
    }

    /*
    //-- Assoc

    /// Set Association
    function setAssoc(string memory key, address contractAddr) external onlyOwner {
        repo().addressSet(key, contractAddr);
    }

    /// Get Contract Association
    function getAssoc(string memory key) public view override returns(address) {
        //If string match "repo" return the repo address
        // if(keccak256(abi.encodePacked("repo")) == keccak256(abi.encodePacked(key))) return address(repo());
        
        //Return address from the Repo
        return repo().addressGet(key);
    }

    //Repo Address
    function repoAddr() external view override returns(address) {
        return address(repo());
    }
    */

    //--- Factory 

    /// Deploy a new DAO Contract
    function teamDAOMake(string calldata name_, string calldata uri_) external override returns (address) {
        //Deploy
        BeaconProxy newProxy = new BeaconProxy(
            beaconTeamDAO,
            abi.encodeWithSelector(
                ITeamDAO( payable(address(0)) ).initialize.selector,
                address(this),   //Hub
                name_,          //Name
                uri_            //Contract URI
            )
        );
        //Event
        emit ContractCreated("TeamDAO", address(newProxy));
        //Remember
        _teamDAOs[address(newProxy)] = true;
        //Return
        return address(newProxy);
    }

    /// Deploy a new Project Contract
    function projectMake(string calldata name_, string calldata uri_) external override returns (address) {
        //Deploy
        BeaconProxy newProxy = new BeaconProxy(
            beaconProject,
            abi.encodeWithSelector(
                IProject( payable(address(0)) ).initialize.selector,
                address(this),   //Hub
                name_,          //Name
                uri_
            )
        );
        //Event
        emit ContractCreated("Project", address(newProxy));
        //Remember
        _projects[address(newProxy)] = _msgSender();
        //Return
        return address(newProxy);
    }

    //-- Updates

    /// Upgrade Contract Implementation
    function upgradeMentorImplementation(address newImplementation) public onlyOwner {
        //Upgrade Beacon
        UpgradeableBeacon(beaconTeamDAO).upgradeTo(newImplementation);
        //Upgrade Event
        emit UpdatedImplementation("TeamDAOContract", newImplementation);
    }

    /// Upgrade Contract Implementation
    function upgradeProjectImplementation(address newImplementation) public onlyOwner {
        //Upgrade Beacon
        UpgradeableBeacon(beaconProject).upgradeTo(newImplementation);
        //Upgrade Event
        emit UpdatedImplementation("ProjectContract", newImplementation);
    }


}