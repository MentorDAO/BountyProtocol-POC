//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";

import "./interfaces/IProject.sol";
import "./abstract/CommonUpgradable.sol";

/**
 * @title Project Contract
 */
contract ProjectUpgradable is IProject {
    //-- Storage

    
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

    /// Init (New Project)

        /// Requirements(URI), Payment

    /// Deposit

    /// Withdraw


}