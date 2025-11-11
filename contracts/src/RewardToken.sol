// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol"; // Enables gasless approvals for transfers
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title RewardToken
 * @author Atharva Muley
 * @dev ERC20 token with pausable transfers, rewards and permit functionality
 * Includes an ownership scheme for admin control and emergency pause capability
 */
contract RewardToken is ERC20, ERC20Permit, Pausable {
    /*//////////////////////////////////////////////////////////////
                             CUSTOM ERRORS
    //////////////////////////////////////////////////////////////*/

    /// @notice thrown when caller is not the current owner
    error Err_NotOwner();

    /// @notice thrown when an invalid address is provided
    error InvalidAddress();

    /// @notice thrown when caller is not the pending owner during ownership acceptance
    error NotPendingOwner();

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice emitted when ownership transfer is initiated to a new address
    /// @param newOwner address of the new pending owner
    event OwnershipTransferInitiated(address indexed newOwner);

    /// @notice emitted when ownership transfer is completed
    /// @param newOwner address of the new owner
    event OwnershipTransferred(address indexed newOwner);

    /// @notice emitted when Owner Rewards a user
    /// @param user address of the user being rewarded
    /// @param amount amount of tokens being rewarded
    event UserRewarded(address indexed user, uint256 indexed amount);

    /// @notice Transfer event is taken care of by Openzeppelin's ERC20 inherited by this contract

    /*//////////////////////////////////////////////////////////////
                              STORAGE VARIABLES
    //////////////////////////////////////////////////////////////*/
    /// @notice current owner with admin privileges
    address public OWNER;

    /// @notice total supply of tokens,keeping it constant for gas savings
    uint256 public constant TOTAL_SUPPLY = 1_000_000e18;

    /// @notice address pending to accept ownership
    address public pendingOwner;

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @dev modifier that restricts function access to the current owner only
    modifier onlyOwner() {
        if (msg.sender != OWNER) revert Err_NotOwner();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice sets the deployer as owner, and mints initial supply to owner
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     */
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) ERC20Permit(_name) {
        OWNER = msg.sender;
        mint(msg.sender, TOTAL_SUPPLY);
    }

    /*//////////////////////////////////////////////////////////////
                        USER-FACING FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice rewards a user by transferring tokens from the owner's balance
     * @dev only callable by owner and when contract is not paused
     * @param user recipient address
     * @param amount amount of tokens to send as reward
     * @return newUserBalance updated balance of the rewarded user
     */
    function rewardUser(address user, uint256 amount)
        external
        onlyOwner
        whenNotPaused
        returns (uint256 newUserBalance)
    {
        transferFrom(OWNER, user, amount);
        return balanceOf(user);
    }

    /**
     * @notice transfers tokens, disabled when paused
     */
    function transfer(address to, uint256 value) public override whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    /**
     * @notice transfers tokens on behalf of another address, disabled when paused
     */
    function transferFrom(address from, address to, uint256 value) public override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    /*//////////////////////////////////////////////////////////////
                              ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice mints new tokens to a specified address
     * @dev callable only by owner and when contract not paused
     * @param to recipient address
     * @param value amount to mint
     */
    function mint(address to, uint256 value) public onlyOwner whenNotPaused {
        _mint(to, value);
    }

    /**
     * @notice initiates transfer of ownership to a new address
     * @dev new owner must call acceptOwnership to finalize
     * @param _NewOwner address of the new pending owner
     */
    function transferOwnership(address _NewOwner) external onlyOwner {
        if (_NewOwner == address(0) || _NewOwner == address(this)) revert InvalidAddress();
        pendingOwner = _NewOwner;
        emit OwnershipTransferInitiated(_NewOwner);
    }

    /**
     * @notice allows pending owner to accept ownership
     * reverts if caller is not the pending owner
     */
    function acceptOwnership() external {
        if (pendingOwner != msg.sender) revert NotPendingOwner();
        OWNER = msg.sender;
        emit OwnershipTransferred(msg.sender);
    }

    /**
     * @notice returns the current owner address
     */
    function getOwner() external view returns (address) {
        return OWNER;
    }

    /**
     * @notice returns the total token supply
     */
    function getTotalSupply() external pure returns (uint256) {
        return TOTAL_SUPPLY;
    }

    /**
     * @notice triggers emergency pause, disabling token transfers and minting
     * @dev accessible only by the owner
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice lifts the emergency pause, re-enabling token operations
     * @dev accessible only by the owner
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
