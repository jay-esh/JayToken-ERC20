// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

error TransferError();

contract JayToken {
    event Transfer(uint256 amount, address indexed _from, address indexed _to);
    event Burn(uint256 amount, address owner);

    string private s_tokename;
    string private s_tokensymbol;
    uint8 private immutable i_decimals;
    // uint256 private s_totalsupply;
    mapping(address => uint256) s_owening;
    mapping(address => mapping(address => uint256)) allowance;
    address private immutable owner;

    constructor(
        string memory tokename,
        string memory tokensymbol,
        uint8 decimals,
        uint256 totalsupply
    ) {
        s_tokename = tokename; // copies the memory variable into the storage variable
        s_tokensymbol = tokensymbol;
        i_decimals = decimals;
        // s_totalsupply = totalsupply;
        owner = msg.sender;
        s_owening[msg.sender] = totalsupply;
    }

    function _transfer(
        address _to,
        address _from,
        uint256 _value
    ) internal returns (bool) {
        require(_from != address(0) && _to != address(0), "zero address error");
        require(s_owening[_from] > _value, "not enough tokens");
        require(s_owening[_to] + _value >= s_owening[_to]);
        uint256 totalbeforetransfer = s_owening[_from] + s_owening[_to];

        s_owening[_from] = s_owening[_from] - _value;
        s_owening[_to] = s_owening[_to] + _value;

        if (totalbeforetransfer == (s_owening[_from] + s_owening[_to])) {
            emit Transfer(_value, _from, _to);
            return true;
        } else {
            revert TransferError();
        }
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(_to, msg.sender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_value <= allowance[_from][msg.sender], "not allowed"); // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_to, _from, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function burn(uint256 _amount) private {
        require(msg.sender == owner && _amount <= s_owening[owner], "Not allowed");
        s_owening[owner] -= _amount;
        emit Burn(_amount, owner);
    }

    function name() public view returns (string memory) {
        return (s_tokename);
    }

    function symbol() public view returns (string memory) {
        return (s_tokensymbol);
    }

    function decimals() public view returns (uint8) {
        return (i_decimals);
    }

    function totalSupply() public view returns (uint256) {
        return (s_owening[owner]);
    }

    function balanceOf() public view returns (uint256) {
        return (s_owening[msg.sender]);
    }
}
