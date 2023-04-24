// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";

contract AttackerPuppet {
    function getMessage(
        address token,
        uint value,
        uint deadline
    ) external view returns (bytes memory) {
        bytes32 domain = ERC20(token).DOMAIN_SEPARATOR();
        uint nonce = ERC20(token).nonces(msg.sender);
        return abi.encodePacked(
            "\x19\x01",
            domain,
            keccak256(
                abi.encode(
                    keccak256(
                        "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                    ),
                    msg.sender,
                    address(this),
                    value,
                    nonce,
                    deadline
                )
            )
        );
    }

    function recover(
        bytes32 message,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external pure returns (address) {
        return ecrecover(message, v, r, s);
    }
}