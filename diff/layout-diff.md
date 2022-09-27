```diff --git a/diff/layout_current.json b/diff/layout_next.json
index f963ddf..042661e 100644
--- a/diff/layout_current.json
+++ b/diff/layout_next.json
@@ -1,164 +1,212 @@
 {
   "storage": [
     {
-      "astId": 447,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9623,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_balances",
       "offset": 0,
       "slot": "0",
       "type": "t_mapping(t_address,t_uint256)"
     },
     {
-      "astId": 453,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9629,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_allowances",
       "offset": 0,
       "slot": "1",
       "type": "t_mapping(t_address,t_mapping(t_address,t_uint256))"
     },
     {
-      "astId": 455,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9631,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_totalSupply",
       "offset": 0,
       "slot": "2",
       "type": "t_uint256"
     },
     {
-      "astId": 457,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9633,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_name",
       "offset": 0,
       "slot": "3",
       "type": "t_string_storage"
     },
     {
-      "astId": 459,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9635,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_symbol",
       "offset": 0,
       "slot": "4",
       "type": "t_string_storage"
     },
     {
-      "astId": 461,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 9637,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_decimals",
       "offset": 0,
       "slot": "5",
       "type": "t_uint8"
     },
     {
-      "astId": 2396,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 10909,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_votingSnapshots",
       "offset": 0,
       "slot": "6",
-      "type": "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)1726_storage))"
+      "type": "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)10222_storage))"
     },
     {
-      "astId": 2400,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 10913,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_votingSnapshotsCounts",
       "offset": 0,
       "slot": "7",
       "type": "t_mapping(t_address,t_uint256)"
     },
     {
-      "astId": 2403,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 10917,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_aaveGovernance",
       "offset": 0,
       "slot": "8",
-      "type": "t_contract(ITransferHook)968"
+      "type": "t_contract(ITransferHook)9272"
     },
     {
-      "astId": 1137,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 11470,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "lastInitializedRevision",
       "offset": 0,
       "slot": "9",
       "type": "t_uint256"
     },
     {
-      "astId": 1168,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 11501,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "______gap",
       "offset": 0,
       "slot": "10",
       "type": "t_array(t_uint256)50_storage"
     },
     {
-      "astId": 1204,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 31,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "assets",
       "offset": 0,
       "slot": "60",
-      "type": "t_mapping(t_address,t_struct(AssetData)1193_storage)"
+      "type": "t_mapping(t_address,t_struct(AssetData)19_storage)"
     },
     {
-      "astId": 2449,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 669,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "stakerRewardsToClaim",
       "offset": 0,
       "slot": "61",
       "type": "t_mapping(t_address,t_uint256)"
     },
     {
-      "astId": 2453,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 673,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "stakersCooldowns",
       "offset": 0,
       "slot": "62",
       "type": "t_mapping(t_address,t_uint256)"
     },
     {
-      "astId": 2458,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 678,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_votingDelegates",
       "offset": 0,
       "slot": "63",
       "type": "t_mapping(t_address,t_address)"
     },
     {
-      "astId": 2464,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 685,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_propositionPowerSnapshots",
       "offset": 0,
       "slot": "64",
-      "type": "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)1726_storage))"
+      "type": "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)10222_storage))"
     },
     {
-      "astId": 2468,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 689,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_propositionPowerSnapshotsCounts",
       "offset": 0,
       "slot": "65",
       "type": "t_mapping(t_address,t_uint256)"
     },
     {
-      "astId": 2472,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 693,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_propositionPowerDelegates",
       "offset": 0,
       "slot": "66",
       "type": "t_mapping(t_address,t_address)"
     },
     {
-      "astId": 2474,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 695,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "DOMAIN_SEPARATOR",
       "offset": 0,
       "slot": "67",
       "type": "t_bytes32"
     },
     {
-      "astId": 2495,
-      "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+      "astId": 716,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
       "label": "_nonces",
       "offset": 0,
       "slot": "68",
       "type": "t_mapping(t_address,t_uint256)"
+    },
+    {
+      "astId": 11268,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "_admins",
+      "offset": 0,
+      "slot": "69",
+      "type": "t_mapping(t_uint256,t_address)"
+    },
+    {
+      "astId": 11272,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "_pendingAdmins",
+      "offset": 0,
+      "slot": "70",
+      "type": "t_mapping(t_uint256,t_address)"
+    },
+    {
+      "astId": 1900,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "duration",
+      "offset": 0,
+      "slot": "71",
+      "type": "t_struct(Duration)1897_storage"
+    },
+    {
+      "astId": 1927,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "_maxSlashablePercentage",
+      "offset": 0,
+      "slot": "72",
+      "type": "t_uint256"
+    },
+    {
+      "astId": 1930,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "_lastSlashing",
+      "offset": 0,
+      "slot": "73",
+      "type": "t_uint256"
+    },
+    {
+      "astId": 1932,
+      "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+      "label": "_cooldownPaused",
+      "offset": 0,
+      "slot": "74",
+      "type": "t_bool"
     }
   ],
   "types": {
@@ -173,12 +221,17 @@
       "label": "uint256[50]",
       "numberOfBytes": "1600"
     },
+    "t_bool": {
+      "encoding": "inplace",
+      "label": "bool",
+      "numberOfBytes": "1"
+    },
     "t_bytes32": {
       "encoding": "inplace",
       "label": "bytes32",
       "numberOfBytes": "32"
     },
-    "t_contract(ITransferHook)968": {
+    "t_contract(ITransferHook)9272": {
       "encoding": "inplace",
       "label": "contract ITransferHook",
       "numberOfBytes": "20"
@@ -197,19 +250,19 @@
       "numberOfBytes": "32",
       "value": "t_mapping(t_address,t_uint256)"
     },
-    "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)1726_storage))": {
+    "t_mapping(t_address,t_mapping(t_uint256,t_struct(Snapshot)10222_storage))": {
       "encoding": "mapping",
       "key": "t_address",
       "label": "mapping(address => mapping(uint256 => struct GovernancePowerDelegationERC20.Snapshot))",
       "numberOfBytes": "32",
-      "value": "t_mapping(t_uint256,t_struct(Snapshot)1726_storage)"
+      "value": "t_mapping(t_uint256,t_struct(Snapshot)10222_storage)"
     },
-    "t_mapping(t_address,t_struct(AssetData)1193_storage)": {
+    "t_mapping(t_address,t_struct(AssetData)19_storage)": {
       "encoding": "mapping",
       "key": "t_address",
       "label": "mapping(address => struct AaveDistributionManager.AssetData)",
       "numberOfBytes": "32",
-      "value": "t_struct(AssetData)1193_storage"
+      "value": "t_struct(AssetData)19_storage"
     },
     "t_mapping(t_address,t_uint256)": {
       "encoding": "mapping",
@@ -218,49 +271,56 @@
       "numberOfBytes": "32",
       "value": "t_uint256"
     },
-    "t_mapping(t_uint256,t_struct(Snapshot)1726_storage)": {
+    "t_mapping(t_uint256,t_address)": {
+      "encoding": "mapping",
+      "key": "t_uint256",
+      "label": "mapping(uint256 => address)",
+      "numberOfBytes": "32",
+      "value": "t_address"
+    },
+    "t_mapping(t_uint256,t_struct(Snapshot)10222_storage)": {
       "encoding": "mapping",
       "key": "t_uint256",
       "label": "mapping(uint256 => struct GovernancePowerDelegationERC20.Snapshot)",
       "numberOfBytes": "32",
-      "value": "t_struct(Snapshot)1726_storage"
+      "value": "t_struct(Snapshot)10222_storage"
     },
     "t_string_storage": {
       "encoding": "bytes",
       "label": "string",
       "numberOfBytes": "32"
     },
-    "t_struct(AssetData)1193_storage": {
+    "t_struct(AssetData)19_storage": {
       "encoding": "inplace",
       "label": "struct AaveDistributionManager.AssetData",
       "members": [
         {
-          "astId": 1184,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 10,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "emissionPerSecond",
           "offset": 0,
           "slot": "0",
           "type": "t_uint128"
         },
         {
-          "astId": 1186,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 12,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "lastUpdateTimestamp",
           "offset": 16,
           "slot": "0",
           "type": "t_uint128"
         },
         {
-          "astId": 1188,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 14,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "index",
           "offset": 0,
           "slot": "1",
           "type": "t_uint256"
         },
         {
-          "astId": 1192,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 18,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "users",
           "offset": 0,
           "slot": "2",
@@ -269,21 +329,44 @@
       ],
       "numberOfBytes": "96"
     },
-    "t_struct(Snapshot)1726_storage": {
+    "t_struct(Duration)1897_storage": {
+      "encoding": "inplace",
+      "label": "struct StakedTokenV3.Duration",
+      "members": [
+        {
+          "astId": 1894,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+          "label": "cooldownSeconds",
+          "offset": 0,
+          "slot": "0",
+          "type": "t_uint40"
+        },
+        {
+          "astId": 1896,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
+          "label": "slashingExitWindowSeconds",
+          "offset": 5,
+          "slot": "0",
+          "type": "t_uint40"
+        }
+      ],
+      "numberOfBytes": "32"
+    },
+    "t_struct(Snapshot)10222_storage": {
       "encoding": "inplace",
       "label": "struct GovernancePowerDelegationERC20.Snapshot",
       "members": [
         {
-          "astId": 1723,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 10219,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "blockNumber",
           "offset": 0,
           "slot": "0",
           "type": "t_uint128"
         },
         {
-          "astId": 1725,
-          "contract": "src/flattened/StakedTokenV2Rev3.sol:StakedTokenV2Rev3",
+          "astId": 10221,
+          "contract": "src/contracts/StakedAaveV3.sol:StakedAaveV3",
           "label": "value",
           "offset": 16,
           "slot": "0",
@@ -302,6 +385,11 @@
       "label": "uint256",
       "numberOfBytes": "32"
     },
+    "t_uint40": {
+      "encoding": "inplace",
+      "label": "uint40",
+      "numberOfBytes": "5"
+    },
     "t_uint8": {
       "encoding": "inplace",
       "label": "uint8",
