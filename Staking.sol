// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Staking {

    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public rewardRate; // reward per second

    mapping(address => uint256) public balances;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastUpdateTime;

    constructor(address _stakingToken, address _rewardToken, uint256 _rewardRate) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        rewardRate = _rewardRate;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        updateReward(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), amount);

        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balances[msg.sender] >= amount, "Not enough balance");

        updateReward(msg.sender);

        balances[msg.sender] -= amount;

        stakingToken.transfer(msg.sender, amount);
    }

    function claimReward() external {

        updateReward(msg.sender);

        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;

        rewardToken.transfer(msg.sender, reward);
    }

    function updateReward(address account) internal {

        rewards[account] = earned(account);
        lastUpdateTime[account] = block.timestamp;
    }

    function earned(address account) public view returns (uint256) {

        uint256 stakingBalance = balances[account];
        uint256 timeDiff = block.timestamp - lastUpdateTime[account];

        return rewards[account] + ((stakingBalance * rewardRate * timeDiff) / 1e18);
    }
}
