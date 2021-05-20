pragma solidity ^0.8.0;


import "./util/safemath.sol";

contract Erc20Token {

    using SafeMath for uint256;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    struct Account 
    {
        uint256 currentBalance;
        uint256 lastDividends;
    }
    
    uint256 public totalDividends;
    mapping (address => Account) accounts;


    address ownerAccount;

    //mapping (address => uint256) balances;
    //mapping (address => mapping (address => uint256)) allowed;

    uint256 public TotalSupply = 0;

    function releaseDividend(uint256 amount) public returns (bool success)
    {
        if(msg.sender == ownerAccount)
        {
            totalDividends = totalDividends.add(amount);
            return true;
        }
        return false;
    }

    function getUnclaimedDividen() public view returns (uint256)
    {
        uint256 newDividends = totalDividends.sub(accounts[msg.sender].lastDividends);
        uint256 product = accounts[msg.sender].currentBalance.mul(newDividends);
        return product.div(TotalSupply);
    }
    
    function claimDividend() public 
    {
        uint256 unclaimedDividend = getUnclaimedDividen();
        if(unclaimedDividend > 0)
        {
            accounts[msg.sender].currentBalance = accounts[msg.sender].currentBalance.add(unclaimedDividend);
            accounts[msg.sender].lastDividends = totalDividends;
        }
    }

    function totalSupply() public view returns (uint256 supply) {
        return TotalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (accounts[msg.sender].currentBalance >= _value && _value > 0) {
            accounts[msg.sender] .currentBalance= accounts[msg.sender].currentBalance.sub(_value);
            accounts[_to].currentBalance = accounts[_to].currentBalance.add(_value);
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
        //    balances[_to] = balances[_to].add(_value);
        //    balances[_from] = balances[_from].sub(_value);
        //    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        //    emit Transfer(_from, _to, _value);
        //    return true;
        //} else { return false; }
        return false;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return accounts[_owner].currentBalance;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        //allowed[msg.sender][_spender] = _value;
        //emit Approval(msg.sender, _spender, _value);
        //return true;
    }

    function allowance(address _owner, address _spender) public returns (uint256 remaining) {
        //return allowed[_owner][_spender];
    }

}

contract DividenToken is Erc20Token
{
    string public name = "D4V";
    string public symbol = "D4V";
    constructor ()
    {
        TotalSupply = 10000;
        accounts[msg.sender].currentBalance = TotalSupply;  
        ownerAccount = msg.sender;
    }
}