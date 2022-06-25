// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface ITeamDAO {

    /// Initialize
    function initialize(address hub, string calldata name_, string calldata uri_) external;

    /// Set Contract URI
    function setContractURI(string calldata contract_uri) external;
    
    /// Request to Join
    function requestJoin(string memory uri) external; 

    /// Accept Join Request
    function acceptJoin(address aplicantAddress) external; 

    /// Reject Join Request (Just an event?)
    // function rejectJoin(address aplicantAddress) external; 
/* TBD
    /// Apply to Project
    function applyToProject(address projectAddr, string calldata uri) external; 

    /// Deliver Product
    function deliver(string calldata uri) external;

    /// Approve Delivery 
    function ApproveDelivery() external;
*/
}