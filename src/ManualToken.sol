// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract ManualToken {

    // errors
    error ManualToken__OnlyOwnerCanMint();
    error ManualToken__OnlyOwnerCanBurn();
    error ManualToken__InsufficientBalance();

    // state variables
    address immutable i_owner;
    uint256 public s_totalSupply;

    mapping(address => uint256) private s_balances;

    constructor(uint256 _totalSupply) {
        i_owner = msg.sender;
        s_totalSupply = _totalSupply; 
        s_balances[msg.sender] = _totalSupply;
    }

    function getTotalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    function name() public pure returns(string memory) {
        return "Manual Token";
    }

    function symbol() public pure returns(string memory) {
        return "MTKN";
    }

    function decimals () public pure returns(uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return s_balances[_owner];
    }

    function transfer(address _to, uint256 _amount) public {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;
        uint256 afterBalances = balanceOf(msg.sender) + balanceOf(_to);
        require(previousBalances == afterBalances);
    }

    function mint(address _account, uint256 _value) external {
        if(msg.sender != i_owner) {
            revert ManualToken__OnlyOwnerCanMint();
        }
        s_totalSupply += _value;
        s_balances[_account] += _value;
    }

    function burn(address _from, uint256 _value) external {
        if(msg.sender != i_owner) {
            revert ManualToken__OnlyOwnerCanBurn();
        }
        uint256 fromBalance = s_balances[_from];
        if(fromBalance < _value) {
            revert ManualToken__InsufficientBalance();
        }
        unchecked {
            s_balances[_from] = fromBalance - _value;
            s_totalSupply -= _value;
        }
    }
}