# EtherWallet Smart Contract

A simple and secure Ether wallet smart contract that allows the contract deployer to receive, store, and withdraw Ether. The contract is designed to ensure that only the owner can withdraw funds, and it includes basic protections against common security vulnerabilities.

## Features

- **Owner-only Withdrawals**: Only the contract owner can withdraw funds from the contract.
- **Receive and Store Ether**: The contract can receive and store Ether.
- **Event Logging**: Logs important actions like deposits, withdrawals, and fallback calls for transparency and easy tracking.

## Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/// @author 0x2V
/// @title EtherWallet

contract EtherWallet{

    address payable public immutable owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    event EtherReceived(address indexed sender, uint amount, uint timestamp);
    event FallbackCalled(address indexed sender, uint amount, bytes data, uint timestamp);
    event EtherWithdrawn(address indexed owner, uint amount, uint timestamp);

    /**
     * @dev Returns the balance of Ether stored in the contract.
     */
    function getWalletBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws a specified amount of Ether from the contract.
     * Can only be called by the contract owner.
     * @param _amount The amount of Ether to withdraw.
     */
    function withdrawFunds(uint256 _amount) external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        require(_amount <= address(this).balance, "Insufficient funds");

        emit EtherWithdrawn(owner, _amount, block.timestamp);
        owner.transfer(_amount);
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

To deploy and interact with this contract, you need:

- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [Hardhat](https://hardhat.org/) (for development and testing)
- [MetaMask](https://metamask.io/) (or any other Ethereum wallet)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/EtherWallet.git
   cd EtherWallet
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Compile the smart contract:
   ```bash
   npx hardhat compile
   ```

### Deployment

1. Configure your network settings in `hardhat.config.js`.
2. Deploy the contract:
   ```bash
   npx hardhat run scripts/deploy.js --network yournetwork
   ```

### Interacting with the Contract

You can interact with the contract using Hardhat scripts, or through a web interface like [Remix](https://remix.ethereum.org/) or a custom DApp.

## Security Considerations

### Reentrancy

While the use of `transfer` for Ether transfers in the `withdrawFunds` function provides some protection against reentrancy attacks by limiting gas, you may still consider implementing a reentrancy guard using OpenZeppelin's `ReentrancyGuard` if the contract logic becomes more complex.

### Other Vulnerabilities

- **Access Control**: Ensure that only the owner can call the `withdrawFunds` function. This is already enforced using the `require` statement.
- **Check-Effects-Interactions Pattern**: This pattern is followed in the `withdrawFunds` function to prevent reentrancy attacks.
- **Fallback Function**: The fallback function allows the contract to receive Ether and log the call. Ensure that it does not perform complex operations that could be exploited.
- **Immutable Variables**: Using the `immutable` keyword for the owner address ensures it cannot be changed after deployment, enhancing security.
- **Arithmetic Overflows and Underflows**: Solidity 0.8.x has built-in overflow and underflow checks, but always be cautious and review the code for potential edge cases.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request to contribute.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [OpenZeppelin](https://openzeppelin.com/) for their extensive library of secure smart contract templates.
- [Hardhat](https://hardhat.org/) for providing a robust development environment.
