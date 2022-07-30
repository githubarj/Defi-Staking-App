// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

// stake: people to lock tokens into our smart contract
// waithdraw: unlock tokens and pull out of the contract
// claim reward: users get their reward tokens
//  what is a good reward mechanism

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//error codes
error Staking__transferFailed();

contract Staking {
    IERC20 public s_stakingToken;
    uint256 public constant REWARD_RATE = 100;
    uint256 public s_totalSupply;
    uint256 public s_rewardTokenPerTokenStored;
    uint256 public s_lastUpdateTime;

    //mapping someone's address to how much they have staked
    mapping(address => uint256) public s_balances;
    
    modifier updateReward (address account) {
        // how mcu the reward per token is
        // last timestamp
        // 12 - 1 user earned tokens

        s_rewardTokenPerTokenStored = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
        s_rewards[account] = earned(account);
        _;
    }


    //the staking token
    constructor(address stakingToken) {
        s_stakingToken = IERC20(stakingToken);
    }

    function earned(address account) public view returns (uint256) {
        uint256 currentBalance = s_balances[account];
    }

    function rewardPerToken() public view returns (uint256) {
        if (s_totalSupply == 0){
            return s_rewardTokenPerTokenStored;
        }
        return s_rewardTokenPerTokenStored + (((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18)/s_totalSupply);
    }

    //just one ERC20 token
    function stake(uint256 amount) external {
        // keep track of how much user has staked
        //keep track of how much token we have in total
        // transfer tokens to this contract

        s_balances[msg.sender] = s_balances[msg.sender] + amount;
        s_totalSupply = s_totalSupply + amount;

        //emit event
        //transfer = addrsss from, address to , amount
        bool success = s_stakingToken.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        //require (success, "Failed");
        // revert to error if transaction fails
        if (!success) {
            revert Staking__transferFailed();
        }
    }

    function withraw(uint256 amount) external {
        s_balances[msg.sender] = s_balances[msg.sender] - amount;
        s_totalSupply = s_totalSupply + amount;
        bool success = s_stakingToken.transfer(msg.sender, amount);
        if( !success){
            revert Staking__transferFailed();
        }

    }

    function claimReward() external {
        // how much rewards do they get ?
        // the contract will emit x token per second 
        // and disperse them to al token holders

        
    }
}
