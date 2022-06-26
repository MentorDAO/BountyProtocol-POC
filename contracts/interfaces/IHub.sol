// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IHub {
    
    //--- Functions

    /// Arbitrary contract symbol
    function symbol() external view returns (string memory);
        
    /// Get Owner
    function owner() external view returns (address);

    /// Deploy a new DAO Contract
    function teamDAOMake(string calldata name_, string calldata uri_) external payable returns (address);

    /// Deploy a new Project Contract
    function projectMake(string calldata name_, string calldata uri_) external payable returns (address);

    //--- Events

    /// Beacon Contract Chnaged
    event UpdatedImplementation(string name, address implementation);

    /// New Contract Created
    event ContractCreated(string name, address contractAddress);

}
