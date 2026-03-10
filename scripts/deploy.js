const hre = require("hardhat");

async function main() {

  // địa chỉ token stake và reward
  const stakingToken = "0xYourStakingTokenAddress";
  const rewardToken = "0xYourRewardTokenAddress";

  // reward rate
  const rewardRate = hre.ethers.parseUnits("1", 18);

  const Staking = await hre.ethers.getContractFactory("Staking");

  const staking = await Staking.deploy(
    stakingToken,
    rewardToken,
    rewardRate
  );

  await staking.waitForDeployment();

  console.log("Staking deployed to:", await staking.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
