// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/ERC20.sol


pragma solidity ^0.8.7;


contract ERC20 is Ownable {

    //public state variables 
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 decimalfactor;
    uint256 public Max_Token;
    bool mintAllowed = true;

    // Mapping for balances and allowance 
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev Emitted when a user transfer the tokens.
     * @param from The address of the owner of the contract.
     * @param to The address of the receiver address who want some tokens.
     * @param value The value is the amount of the tokens receiver wants.
     */ 
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @notice Initializes a new instance of the contract.
     * @param SYMBOL The symbol of the ERC20 token.
     * @param NAME The Name of the ERC20 token.
     * @param DECIMALS The number of decimals for the token.
     */
    constructor(
        string memory SYMBOL,
        string memory NAME,
        uint8 DECIMALS
    ) {
        symbol = SYMBOL;
        name = NAME;
        decimals = DECIMALS;
        decimalfactor = 10**uint256(decimals);
        Max_Token = 1000000000000000000000000000 * decimalfactor;
    }

    /**
     * @notice Internal function to handle transfers.
     * @param _from The address to transfer from.
     * @param _to The address to transfer to.
     * @param _value The amount of tokens to transfer.
     */
    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(
            balanceOf[_from] >= _value,
            "ERC20: 'from' address balance is low"
        );
        require(
            balanceOf[_to] + _value >= balanceOf[_to],
            "ERC20: Value is negative"
        );

        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * @notice Transfers tokens to a specified address.
     * @param _to The address to transfer to.
     * @param _value The amount of tokens to be transferred.
     * @return bool Returns true if the transfer was successful.
     */
    function transfer(address _to, uint256 _value)
        public
        virtual
        returns (bool)
    {
        _transfer(msg.sender, _to, _value);
        // require(owner() == msg.sender, "ERC20: Only Owner can transfer");
        return true;
    }

    /**
     * @notice Transfers tokens from one address to another.
     * @param _from The address to transfer from.
     * @param _to The address to transfer to.
     * @param _value The amount of tokens to be transferred.
     * @return bool Returns true if the transfer was successful.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool success) {
        require(
            _value <= allowance[_from][msg.sender],
            "ERC20: Allowance error"
        );
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * @notice Approves a spender to transfer tokens on behalf of the caller.
     * @param spender The address authorized to spend the tokens.
     * @param value The amount of tokens the spender is authorized to spend.
     * @return bool Returns true if the approval was successful.
     */
    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @notice Burns a specified amount of tokens.
     * @param _value The amount of tokens to be burned.
     * @return bool Returns true if the burn was successful.
     */
    function burn(uint256 _value) public returns (bool success) {
        require(
            balanceOf[msg.sender] >= _value,
            "ERC20: Transfer amount exceeds user balance"
        );
        balanceOf[msg.sender] -= _value;

        totalSupply -= _value;
        mintAllowed = true;
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    /**
     * @notice Mints new tokens to a specified address.
     * @param to The address to mint the tokens to.
     * @param value The amount of tokens to be minted.
     * @return bool Returns true if the mint was successful.
     */
    function mint(address to, uint256 value) public returns (bool success) {
        require(
            Max_Token >= (totalSupply + value),
            "ERC20: Max Token limit exceeds"
        );
        require(mintAllowed, "ERC20: Max supply reached");

        if (Max_Token == (totalSupply + value)) {
            mintAllowed = false;
        }

        require(owner() == msg.sender, "ERC20: Only Owner Can Mint");

        balanceOf[to] += value;
        totalSupply += value;
        require(
            balanceOf[to] >= value,
            "ERC20: Transfer amount cannot be negative"
        );

        emit Transfer(address(0), to, value);
        return true;
    }
}