// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";

contract AttackerPuppet {
    function transfer (
        address token,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        ERC20(token).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,
            r,
            s
        );
    }

    function recover (
        address token,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external view returns (address) {
        bytes32 domain = ERC20(token).DOMAIN_SEPARATOR();
        uint nonce = ERC20(token).nonces(msg.sender);
        return ecrecover(
            keccak256(
                abi.encodePacked(
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
                )
            ),
            v,
            r,
            s
        );
    }

    function message (
        address token,
        uint256 value,
        uint256 deadline
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

    function messageHash (
        address token,
        uint256 value,
        uint256 deadline
    ) external view returns (bytes32) {
        bytes32 domain = ERC20(token).DOMAIN_SEPARATOR();
        uint nonce = ERC20(token).nonces(msg.sender);
        return keccak256(
            abi.encodePacked(
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
            )
        );
    }

    function recover2(
        bytes32 _hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external pure returns (address) {
        return ecrecover(_hash, v, r, s);
    }
}
