// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.1;


contract GhoVariableDebt_Mock {
    function updateDiscountDistribution(
        address sender,
        address recipient,
        uint256 senderDiscountTokenBalance,
        uint256 recipientDiscountTokenBalance,
        uint256 amount
    ) external {
        return;
    }
}