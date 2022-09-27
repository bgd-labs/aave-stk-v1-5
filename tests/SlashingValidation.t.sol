import 'forge-std/Test.sol';
import {GovHelpers, IAaveGov} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';

contract SlashingValidation is Test {
  StakedTokenV3 constant STK_ABPT =
    StakedTokenV3(0xa1116930326D21fB917d5A27F1E9943A9595fb47);
  address private poolV2;

  uint256 constant SLASHING_ADMIN = 0;
  uint256 constant COOLDOWN_ADMIN = 1;
  uint256 constant CLAIM_HELPER_ROLE = 2;

  address slashingAdmin = address(4);
  address cooldownAdmin = address(5);
  address claimHelper = address(6);

  function _deployImplementation() internal returns (address) {
    return
      address(
        new StakedTokenV3(
          STK_ABPT.STAKED_TOKEN(),
          STK_ABPT.REWARD_TOKEN(),
          172800,
          1000,
          STK_ABPT.REWARDS_VAULT(),
          STK_ABPT.EMISSION_MANAGER(),
          3155692600, // 100 years
          STK_ABPT.name(),
          STK_ABPT.symbol(),
          address(GovHelpers.GOV)
        )
      );
  }

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15573889);
    address stkABPTImpl = _deployImplementation();
    vm.startPrank(GovHelpers.LONG_EXECUTOR);
    IInitializableAdminUpgradeabilityProxy stkABPTProxy = IInitializableAdminUpgradeabilityProxy(
        address(STK_ABPT)
      );
    stkABPTProxy.upgradeToAndCall(
      stkABPTImpl,
      abi.encodeWithSignature(
        'initialize(address,address,address,uint256,uint40,uint40)',
        slashingAdmin,
        cooldownAdmin,
        claimHelper,
        3000,
        864000,
        172800
      )
    );
    vm.stopPrank();
    deal(address(STK_ABPT.STAKED_TOKEN()), address(this), 10 ether);
  }

  function testInitializer() public {
    assertEq(STK_ABPT.getAdmin(SLASHING_ADMIN), slashingAdmin);
    assertEq(STK_ABPT.getAdmin(COOLDOWN_ADMIN), cooldownAdmin);
    assertEq(STK_ABPT.getAdmin(CLAIM_HELPER_ROLE), claimHelper);
    assertEq(STK_ABPT.getCooldownSeconds() != 0, true);
  }

  /**
   * @dev Reverts trying to stake 0 amount
   */
  function testFailStakeZero() public {
    uint256 amount = 0;
    STK_ABPT.stake(address(this), amount);
  }

  /**
   * @dev User stakes 10 ABPT: receives 10 stkABPT, StakedAave balance of ABPT is 10 and his rewards to claim are 0
   */
  function testStakeClaimZero() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    assertEq(STK_ABPT.balanceOf(address(this)), amount);
    assertEq(
      STK_ABPT.STAKED_TOKEN().balanceOf(address(STK_ABPT)),
      totalBalanceBefore + amount
    );
    assertEq(STK_ABPT.getTotalRewardsBalance(address(this)), 0);
  }

  /**
   * @dev User 1 claim half rewards
   */
  function testClaimHalf() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STK_ABPT.getTotalRewardsBalance(address(this));
    uint256 halfClaim = balanceToClaim / 2;
    STK_ABPT.claimRewards(address(this), halfClaim);
    assertEq(STK_ABPT.REWARD_TOKEN().balanceOf(address(this)), halfClaim);
    assertEq(
      STK_ABPT.getTotalRewardsBalance(address(this)),
      balanceToClaim - halfClaim
    );
  }

  /**
   * @dev User 1 claim more
   */
  function testClaimMore() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STK_ABPT.getTotalRewardsBalance(address(this));
    STK_ABPT.claimRewards(address(this), balanceToClaim * 2);
    assertEq(STK_ABPT.REWARD_TOKEN().balanceOf(address(this)), balanceToClaim);
    assertEq(STK_ABPT.getTotalRewardsBalance(address(this)), 0);
  }

  /**
   * @dev User 1 claim all
   */
  function testClaimAll() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    vm.warp(block.timestamp + 60 * 60 * 24 * 100);

    uint256 balanceToClaim = STK_ABPT.getTotalRewardsBalance(address(this));
    STK_ABPT.claimRewards(address(this), balanceToClaim);
    assertEq(STK_ABPT.REWARD_TOKEN().balanceOf(address(this)), balanceToClaim);
    assertEq(STK_ABPT.getTotalRewardsBalance(address(this)), 0);
  }

  /**
   * @dev Verifies that the initial exchange rate is 1:1
   */
  function testExchangeRate1To1() public {
    assertEq(STK_ABPT.exchangeRate(), 1 ether);
  }

  /**
   * @dev Verifies that after a deposit the initial exchange rate is still 1:1
   */
  function testEchangeRateStill1To1() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    assertEq(STK_ABPT.exchangeRate(), 1 ether);
  }

  function _slash20() internal {
    address receiver = address(42);
    uint256 amountToSlash = (STK_ABPT.totalSupply() * 2) / 10;

    // slash
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.slash(receiver, amountToSlash);
    vm.stopPrank();
  }

  function testSlashExchangeRate() internal {
    address receiver = address(42);
    uint256 amountToSlash = (STK_ABPT.totalSupply() * 2) / 10;

    // slash
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.slash(receiver, amountToSlash);
    vm.stopPrank();

    assertEq(STK_ABPT.STAKED_TOKEN().balanceOf(receiver), amountToSlash);
    assertEq(STK_ABPT.exchangeRate(), 0.8 ether);
  }

  /**
   * @dev Executes a slash of 20% of the asset and redeem
   */
  function testSlash20Redeem() public {
    uint256 amount = 10 ether;

    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    _slash20();
    // redeem
    STK_ABPT.redeem(address(this), amount);
    assertEq(STK_ABPT.STAKED_TOKEN().balanceOf(address(this)), 8 ether);
  }

  /**
   * @dev Executes a slash of 20% of the asset and redeem
   */
  function testFailSlash20RedeemToLate() public {
    uint256 amount = 10 ether;

    uint256 totalBalanceBefore = STK_ABPT.STAKED_TOKEN().balanceOf(
      address(STK_ABPT)
    );
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);

    _slash20();
    vm.warp(STK_ABPT.getSlashingExitWindowSeconds() + block.timestamp + 1);
    STK_ABPT.redeem(address(this), amount);
    assertEq(STK_ABPT.STAKED_TOKEN().balanceOf(address(this)), 8 ether);
  }

  /**
   * @dev Stakes 1 more after 20% slash - expected to receive 1.25 stkAAVE
   */
  function testSlash20Stake() public {
    _slash20();
    uint256 amount = 1 ether;
    STK_ABPT.STAKED_TOKEN().approve(address(STK_ABPT), amount);
    STK_ABPT.stake(address(this), amount);
    assertEq(STK_ABPT.balanceOf(address(this)), 1.25 ether);
  }

  function testSlashTwice() public {
    _slash20();
    _slash20();
  }

  /**
   * @dev Tries to slash with an account that is not the slashing admin
   */
  function testFailSlash() public {
    address receiver = address(42);
    uint256 amountToSlash = (STK_ABPT.totalSupply() * 2) / 10;

    // slash
    STK_ABPT.slash(receiver, amountToSlash);
  }

  /**
   * @dev Tries to change the slash admin not being the slash admin
   */
  function testFailChangeSlashAdmin() public {
    address newAdmin = address(42);

    STK_ABPT.setPendingAdmin(SLASHING_ADMIN, newAdmin);
  }

  /**
   * @dev Tries to change the cooldown admin not being the cooldown admin
   */
  function testFailChangeCooldownAdmin() public {
    address newAdmin = address(42);

    STK_ABPT.setPendingAdmin(COOLDOWN_ADMIN, newAdmin);
  }

  /**
   * @dev Changes the pending slashing admin
   */
  function testChangeSlashAdmin() public {
    address newAdmin = address(42);

    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.setPendingAdmin(SLASHING_ADMIN, newAdmin);
    vm.stopPrank();

    assertEq(STK_ABPT.getPendingAdmin(SLASHING_ADMIN), newAdmin);
  }

  /**
   * @dev Tries to claim the pending slashing admin not being the pending admin
   */
  function testFailClaimSlashAdmin() public {
    STK_ABPT.claimRoleAdmin(SLASHING_ADMIN);
  }

  /**
   * @dev Claim the slashing admin role
   */
  function testClaimSlashAdmin() public {
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.setPendingAdmin(SLASHING_ADMIN, address(this));
    vm.stopPrank();
    STK_ABPT.claimRoleAdmin(SLASHING_ADMIN);

    assertEq(STK_ABPT.getAdmin(SLASHING_ADMIN), address(this));
  }

  function testFailChangeMaxSlashingNoAdmin() public {
    STK_ABPT.setMaxSlashablePercentage(1000);
  }

  function testFailChangeMaxSlashingToHigh() public {
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.setMaxSlashablePercentage(10001);
  }

  function testChangeMaxSlashing() public {
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.setMaxSlashablePercentage(1000);
    assertEq(STK_ABPT.getMaxSlashablePercentage(), 1000);
  }

  function testFailSlashMoreThanMax() public {
    address receiver = address(42);
    uint256 amountToSlash = (STK_ABPT.totalSupply() * 4) / 10;

    // slash
    vm.startPrank(STK_ABPT.getAdmin(SLASHING_ADMIN));
    STK_ABPT.slash(receiver, amountToSlash);
    vm.stopPrank();
  }
}
