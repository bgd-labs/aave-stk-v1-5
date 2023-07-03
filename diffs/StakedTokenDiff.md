```diff
diff --git a/src/flattened/CurrentStakedTokenV3Flattened.sol b/src/flattened/StakedTokenV3Flattened.sol
index 6b21e42..0d0aa40 100644
--- a/src/flattened/CurrentStakedTokenV3Flattened.sol
+++ b/src/flattened/StakedTokenV3Flattened.sol
@@ -2149,6 +2149,24 @@ interface IStakedTokenV3 is IStakedTokenV2 {
     uint256 claimAmount,
     uint256 redeemAmount
   ) external;
+
+  /**
+   * @dev Allows staking a certain amount of STAKED_TOKEN with gasless approvals (permit)
+   * @param from The address staking the token
+   * @param amount The amount to be staked
+   * @param deadline The permit execution deadline
+   * @param v The v component of the signed message
+   * @param r The r component of the signed message
+   * @param s The s component of the signed message
+   */
+  function stakeWithPermit(
+    address from,
+    uint256 amount,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external;
 }
 
 /**
@@ -3516,6 +3534,18 @@ library SafeCast {
   }
 }
 
+interface IERC20WithPermit is IERC20 {
+  function permit(
+    address owner,
+    address spender,
+    uint256 value,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external;
+}
+
 /**
  * @title StakedTokenV3
  * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
@@ -3604,7 +3634,7 @@ contract StakedTokenV3 is
    * @return The revision
    */
   function REVISION() public pure virtual returns (uint256) {
-    return 3;
+    return 4;
   }
 
   /**
@@ -3845,6 +3875,27 @@ contract StakedTokenV3 is
     return _cooldownSeconds;
   }
 
+  /// @inheritdoc IStakedTokenV3
+  function stakeWithPermit(
+    address from,
+    uint256 amount,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external override {
+    IERC20WithPermit(address(STAKED_TOKEN)).permit(
+      from,
+      address(this),
+      amount,
+      deadline,
+      v,
+      r,
+      s
+    );
+    _stake(from, from, amount);
+  }
+
   /**
    * @dev sets the max slashable percentage
    * @param percentage must be strictly lower 100% as otherwise the exchange rate calculation would result in 0 division
@@ -4058,7 +4109,7 @@ contract StakedTokenV3 is
         if (balanceOfFrom == amount) {
           delete stakersCooldowns[from];
         } else if (balanceOfFrom - amount < previousSenderCooldown.amount) {
-          stakersCooldowns[from].amount = uint184(balanceOfFrom - amount);
+          stakersCooldowns[from].amount = uint216(balanceOfFrom - amount);
         }
       }
     }
```
