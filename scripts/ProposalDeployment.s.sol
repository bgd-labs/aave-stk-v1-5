// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {GovHelpers, AaveGovernanceV2} from 'aave-helpers/GovHelpers.sol';

// Creates Proposal for Stk Short Executor Payload (stkabpt)
contract StkABPTShortProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      address(0) // deployed short executor payload
    );
    vm.startBroadcast();
    GovHelpers.createProposal(payloads, bytes32(''));
    vm.stopBroadcast();
  }
}

// Creates Proposal for Rescue Long Executor Payload
contract StkAAVELongProposal is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      address(0) // deployed rescue long executor payload
    );
    vm.startBroadcast();
    GovHelpers.createProposal(
      AaveGovernanceV2.LONG_EXECUTOR,
      payloads,
      bytes32('')
    );
    vm.stopBroadcast();
  }
}
