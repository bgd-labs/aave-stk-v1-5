import 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {StakedTokenV3} from '../src/contracts/StakedTokenV3.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';

contract BaseTest is Test {
  StakedTokenV3 STAKE_CONTRACT;

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
          STAKE_CONTRACT.STAKED_TOKEN(),
          STAKE_CONTRACT.REWARD_TOKEN(),
          172800,
          3000,
          STAKE_CONTRACT.REWARDS_VAULT(),
          STAKE_CONTRACT.EMISSION_MANAGER(),
          3155692600, // 100 years
          STAKE_CONTRACT.name(),
          STAKE_CONTRACT.symbol(),
          address(GovHelpers.GOV)
        )
      );
  }

  function _setUp(address stake, address admin) internal {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15896416);
    STAKE_CONTRACT = StakedTokenV3(stake);
    address stkImpl = _deployImplementation();
    vm.startPrank(admin);
    IInitializableAdminUpgradeabilityProxy stkProxy = IInitializableAdminUpgradeabilityProxy(
        address(STAKE_CONTRACT)
      );
    stkProxy.upgradeToAndCall(
      stkImpl,
      abi.encodeWithSignature(
        'initialize(address,address,address,uint256,uint40)',
        slashingAdmin,
        cooldownAdmin,
        claimHelper,
        3000,
        864000
      )
    );
    vm.stopPrank();
    deal(address(STAKE_CONTRACT.STAKED_TOKEN()), address(this), 10 ether);
  }
}
