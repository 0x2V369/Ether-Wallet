//SPDX-License-Identifier: MIT
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