pragma solidity ^0.8.0;

import "util/erc20.sol"



contract DividenToken is Erc20Token
{
    string public name = "DIV";
    string public symbol = "DIV";
    constructor ()
    {
        balances[msg.sender] = uiTotalSupply;   
    }
}