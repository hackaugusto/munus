// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Munus {
    mapping(bytes32 => bool) public secrets;

    error SecretAlreadyUsed();
    error TransferFailed();

    event DonationReceived(address receiver, bytes32 hash);

    function trampoline(bytes32 hash, address payable payout) public payable {
        // A hash can be used only once. This assumes hash collision resistance.
        if (secrets[hash]) { revert SecretAlreadyUsed(); }
        secrets[hash] = true;

        // Forward all the tokens to the final address
        (bool result, ) = payout.call{value: msg.value}("");

        if (!result) { revert TransferFailed(); }

        emit DonationReceived(payout, hash);
    }
}
