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
    event EtherWithdrawn(address indexed to, uint amount, uint timestamp);

    /**
     * @dev Returns the balance of Ether stored in the contract.
     */
    function getWalletBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Withdraws a specified amount of Ether from the contract to a specified address
     * Can only be called by the contract owner.
     * @param _amount The amount of Ether to withdraw.
     * @param _to The address to which the funds are sent
     */
    function withdrawFunds(uint256 _amount, address payable _to) external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        require(_amount <= address(this).balance, "Insufficient funds");

        emit EtherWithdrawn(owner, _amount, block.timestamp);
        _to.transfer(_amount);
    }

    /**
     * @dev Withdraws all the Ether available in the contract to a specific address
     * Can only be called by the contract owner.
     * @param _to the address to
     */
    function withdrawAll(address payable _to) external{
        require(msg.sender == owner, "Only the contract owner can withdraw funds");
        
        uint256 totalAmount = address(this).balance;

        emit EtherWithdrawn(msg.sender, totalAmount, block.timestamp);
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