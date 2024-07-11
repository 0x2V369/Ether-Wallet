# EtherWallet Smart Contract

EtherWallet is a simple and secure smart contract designed to function as an Ethereum wallet with owner-exclusive withdrawal capabilities. This contract allows the owner to manage Ether transactions and provides transparency through event logging.

## Features

- **Owner-exclusive Withdrawals**: Only the contract owner can withdraw Ether from the contract.
- **Event Logging**: Logs every Ether transaction (deposit, withdrawal, and fallback) with detailed information for transparency and auditability.
- **Flexible Withdrawal Options**: Provides functions to withdraw a specified amount of Ether or to withdraw all Ether stored in the contract.

## Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/**
 * @title EtherWallet
 * @dev A simple smart contract acting as an Ether wallet with owner-exclusive withdrawal capabilities.
 */
contract EtherWallet {

    address payable public immutable owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    event EtherReceived(address indexed sender, uint amount, uint timestamp);
    event FallbackCalled(address indexed sender, uint amount, bytes data, uint timestamp);
    event EtherWithdrawn(address indexed to, uint amount, uint timestamp);

    /**
     * @dev Returns the balance of Ether stored in the contract.
     */
    function getWalletBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws a specified amount of Ether from the contract to a specified address.
     * Can only be called by the contract owner.
     * @param _amount The amount of Ether to withdraw.
     * @param _to The address to which the funds are sent.
     */
    function withdrawFunds(uint256 _amount, address payable _to) external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        require(_amount <= address(this).balance, "Insufficient funds");

        emit EtherWithdrawn(_to, _amount, block.timestamp);
        _to.transfer(_amount);
    }

    /**
     * @dev Withdraws all the Ether available in the contract to a specific address.
     * Can only be called by the contract owner.
     * @param _to The address to which all funds are sent.
     */
    function withdrawAll(address payable _to) external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        
        uint256 totalAmount = address(this).balance;

        emit EtherWithdrawn(_to, totalAmount, block.timestamp);
        _to.transfer(totalAmount);
    }

    /**
     * @dev Receives Ether when sent to the contract.
     */
    receive() external payable {
        emit EtherReceived(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @dev Fallback function to handle other calls.
     */
    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, msg.data, block.timestamp);
    }
}
```

## Getting Started

### Prerequisites

To interact with this contract, you need:

- An Ethereum wallet like [MetaMask](https://metamask.io/) or any other Ethereum-compatible wallet.
- Ether for transactions on the Ethereum network.

### Deployment

1. Deploy the contract to an Ethereum-compatible network using tools like [Remix](https://remix.ethereum.org/), [Hardhat](https://hardhat.org/), or [Truffle](https://www.trufflesuite.com/).

### Interacting with the Contract

You can interact with the deployed contract through Ethereum wallets or directly via Ethereum JSON-RPC calls.

### Security Considerations

- **Owner-exclusive Access**: Ensures that only the contract owner can withdraw Ether stored in the contract.
- **Event Logging**: Provides transparency by logging every Ether transaction on-chain.
- **Gas Efficiency**: Functions are optimized for gas usage, ensuring cost-effective transactions.

### License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

### Acknowledgements

- Inspired by the need for a simple and secure Ethereum wallet contract.
- Built with the guidance of best practices from the Ethereum development community.
