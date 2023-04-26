// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {GovHelpers, AaveGovernanceV2} from 'aave-helpers/GovHelpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';

// Creates Proposal for Stk Short Executor Payload (stkabpt)
contract StkABPTShortProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      address(0) // deployed short executor payload
    );
    GovHelpers.createProposal(
      payloads,
      0xf8037b75b56dfc92c4ccd9e4d6202ffdefbfb8b28c5565efca8da3bfb1d8ad79
    );
  }
}

// Creates Proposal for Rescue Long Executor Payload
contract StkAAVELongProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      address(0) // deployed rescue long executor payload
    );
    GovHelpers.createProposal(
      AaveGovernanceV2.LONG_EXECUTOR,
      payloads,
      0x2cd70a0e597bd593fa99a99f03a19d58fd834ef6c946ce14f0c330a85588eb00
    );
  }
}
