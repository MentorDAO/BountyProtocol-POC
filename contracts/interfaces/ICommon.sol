//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

/**
 * Common Protocol Functions
 */
interface ICommon {
    
    /// Inherit owner from Protocol's config
    function owner() external view returns (address);
    
    // Change Hub (Move To a New Hub)
    function setHub(address hubAddr) external;

    /// Get Hub Contract
    function getHub() external view returns(address);
    
    //-- Events

}
