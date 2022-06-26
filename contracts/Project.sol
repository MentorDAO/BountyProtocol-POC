//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";


// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";



import "./interfaces/IProject.sol";
import "./abstract/CommonUpgradable.sol";

/**
 * @title Project Contract
 */
contract ProjectUpgradable is 
    IProject
    , Initializable
    , UUPSUpgradeable
    , CommonUpgradable  {
    //-- Storage

    //Contract Admin Address
    address admin;
    //Escrow in account
    uint256 public funds;

    // Contract name
    string public name;
    // Contract symbol
    string public constant override symbol = "PROJECT";

    //Lifecycle
    enum CaseStage {
        Draft,
        Open,
        Accepted,
        Delivered, 
        Approved,
        Cancelled
    }

    //-- Functions

    /// Initializer
    function initialize (address hub, string calldata name_, string calldata uri_) public payable override initializer {
        //Initializers
        __common_init(hub);
        __UUPSUpgradeable_init();
        //Set Contract URI
        _setContractURI(uri_);
        //Identifiers
        name = name_;
        //Track Funds
        if(msg.value > 0){
            funds += msg.value;
        }
    }
    
    /// Upgrade
    function _authorizeUpgrade(address newImplementation) internal onlyOwner override {}


    /// TODO: Deposit

    /// TODO: Withdraw


}