// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {ManualToken} from "src/ManualToken.sol";

contract TestManualToken is Test {
    ManualToken private manualToken;

    function setUp() public {
        uint256 initialSupply = 100 ether;
        manualToken = new ManualToken(initialSupply);
        console.log("SETUP ___________________");
        // console.log("msg.sender here is :", msg.sender);
        // console.log(manualToken.balanceOf(address(this)));
        // console.log("msg.sender's balance is :", manualToken.balanceOf(msg.sender));
    }

    function testTokenName() public view {
        string memory tokenName = manualToken.name();
        assertEq(tokenName, "Manual Token", "The token name should be 'Manual Token'");
    }

    function testTotalSupply() public view {
        uint256 expectedTotalSupply = 100 ether;
        uint256 manualTokenTotalSupply = manualToken.getTotalSupply();
        assertEq(expectedTotalSupply, manualTokenTotalSupply);
    }

    function testDecimals() public view {
        uint256 expectedDecimals = 18;
        uint256 manualTokenDecimals = manualToken.decimals();
        assertEq(expectedDecimals, manualTokenDecimals);
    }

    function testBalanceOfWorks() public view {
        console.log("The balance of the msg.sender is: ", manualToken.balanceOf(msg.sender));
    }

    function testMintWorks() public {
        uint256 mintAmount = 1 ether;
        vm.prank(address(this));
        console.log("MINT ___________________");
        
        manualToken.mint(address(this), mintAmount);
        
        assertEq(manualToken.balanceOf(address(this)), manualToken.getTotalSupply());
    }

    function testBurnWorks() public {
        uint256 burnAmount = 1 ether;
        vm.prank(address(this));
        console.log("BURN ____________");

        manualToken.burn(address(this), burnAmount);
        // total supply should decrease by burn amount, the same as the balance of this contract
        assertEq(manualToken.balanceOf(address(this)), manualToken.getTotalSupply());
    }
}