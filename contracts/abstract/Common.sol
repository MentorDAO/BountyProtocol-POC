//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "../interfaces/ICommon.sol";
import "../interfaces/IHub.sol";

/**
 * Common Protocol Functions
 */
abstract contract Common is ICommon, Ownable {
    
    //--- Storage

    // address internal _HUB;    //Hub Contract
    IHub internal _HUB;    //Hub Contract
    

    //--- Functions

    constructor(address hub){
        //Set Protocol's Config Address
        _setHub(hub);
    }

    /// Inherit owner from Protocol's config
    function owner() public view override (ICommon, Ownable) returns (address) {
        return _HUB.owner();
    }

    /// Get Current Hub Contract Address
    function getHub() external view override returns(address) {
        return _getHub();
    }

    /// Get Hub Contract
    function _getHub() internal view returns(address) {
        return address(_HUB);
    }

    /// Change Hub (Move To a New Hub)
    function setHub(address hubAddr) external override {
        require(_msgSender() == address(_HUB), "HUB:UNAUTHORIZED_CALLER");
        _setHub(hubAddr);
    }

    /// Set Hub Contract
    function _setHub(address hubAddr) internal {
        //Validate Contract's Designation
        // require(keccak256(abi.encodePacked(IHub(hubAddr).symbol())) == keccak256(abi.encodePacked("MENTORHUB")), "Invalid Hub Contract");
        //Set
        _HUB = IHub(hubAddr);
    }
    
}
