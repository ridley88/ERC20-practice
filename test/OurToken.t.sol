// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { DeployOurToken } from "script/DeployOurToken.s.sol";
import { OurToken } from "src/OurToken.sol";

contract TestOurToken is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant INITIAL_SUPPLY = 100 ether;
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    //////////////////
    /// Our Token //// 
    //////////////////

    function testInitalSupply() public view {
        uint256 totalSupply = ourToken.totalSupply();
        assertEq(totalSupply, INITIAL_SUPPLY);
    }

    function testName() public view {
        string memory expectedName = "OurToken";
        assertEq(expectedName, ourToken.name());
    }

    function testSymbol() public view {
        string memory expectedSymbol = "OT";
        assertEq(expectedSymbol, ourToken.symbol());

    }

    function testBobBalance() public view {
        console.log("BOBS BALANCE _______ =:", ourToken.balanceOf(bob));
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWorks() public {
        // transferFrom(_from, _to, _amount) <---- the caller needs "allowance"
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        console.log(" ------------ ALLOWANCE -------------");
        console.log("Bob's allowance for Alice is :", ourToken.allowance(bob, alice));

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        console.log("alice's new balance is: ", ourToken.balanceOf(alice));
        console.log("bob's new balance is: ", ourToken.balanceOf(bob));
        console.log("bob's NEW allowance for alice is:", ourToken.allowance(bob, alice));

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    // Using AI to help write tests

    function testTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        
        vm.prank(bob); // bob got all the tokens in setUp
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialBalance = ourToken.balanceOf(bob);
        vm.prank(bob);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(bob), initialBalance - amount);
    }

    function testTransferFrom() public {
        uint256 amount = 1000;
        vm.prank(bob);
        ourToken.approve(alice, amount);
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, amount);
        assertEq(ourToken.balanceOf(alice), amount);
    }
}