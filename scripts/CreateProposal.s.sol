// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {GovHelpers, AaveGovernanceV2} from 'aave-helpers/GovHelpers.sol';
import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';

// Creates Proposal for Rescue Long Executor Payload
contract CreateStkAAVELongProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      0xe427FCbD54169136391cfEDf68E96abB13dA87A0
    );
    GovHelpers.createProposal(
      AaveGovernanceV2.LONG_EXECUTOR,
      payloads,
      0x2cd70a0e597bd593fa99a99f03a19d58fd834ef6c946ce14f0c330a85588eb00 // part 1 payload
    );
  }
}

// Creates Proposal for Stk Short Executor Payload (stkabpt)
contract CreateStkABPTShortProposal is EthereumScript {
  function run() external broadcast {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](1);
    payloads[0] = GovHelpers.buildMainnet(
      0xe63eAf6DAb1045689BD3a332bC596FfcF54A5C88
    );
    GovHelpers.createProposal(
      payloads,
      0xf8037b75b56dfc92c4ccd9e4d6202ffdefbfb8b28c5565efca8da3bfb1d8ad79 // part 2 payload
    );
  }
}
