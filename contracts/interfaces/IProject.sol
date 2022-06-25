// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IProject {

    /// Initialize
    function initialize(address hub, string calldata name_, string calldata uri_) external payable;

    /// Arbitrary contract symbol
    function symbol() external view returns (string memory);
        
    /// Apply

    /// Accept Application

    /// Reject Application

    /// Approve Delivery

    /// Deny Delivery


}