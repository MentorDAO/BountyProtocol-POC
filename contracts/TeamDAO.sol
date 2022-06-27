//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "hardhat/console.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/draft-ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./interfaces/ITeamDAO.sol";
import "./interfaces/IProject.sol";
import "./abstract/CommonUpgradable.sol";

/**
 * @title Team DAO
 * This would probably ideally be an ERC1155
 * 
 * 
 */
contract TeamDAO is 
        ITeamDAO,
        Initializable, 
        ERC721Upgradeable, 
        ERC721URIStorageUpgradeable, 
        ERC721BurnableUpgradeable, 
        // OwnableUpgradeable, 
        EIP712Upgradeable, 
        ERC721VotesUpgradeable, 
        UUPSUpgradeable,
        CommonUpgradable {
    
    //--- Storage

    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;
    
    // Contract name
    // string public name;
    // Contract symbol
    // string public symbol;

    //--- Functions

    /// ERC165 - Supported Interfaces
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(ITeamDAO).interfaceId 
            || super.supportsInterface(interfaceId);
    }

    /// Initializer
    function initialize (address hub, string calldata name_, string calldata uri_) public override initializer {
        //Initializers
        __common_init(hub);
        //Set Contract URI
        _setContractURI(uri_);
        //Identifiers
        // name = name_;
        
        __ERC721_init(name_, "TEAM");
        __ERC721URIStorage_init();
        __ERC721Burnable_init();
        // __Ownable_init();
        __EIP712_init(name_, "1");
        __ERC721Votes_init();
        __UUPSUpgradeable_init();

        //Mint First Token to Creator (Admin Token)
        _safeMint(tx.origin);
    }
    
    /** 
    * @dev Hook that is called before any token transfer. This includes minting and burning, as well as batched variants.
    *  - Max of Single Token for each account
    */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        if (to != address(0)){ //Not Burn
            //Validate - Max of 1 Per Account
            require(balanceOf(to) == 0, "ALREADY_OWNES_TOKEN");
        }
    }

    /// TODO: Set Token URI


    /// Set Contract URI
    function setContractURI(string calldata contract_uri) external override {
        //Validate Permissions
        // require(  , "INVALID_PERMISSIONS");
        //Set
        _setContractURI(contract_uri);
    }
    
    /// Check if user is Admin
    function isAdmin(address walletAddr) public view returns(bool) {
        //Owner of first token
        return (ownerOf(1) == walletAddr);
    }

    /// Upgrade
    function _authorizeUpgrade(address newImplementation) internal onlyOwner override {}

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal override (ERC721Upgradeable, ERC721VotesUpgradeable) {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory) {
        return super.tokenURI(tokenId);
    }

    //-- Custom Functionality
    
    event JoinRequest(address aplicantAddress, string uri);

    /// Request to Join
    function requestJoin(string memory uri) external{
        emit JoinRequest(_msgSender(), uri);
    } 

    /// Accept Join Request
    function acceptJoin(address aplicantAddress) external{
        require(isAdmin(_msgSender()), "ADMIN_ONLY");
        _safeMint(aplicantAddress);
        // _setTokenURI(tokenId, uri);
    }

    /// Mint Wrapper Function
    function _safeMint(address to) internal {
        _tokenIds.increment();
        _safeMint(tx.origin, _tokenIds.current());
    }
}

