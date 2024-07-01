# ERC20 Token Contract

This repository contains the implementation of a basic ERC20 token with minting and burning capabilities. The contract is written in Solidity and includes functionalities for transferring tokens, approving allowances, and managing the total supply.

## Overview

The ERC20 token standard defines a set of rules that all fungible tokens should follow. This contract implements these rules and adds additional functionalities like minting and burning of tokens.

## Contract Details

- **Name**: Custom ERC20 Token
- **Symbol**: CUSTOM
- **Decimals**: 18
- **Max Token Supply**: 1,000,000,000 (1 billion) tokens with 18 decimals

## Features

- **Minting**: Allows the owner to mint new tokens until the maximum supply is reached.
- **Burning**: Allows token holders to burn their tokens, reducing the total supply.
- **Transfers**: Standard ERC20 token transfers between addresses.
- **Approvals and Allowances**: Allows token holders to approve others to spend tokens on their behalf.

## Contract Structure

### State Variables

- `name`: The name of the token.
- `symbol`: The symbol of the token.
- `decimals`: The number of decimals the token uses.
- `totalSupply`: The total supply of tokens.
- `decimalfactor`: Factor to handle decimals.
- `Max_Token`: Maximum token limit.
- `mintAllowed`: Boolean to check if minting is allowed.
- `balanceOf`: Mapping to keep track of each address's balance.
- `allowance`: Mapping to keep track of allowances.

### Events

- `Transfer`: Triggered when tokens are transferred.
- `Approval`: Triggered when an allowance is set by `approve`.

### Functions

#### `constructor(string memory SYMBOL, string memory NAME, uint8 DECIMALS)`

Initializes the contract with a symbol, name, and decimals.

#### `function transfer(address _to, uint256 _value) public virtual returns (bool)`

Transfers tokens to a specified address.

#### `function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success)`

Transfers tokens from one address to another using an allowance mechanism.

#### `function approve(address spender, uint256 value) public returns (bool success)`

Approves a spender to transfer tokens on behalf of the caller.

#### `function burn(uint256 _value) public returns (bool success)`

Burns a specified amount of tokens.

#### `function mint(address to, uint256 value) public returns (bool success)`

Mints new tokens to a specified address.

## Usage

To interact with the contract, you can use a tool like Remix, Hardhat, or Truffle. Below is a brief guide on deploying and interacting with the contract using Remix.

### Deployment

1. Open [Remix](https://remix.ethereum.org/).
2. Create a new file and paste the contract code.
3. Compile the contract.
4. Deploy the contract, providing the token symbol, name, and decimals as constructor arguments.

### Interacting with the Contract

- **Transfer Tokens**: Use the `transfer` function to send tokens to another address.
- **Approve Allowance**: Use the `approve` function to allow another address to spend tokens on your behalf.
- **Transfer From**: Use the `transferFrom` function to transfer tokens on behalf of another address, using the allowance mechanism.
- **Burn Tokens**: Use the `burn` function to destroy tokens and reduce the total supply.
- **Mint Tokens**: Use the `mint` function to create new tokens, only callable by the owner.

## License

This project is licensed under the MIT License.

## Acknowledgements

- The OpenZeppelin library for providing the `Ownable` contract.
- The Ethereum community for the ERC20 standard.

