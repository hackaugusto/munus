// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Munus {
    mapping(bytes32 => bool) public secrets;

    error HashAlreadyUsed();
    error TransferFailed();
    error InvalidAmount();

    event DonationReceived(address receiver, bytes32 hash, uint amount);

    function trampoline(bytes32 hash, address payable payout) public payable {
        // A hash can be used only once. This assumes hash collision resistance.
        if (secrets[hash]) { revert HashAlreadyUsed(); }
        secrets[hash] = true;

        if (msg.value != 1e15 && msg.value != 1e16 && msg.value != 1e17) {
            revert InvalidAmount();
        }

        // Forward all the tokens to the final address
        (bool result, ) = payout.call{value: msg.value}("");

        if (!result) { revert TransferFailed(); }

        emit DonationReceived(payout, hash, msg.value);
    }
}
