// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";

contract RewardTokenTest is Test {
    RewardToken rewardToken;
    address owner;
    address user1;
    address user2;

    uint256 initialSupply = 1_000_000 * 1e18;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);

        rewardToken = new RewardToken("RewardToken", "RWT");
    }

    function test_rewardUser_success() public {
        uint256 rewardAmount = 100 * 1e18;
        rewardToken.rewardUser(user1, rewardAmount);
        assertEq(rewardToken.balanceOf(user1), rewardAmount);
    }

    function test_rewardUser_revertWhenOwnerRewardsSelf() public {
        uint256 rewardAmount = 100 * 1e18;
        vm.expectRevert();
        rewardToken.rewardUser(owner, rewardAmount);
    }

    function test_rewardUser_revertWhenNotOwner() public {
        uint256 rewardAmount = 100 * 1e18;
        vm.prank(user1);
        vm.expectRevert();
        rewardToken.rewardUser(user2, rewardAmount);
    }

    function test_rewardUser_revertWhenPaused() public {
        uint256 rewardAmount = 100 * 1e18;
        rewardToken.pause();
        vm.expectRevert();
        rewardToken.rewardUser(user1, rewardAmount);
    }

    function test_transfer_success() public {
        uint256 transferAmount = 50 * 1e18;
        rewardToken.transfer(user1, transferAmount);
        assertEq(rewardToken.balanceOf(user1), transferAmount);
    }

    function test_transfer_revertWhenPaused() public {
        uint256 transferAmount = 50 * 1e18;
        rewardToken.pause();
        vm.expectRevert();
        rewardToken.transfer(user1, transferAmount);
    }

    function test_transfer_revertWhenInsufficientBalance() public {
        uint256 largeAmount = type(uint256).max;
        vm.expectRevert();
        rewardToken.transfer(user1, largeAmount);
    }

    function test_transferFrom_success() public {
        uint256 approvalAmount = 100 * 1e18;
        uint256 transferAmount = 70 * 1e18;

        rewardToken.approve(user1, approvalAmount);
        vm.prank(user1);
        rewardToken.transferFrom(owner, user2, transferAmount);

        assertEq(rewardToken.balanceOf(user2), transferAmount);
    }

    function test_transferFrom_revertWhenPaused() public {
        uint256 approvalAmount = 100 * 1e18;
        uint256 transferAmount = 50 * 1e18;

        rewardToken.approve(user1, approvalAmount);
        rewardToken.pause();
        vm.prank(user1);
        vm.expectRevert();
        rewardToken.transferFrom(owner, user2, transferAmount);
    }

    function test_transferFrom_revertWhenInsufficientBalance() public {
        uint256 largeAmount = type(uint256).max;

        rewardToken.approve(user1, largeAmount);
        vm.prank(user1);
        vm.expectRevert();
        rewardToken.transferFrom(owner, user2, largeAmount);
    }
}
