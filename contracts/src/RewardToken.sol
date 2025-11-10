// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    error Err_NotOwner();

    event OwnerUpdated(address indexed);

    address public OWNER;
    uint256 public constant TOTAL_SUPPLY = 1_000_000;

    modifier onlyOwner() {
        if (msg.sender != OWNER) revert Err_NotOwner();
        _;
    }

    constructor() ERC20("Phillip Reward Token", "PRT") {
        OWNER = msg.sender; // setting the deployer as owner
        _mint(msg.sender, TOTAL_SUPPLY); // minting a totalSupply of a 1_000_000 to the deployer which he can distribute as rewards
    }

    function rewardUser(address user, uint256 amount) external onlyOwner returns (uint256 newUserBalance) {
        transfer(user, amount);
        return balanceOf(user);
    }

    function changeOwner(address _OWNER) external onlyOwner returns (address) {
        OWNER = _OWNER;
        emit OwnerUpdated(_OWNER);
        return _OWNER;
    }
}
