pragma solidity ^0.4.16;

// ----------------------------------------------------------------------------------------------
// Basic ERC20 Token Contract
//
// Amnesiacu 2017. The MIT Licence.
// ----------------------------------------------------------------------------------------------

// ERC Token Standard Interface (ERC20)
contract ERC20Interface {

    // @return Total amount of tokens
    function totalSupply() constant returns (uint256 totalSupply);

    // Get the account balance of address `_owner`
    // @param _owner Address of which the balance will be retrieved
    // @return Balance
    function balanceOf(address _owner) constant returns (uint256 balance);

    // Send `_value` amount of tokens to address `_to`
    // @param _to Address of which to send tokens
    // @param _value Amount of tokens to send
    // @return success
    function transfer(address _to, uint256 _value) returns (bool success);

    // send `_value` amount of tokens tokens to `_to` from `_from` on the condition it is approved by `_from`
    // @param _from Address of the sender
    // @param _to Address of the recipient
    // @param _value Amount of tokens to be transferred
    // @return success
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    // Allow `_spender` to withdraw `_value` tokens
    // @param _spender Address of the account able to transfer the tokens
    // @param _value Amount to be approved for transfer
    // @return success
    function approve(address _spender, uint256 _value) returns (bool success);

    // @param _owner Address of the account owning tokens
    // @param _spender Address of the account able to transfer the tokens
    // @return Amount of remaining tokens allowed to spend
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

// OfficeToken Implementing ERC Contract
contract OfficeToken is ERC20Interface {

    string public name;
    string public symbol;
    uint8 public decimals;

    address public owner;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 _totalSupply;

    // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    // Constructor
    function OfficeToken() {
        owner = msg.sender;
        name = "OfficeToken";
        symbol = "OT";
        decimals = 18;
        // 1 billion tokens, 18 decimal places
        _totalSupply = 10**27; 
        balances[owner] = _totalSupply 
    }

    function totalSupply() constant returns (uint256 totalSupply) {
        totalSupply = _totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] >= _amount && _amount > 0) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
           return false;
        }
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] >= _amount
            && allowed[_from][msg.sender] >= _amount
            && _amount > 0) {

            balances[_to] += _amount;
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function () {
        throw;
    }
}
