```diff
diff --git a/src/flattened/CurrentStakedTokenV3Flattened.sol b/src/flattened/StakedTokenV3Flattened.sol
index 6b21e42..1dd69f7 100644
--- a/src/flattened/CurrentStakedTokenV3Flattened.sol
+++ b/src/flattened/StakedTokenV3Flattened.sol
@@ -3604,7 +3604,7 @@ contract StakedTokenV3 is
    * @return The revision
    */
   function REVISION() public pure virtual returns (uint256) {
-    return 3;
+    return 4;
   }
 
   /**
@@ -3618,20 +3618,8 @@ contract StakedTokenV3 is
   /**
    * @dev Called by the proxy contract
    */
-  function initialize(
-    address slashingAdmin,
-    address cooldownPauseAdmin,
-    address claimHelper,
-    uint256 maxSlashablePercentage,
-    uint256 cooldownSeconds
-  ) external virtual initializer {
-    _initialize(
-      slashingAdmin,
-      cooldownPauseAdmin,
-      claimHelper,
-      maxSlashablePercentage,
-      cooldownSeconds
-    );
+  function initialize() external virtual initializer {
+    inPostSlashingPeriod = true;
   }
 
   function _initialize(
@@ -3973,7 +3961,7 @@ contract StakedTokenV3 is
     CooldownSnapshot memory cooldownSnapshot = stakersCooldowns[from];
     if (!inPostSlashingPeriod) {
       require(
-        (block.timestamp > cooldownSnapshot.timestamp + _cooldownSeconds),
+        (block.timestamp >= cooldownSnapshot.timestamp + _cooldownSeconds),
         'INSUFFICIENT_COOLDOWN'
       );
       require(
@@ -4058,7 +4046,7 @@ contract StakedTokenV3 is
         if (balanceOfFrom == amount) {
           delete stakersCooldowns[from];
         } else if (balanceOfFrom - amount < previousSenderCooldown.amount) {
-          stakersCooldowns[from].amount = uint184(balanceOfFrom - amount);
+          stakersCooldowns[from].amount = uint216(balanceOfFrom - amount);
         }
       }
     }
```
