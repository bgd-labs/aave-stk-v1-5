```diff
diff --git a/src/flattened/CurrentStakedTokenV3Flattened.sol b/src/flattened/StakedTokenV3Flattened.sol
index 6b21e42..ae92352 100644
--- a/src/flattened/CurrentStakedTokenV3Flattened.sol
+++ b/src/flattened/StakedTokenV3Flattened.sol
@@ -84,6 +84,30 @@ interface IERC20 {
   ) external returns (bool);
 }
 
+// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
+
+/**
+ * @dev Interface for the optional metadata functions from the ERC20 standard.
+ *
+ * _Available since v4.1._
+ */
+interface IERC20Metadata is IERC20 {
+  /**
+   * @dev Returns the name of the token.
+   */
+  function name() external view returns (string memory);
+
+  /**
+   * @dev Returns the symbol of the token.
+   */
+  function symbol() external view returns (string memory);
+
+  /**
+   * @dev Returns the decimals places of the token.
+   */
+  function decimals() external view returns (uint8);
+}
+
 library DistributionTypes {
   struct AssetConfigInput {
     uint128 emissionPerSecond;
@@ -490,30 +514,6 @@ interface IAaveDistributionManager {
   ) external;
 }
 
-// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
-
-/**
- * @dev Interface for the optional metadata functions from the ERC20 standard.
- *
- * _Available since v4.1._
- */
-interface IERC20Metadata is IERC20 {
-  /**
-   * @dev Returns the name of the token.
-   */
-  function name() external view returns (string memory);
-
-  /**
-   * @dev Returns the symbol of the token.
-   */
-  function symbol() external view returns (string memory);
-
-  /**
-   * @dev Returns the decimals places of the token.
-   */
-  function decimals() external view returns (uint8);
-}
-
 interface IStakedTokenV2 {
   struct CooldownSnapshot {
     uint40 timestamp;
@@ -585,429 +585,6 @@ interface IStakedTokenV2 {
   ) external;
 }
 
-// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
-
-// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
-
-/**
- * @dev Provides information about the current execution context, including the
- * sender of the transaction and its data. While these are generally available
- * via msg.sender and msg.data, they should not be accessed in such a direct
- * manner, since when dealing with meta-transactions the account sending and
- * paying for execution may not be the actual sender (as far as an application
- * is concerned).
- *
- * This contract is only required for intermediate, library-like contracts.
- */
-abstract contract Context {
-  function _msgSender() internal view virtual returns (address) {
-    return msg.sender;
-  }
-
-  function _msgData() internal view virtual returns (bytes calldata) {
-    return msg.data;
-  }
-}
-
-/**
- * @dev Implementation of the {IERC20} interface.
- *
- * This implementation is agnostic to the way tokens are created. This means
- * that a supply mechanism has to be added in a derived contract using {_mint}.
- * For a generic mechanism see {ERC20PresetMinterPauser}.
- *
- * TIP: For a detailed writeup see our guide
- * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
- * to implement supply mechanisms].
- *
- * We have followed general OpenZeppelin Contracts guidelines: functions revert
- * instead returning `false` on failure. This behavior is nonetheless
- * conventional and does not conflict with the expectations of ERC20
- * applications.
- *
- * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
- * This allows applications to reconstruct the allowance for all accounts just
- * by listening to said events. Other implementations of the EIP may not emit
- * these events, as it isn't required by the specification.
- *
- * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
- * functions have been added to mitigate the well-known issues around setting
- * allowances. See {IERC20-approve}.
- */
-contract ERC20 is Context, IERC20, IERC20Metadata {
-  mapping(address => uint256) internal _balances;
-
-  mapping(address => mapping(address => uint256)) private _allowances;
-
-  uint256 internal _totalSupply;
-
-  string private _name;
-  string private _symbol;
-  uint8 private _decimals; // @deprecated
-
-  /**
-   * @dev Sets the values for {name} and {symbol}.
-   *
-   * The default value of {decimals} is 18. To select a different value for
-   * {decimals} you should overload it.
-   *
-   * All two of these values are immutable: they can only be set once during
-   * construction.
-   */
-  constructor() {}
-
-  /**
-   * @dev Returns the name of the token.
-   */
-  function name() public view virtual override returns (string memory) {
-    return _name;
-  }
-
-  /**
-   * @dev Returns the symbol of the token, usually a shorter version of the
-   * name.
-   */
-  function symbol() public view virtual override returns (string memory) {
-    return _symbol;
-  }
-
-  /**
-   * @dev Returns the number of decimals used to get its user representation.
-   * For example, if `decimals` equals `2`, a balance of `505` tokens should
-   * be displayed to a user as `5.05` (`505 / 10 ** 2`).
-   *
-   * Tokens usually opt for a value of 18, imitating the relationship between
-   * Ether and Wei. This is the value {ERC20} uses, unless this function is
-   * overridden;
-   *
-   * NOTE: This information is only used for _display_ purposes: it in
-   * no way affects any of the arithmetic of the contract, including
-   * {IERC20-balanceOf} and {IERC20-transfer}.
-   */
-  function decimals() public view virtual override returns (uint8) {
-    return 18;
-  }
-
-  /**
-   * @dev See {IERC20-totalSupply}.
-   */
-  function totalSupply() public view virtual override returns (uint256) {
-    return _totalSupply;
-  }
-
-  /**
-   * @dev See {IERC20-balanceOf}.
-   */
-  function balanceOf(
-    address account
-  ) public view virtual override returns (uint256) {
-    return _balances[account];
-  }
-
-  /**
-   * @dev See {IERC20-transfer}.
-   *
-   * Requirements:
-   *
-   * - `to` cannot be the zero address.
-   * - the caller must have a balance of at least `amount`.
-   */
-  function transfer(
-    address to,
-    uint256 amount
-  ) public virtual override returns (bool) {
-    address owner = _msgSender();
-    _transfer(owner, to, amount);
-    return true;
-  }
-
-  /**
-   * @dev See {IERC20-allowance}.
-   */
-  function allowance(
-    address owner,
-    address spender
-  ) public view virtual override returns (uint256) {
-    return _allowances[owner][spender];
-  }
-
-  /**
-   * @dev See {IERC20-approve}.
-   *
-   * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
-   * `transferFrom`. This is semantically equivalent to an infinite approval.
-   *
-   * Requirements:
-   *
-   * - `spender` cannot be the zero address.
-   */
-  function approve(
-    address spender,
-    uint256 amount
-  ) public virtual override returns (bool) {
-    address owner = _msgSender();
-    _approve(owner, spender, amount);
-    return true;
-  }
-
-  /**
-   * @dev See {IERC20-transferFrom}.
-   *
-   * Emits an {Approval} event indicating the updated allowance. This is not
-   * required by the EIP. See the note at the beginning of {ERC20}.
-   *
-   * NOTE: Does not update the allowance if the current allowance
-   * is the maximum `uint256`.
-   *
-   * Requirements:
-   *
-   * - `from` and `to` cannot be the zero address.
-   * - `from` must have a balance of at least `amount`.
-   * - the caller must have allowance for ``from``'s tokens of at least
-   * `amount`.
-   */
-  function transferFrom(
-    address from,
-    address to,
-    uint256 amount
-  ) public virtual override returns (bool) {
-    address spender = _msgSender();
-    _spendAllowance(from, spender, amount);
-    _transfer(from, to, amount);
-    return true;
-  }
-
-  /**
-   * @dev Atomically increases the allowance granted to `spender` by the caller.
-   *
-   * This is an alternative to {approve} that can be used as a mitigation for
-   * problems described in {IERC20-approve}.
-   *
-   * Emits an {Approval} event indicating the updated allowance.
-   *
-   * Requirements:
-   *
-   * - `spender` cannot be the zero address.
-   */
-  function increaseAllowance(
-    address spender,
-    uint256 addedValue
-  ) public virtual returns (bool) {
-    address owner = _msgSender();
-    _approve(owner, spender, allowance(owner, spender) + addedValue);
-    return true;
-  }
-
-  /**
-   * @dev Atomically decreases the allowance granted to `spender` by the caller.
-   *
-   * This is an alternative to {approve} that can be used as a mitigation for
-   * problems described in {IERC20-approve}.
-   *
-   * Emits an {Approval} event indicating the updated allowance.
-   *
-   * Requirements:
-   *
-   * - `spender` cannot be the zero address.
-   * - `spender` must have allowance for the caller of at least
-   * `subtractedValue`.
-   */
-  function decreaseAllowance(
-    address spender,
-    uint256 subtractedValue
-  ) public virtual returns (bool) {
-    address owner = _msgSender();
-    uint256 currentAllowance = allowance(owner, spender);
-    require(
-      currentAllowance >= subtractedValue,
-      'ERC20: decreased allowance below zero'
-    );
-    unchecked {
-      _approve(owner, spender, currentAllowance - subtractedValue);
-    }
-
-    return true;
-  }
-
-  /**
-   * @dev Moves `amount` of tokens from `from` to `to`.
-   *
-   * This internal function is equivalent to {transfer}, and can be used to
-   * e.g. implement automatic token fees, slashing mechanisms, etc.
-   *
-   * Emits a {Transfer} event.
-   *
-   * Requirements:
-   *
-   * - `from` cannot be the zero address.
-   * - `to` cannot be the zero address.
-   * - `from` must have a balance of at least `amount`.
-   */
-  function _transfer(
-    address from,
-    address to,
-    uint256 amount
-  ) internal virtual {
-    require(from != address(0), 'ERC20: transfer from the zero address');
-    require(to != address(0), 'ERC20: transfer to the zero address');
-
-    _beforeTokenTransfer(from, to, amount);
-
-    uint256 fromBalance = _balances[from];
-    require(fromBalance >= amount, 'ERC20: transfer amount exceeds balance');
-    unchecked {
-      _balances[from] = fromBalance - amount;
-      // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
-      // decrementing then incrementing.
-      _balances[to] += amount;
-    }
-
-    emit Transfer(from, to, amount);
-
-    _afterTokenTransfer(from, to, amount);
-  }
-
-  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
-   * the total supply.
-   *
-   * Emits a {Transfer} event with `from` set to the zero address.
-   *
-   * Requirements:
-   *
-   * - `account` cannot be the zero address.
-   */
-  function _mint(address account, uint256 amount) internal virtual {
-    require(account != address(0), 'ERC20: mint to the zero address');
-
-    _beforeTokenTransfer(address(0), account, amount);
-
-    _totalSupply += amount;
-    unchecked {
-      // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
-      _balances[account] += amount;
-    }
-    emit Transfer(address(0), account, amount);
-
-    _afterTokenTransfer(address(0), account, amount);
-  }
-
-  /**
-   * @dev Destroys `amount` tokens from `account`, reducing the
-   * total supply.
-   *
-   * Emits a {Transfer} event with `to` set to the zero address.
-   *
-   * Requirements:
-   *
-   * - `account` cannot be the zero address.
-   * - `account` must have at least `amount` tokens.
-   */
-  function _burn(address account, uint256 amount) internal virtual {
-    require(account != address(0), 'ERC20: burn from the zero address');
-
-    _beforeTokenTransfer(account, address(0), amount);
-
-    uint256 accountBalance = _balances[account];
-    require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
-    unchecked {
-      _balances[account] = accountBalance - amount;
-      // Overflow not possible: amount <= accountBalance <= totalSupply.
-      _totalSupply -= amount;
-    }
-
-    emit Transfer(account, address(0), amount);
-
-    _afterTokenTransfer(account, address(0), amount);
-  }
-
-  /**
-   * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
-   *
-   * This internal function is equivalent to `approve`, and can be used to
-   * e.g. set automatic allowances for certain subsystems, etc.
-   *
-   * Emits an {Approval} event.
-   *
-   * Requirements:
-   *
-   * - `owner` cannot be the zero address.
-   * - `spender` cannot be the zero address.
-   */
-  function _approve(
-    address owner,
-    address spender,
-    uint256 amount
-  ) internal virtual {
-    require(owner != address(0), 'ERC20: approve from the zero address');
-    require(spender != address(0), 'ERC20: approve to the zero address');
-
-    _allowances[owner][spender] = amount;
-    emit Approval(owner, spender, amount);
-  }
-
-  /**
-   * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
-   *
-   * Does not update the allowance amount in case of infinite allowance.
-   * Revert if not enough allowance is available.
-   *
-   * Might emit an {Approval} event.
-   */
-  function _spendAllowance(
-    address owner,
-    address spender,
-    uint256 amount
-  ) internal virtual {
-    uint256 currentAllowance = allowance(owner, spender);
-    if (currentAllowance != type(uint256).max) {
-      require(currentAllowance >= amount, 'ERC20: insufficient allowance');
-      unchecked {
-        _approve(owner, spender, currentAllowance - amount);
-      }
-    }
-  }
-
-  /**
-   * @dev Hook that is called before any transfer of tokens. This includes
-   * minting and burning.
-   *
-   * Calling conditions:
-   *
-   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
-   * will be transferred to `to`.
-   * - when `from` is zero, `amount` tokens will be minted for `to`.
-   * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
-   * - `from` and `to` are never both zero.
-   *
-   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
-   */
-  function _beforeTokenTransfer(
-    address from,
-    address to,
-    uint256 amount
-  ) internal virtual {}
-
-  /**
-   * @dev Hook that is called after any transfer of tokens. This includes
-   * minting and burning.
-   *
-   * Calling conditions:
-   *
-   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
-   * has been transferred to `to`.
-   * - when `from` is zero, `amount` tokens have been minted for `to`.
-   * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
-   * - `from` and `to` are never both zero.
-   *
-   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
-   */
-  function _afterTokenTransfer(
-    address from,
-    address to,
-    uint256 amount
-  ) internal virtual {}
-}
-
 /**
  * @title VersionedInitializable
  *
@@ -1305,439 +882,330 @@ interface ITransferHook {
   function onTransfer(address from, address to, uint256 amount) external;
 }
 
-interface IGovernancePowerDelegationToken {
-  enum DelegationType {
-    VOTING_POWER,
-    PROPOSITION_POWER
-  }
-
-  /**
-   * @dev emitted when a user delegates to another
-   * @param delegator the delegator
-   * @param delegatee the delegatee
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  event DelegateChanged(
-    address indexed delegator,
-    address indexed delegatee,
-    DelegationType delegationType
-  );
-
-  /**
-   * @dev emitted when an action changes the delegated power of a user
-   * @param user the user which delegated power has changed
-   * @param amount the amount of delegated power for the user
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  event DelegatedPowerChanged(
-    address indexed user,
-    uint256 amount,
-    DelegationType delegationType
-  );
-
-  /**
-   * @dev delegates the specific power to a delegatee
-   * @param delegatee the user which delegated power has changed
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  function delegateByType(
-    address delegatee,
-    DelegationType delegationType
-  ) external;
-
-  /**
-   * @dev delegates all the powers to a specific user
-   * @param delegatee the user to which the power will be delegated
-   **/
-  function delegate(address delegatee) external;
-
-  /**
-   * @dev returns the delegatee of an user
-   * @param delegator the address of the delegator
-   **/
-  function getDelegateeByType(
-    address delegator,
-    DelegationType delegationType
-  ) external view returns (address);
-
-  /**
-   * @dev returns the current delegated power of a user. The current power is the
-   * power delegated at the time of the last snapshot
-   * @param user the user
-   **/
-  function getPowerCurrent(
-    address user,
-    DelegationType delegationType
-  ) external view returns (uint256);
-
-  /**
-   * @dev returns the delegated power of a user at a certain block
-   * @param user the user
-   **/
-  function getPowerAtBlock(
-    address user,
-    uint256 blockNumber,
-    DelegationType delegationType
-  ) external view returns (uint256);
-
-  /**
-   * @dev returns the total supply at a certain block number
-   **/
-  function totalSupplyAt(uint256 blockNumber) external view returns (uint256);
-}
-
 /**
- * @notice implementation of the AAVE token contract
+ * @title ERC20WithSnapshot
+ * @notice ERC20 including snapshots of balances on transfer-related actions
  * @author Aave
- */
-abstract contract GovernancePowerDelegationERC20 is
-  ERC20,
-  IGovernancePowerDelegationToken
-{
-  /// @notice The EIP-712 typehash for the delegation struct used by the contract
-  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
-    keccak256(
-      'DelegateByType(address delegatee,uint256 type,uint256 nonce,uint256 expiry)'
-    );
-
-  bytes32 public constant DELEGATE_TYPEHASH =
-    keccak256('Delegate(address delegatee,uint256 nonce,uint256 expiry)');
-
-  /// @dev snapshot of a value on a specific block, used for votes
+ **/
+abstract contract GovernancePowerWithSnapshot {
   struct Snapshot {
     uint128 blockNumber;
     uint128 value;
   }
+  /// @dev DEPRECATED
+  mapping(address => mapping(uint256 => Snapshot))
+    public deprecated_votingSnapshots;
+  /// @dev DEPRECATED
+  mapping(address => uint256) public deprecated_votingSnapshotsCounts;
+  /// @dev DEPRECATED
+  ITransferHook public deprecated_aaveGovernance;
+}
 
-  /**
-   * @dev delegates one specific power to a delegatee
-   * @param delegatee the user which delegated power has changed
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  function delegateByType(
-    address delegatee,
-    DelegationType delegationType
-  ) external override {
-    _delegateByType(msg.sender, delegatee, delegationType);
+// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
+
+/**
+ * @dev Provides information about the current execution context, including the
+ * sender of the transaction and its data. While these are generally available
+ * via msg.sender and msg.data, they should not be accessed in such a direct
+ * manner, since when dealing with meta-transactions the account sending and
+ * paying for execution may not be the actual sender (as far as an application
+ * is concerned).
+ *
+ * This contract is only required for intermediate, library-like contracts.
+ */
+abstract contract Context {
+  function _msgSender() internal view virtual returns (address) {
+    return msg.sender;
   }
 
-  /**
-   * @dev delegates all the powers to a specific user
-   * @param delegatee the user to which the power will be delegated
-   **/
-  function delegate(address delegatee) external override {
-    _delegateByType(msg.sender, delegatee, DelegationType.VOTING_POWER);
-    _delegateByType(msg.sender, delegatee, DelegationType.PROPOSITION_POWER);
+  function _msgData() internal view virtual returns (bytes calldata) {
+    return msg.data;
   }
+}
 
-  /**
-   * @dev returns the delegatee of an user
-   * @param delegator the address of the delegator
-   **/
-  function getDelegateeByType(
-    address delegator,
-    DelegationType delegationType
-  ) external view override returns (address) {
-    (
-      ,
-      ,
-      mapping(address => address) storage delegates
-    ) = _getDelegationDataByType(delegationType);
-
-    return _getDelegatee(delegator, delegates);
+enum DelegationMode {
+  NO_DELEGATION,
+  VOTING_DELEGATED,
+  PROPOSITION_DELEGATED,
+  FULL_POWER_DELEGATED
+}
+
+// Inspired by OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
+abstract contract BaseAaveToken is Context, IERC20Metadata {
+  struct DelegationAwareBalance {
+    uint104 balance;
+    uint72 delegatedPropositionBalance;
+    uint72 delegatedVotingBalance;
+    DelegationMode delegationMode;
   }
 
-  /**
-   * @dev returns the current delegated power of a user. The current power is the
-   * power delegated at the time of the last snapshot
-   * @param user the user
-   **/
-  function getPowerCurrent(
-    address user,
-    DelegationType delegationType
-  ) external view override returns (uint256) {
-    (
-      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-      mapping(address => uint256) storage snapshotsCounts,
+  mapping(address => DelegationAwareBalance) internal _balances;
 
-    ) = _getDelegationDataByType(delegationType);
+  mapping(address => mapping(address => uint256)) internal _allowances;
 
-    return _searchByBlockNumber(snapshots, snapshotsCounts, user, block.number);
-  }
+  uint256 internal _totalSupply;
 
-  /**
-   * @dev returns the delegated power of a user at a certain block
-   * @param user the user
-   **/
-  function getPowerAtBlock(
-    address user,
-    uint256 blockNumber,
-    DelegationType delegationType
-  ) external view override returns (uint256) {
-    (
-      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-      mapping(address => uint256) storage snapshotsCounts,
-
-    ) = _getDelegationDataByType(delegationType);
-
-    return _searchByBlockNumber(snapshots, snapshotsCounts, user, blockNumber);
-  }
+  string internal _name;
+  string internal _symbol;
+
+  // @dev DEPRECATED
+  // kept for backwards compatibility with old storage layout
+  uint8 private ______DEPRECATED_OLD_ERC20_DECIMALS;
 
   /**
-   * @dev returns the total supply at a certain block number
-   * used by the voting strategy contracts to calculate the total votes needed for threshold/quorum
-   * In this initial implementation with no AAVE minting, simply returns the current supply
-   * A snapshots mapping will need to be added in case a mint function is added to the AAVE token in the future
-   **/
-  function totalSupplyAt(uint256) external view override returns (uint256) {
-    return super.totalSupply();
+   * @dev Returns the name of the token.
+   */
+  function name() public view virtual override returns (string memory) {
+    return _name;
   }
 
   /**
-   * @dev delegates the specific power to a delegatee
-   * @param delegatee the user which delegated power has changed
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  function _delegateByType(
-    address delegator,
-    address delegatee,
-    DelegationType delegationType
-  ) internal {
-    require(delegatee != address(0), 'INVALID_DELEGATEE');
-
-    (
-      ,
-      ,
-      mapping(address => address) storage delegates
-    ) = _getDelegationDataByType(delegationType);
-
-    uint256 delegatorBalance = balanceOf(delegator);
-
-    address previousDelegatee = _getDelegatee(delegator, delegates);
-
-    delegates[delegator] = delegatee;
-
-    _moveDelegatesByType(
-      previousDelegatee,
-      delegatee,
-      delegatorBalance,
-      delegationType
-    );
-    emit DelegateChanged(delegator, delegatee, delegationType);
+   * @dev Returns the symbol of the token, usually a shorter version of the
+   * name.
+   */
+  function symbol() public view virtual override returns (string memory) {
+    return _symbol;
   }
 
-  /**
-   * @dev moves delegated power from one user to another
-   * @param from the user from which delegated power is moved
-   * @param to the user that will receive the delegated power
-   * @param amount the amount of delegated power to be moved
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  function _moveDelegatesByType(
-    address from,
-    address to,
-    uint256 amount,
-    DelegationType delegationType
-  ) internal {
-    if (from == to) {
-      return;
-    }
+  function decimals() public view virtual override returns (uint8) {
+    return 18;
+  }
 
-    (
-      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-      mapping(address => uint256) storage snapshotsCounts,
+  function totalSupply() public view virtual override returns (uint256) {
+    return _totalSupply;
+  }
 
-    ) = _getDelegationDataByType(delegationType);
+  function balanceOf(
+    address account
+  ) public view virtual override returns (uint256) {
+    return _balances[account].balance;
+  }
 
-    if (from != address(0)) {
-      uint256 previous = 0;
-      uint256 fromSnapshotsCount = snapshotsCounts[from];
+  function transfer(
+    address to,
+    uint256 amount
+  ) public virtual override returns (bool) {
+    address owner = _msgSender();
+    _transfer(owner, to, amount);
+    return true;
+  }
 
-      if (fromSnapshotsCount != 0) {
-        previous = snapshots[from][fromSnapshotsCount - 1].value;
-      } else {
-        previous = balanceOf(from);
-      }
+  function allowance(
+    address owner,
+    address spender
+  ) public view virtual override returns (uint256) {
+    return _allowances[owner][spender];
+  }
 
-      _writeSnapshot(
-        snapshots,
-        snapshotsCounts,
-        from,
-        uint128(previous),
-        uint128(previous - amount)
-      );
+  function approve(
+    address spender,
+    uint256 amount
+  ) public virtual override returns (bool) {
+    address owner = _msgSender();
+    _approve(owner, spender, amount);
+    return true;
+  }
 
-      emit DelegatedPowerChanged(from, previous - amount, delegationType);
-    }
-    if (to != address(0)) {
-      uint256 previous = 0;
-      uint256 toSnapshotsCount = snapshotsCounts[to];
-      if (toSnapshotsCount != 0) {
-        previous = snapshots[to][toSnapshotsCount - 1].value;
-      } else {
-        previous = balanceOf(to);
-      }
+  function transferFrom(
+    address from,
+    address to,
+    uint256 amount
+  ) public virtual override returns (bool) {
+    address spender = _msgSender();
+    _spendAllowance(from, spender, amount);
+    _transfer(from, to, amount);
+    return true;
+  }
 
-      _writeSnapshot(
-        snapshots,
-        snapshotsCounts,
-        to,
-        uint128(previous),
-        uint128(previous + amount)
-      );
+  function increaseAllowance(
+    address spender,
+    uint256 addedValue
+  ) public virtual returns (bool) {
+    address owner = _msgSender();
+    _approve(owner, spender, _allowances[owner][spender] + addedValue);
+    return true;
+  }
 
-      emit DelegatedPowerChanged(to, previous + amount, delegationType);
+  function decreaseAllowance(
+    address spender,
+    uint256 subtractedValue
+  ) public virtual returns (bool) {
+    address owner = _msgSender();
+    uint256 currentAllowance = _allowances[owner][spender];
+    require(
+      currentAllowance >= subtractedValue,
+      'ERC20: decreased allowance below zero'
+    );
+    unchecked {
+      _approve(owner, spender, currentAllowance - subtractedValue);
     }
+
+    return true;
   }
 
-  /**
-   * @dev searches a snapshot by block number. Uses binary search.
-   * @param snapshots the snapshots mapping
-   * @param snapshotsCounts the number of snapshots
-   * @param user the user for which the snapshot is being searched
-   * @param blockNumber the block number being searched
-   **/
-  function _searchByBlockNumber(
-    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-    mapping(address => uint256) storage snapshotsCounts,
-    address user,
-    uint256 blockNumber
-  ) internal view virtual returns (uint256) {
-    require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
-
-    uint256 snapshotsCount = snapshotsCounts[user];
-
-    if (snapshotsCount == 0) {
-      return balanceOf(user);
-    }
+  function _transfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {
+    require(from != address(0), 'ERC20: transfer from the zero address');
+    require(to != address(0), 'ERC20: transfer to the zero address');
+
+    uint104 fromBalanceBefore = _balances[from].balance;
+    uint104 toBalanceBefore = _balances[to].balance;
 
-    // Check implicit zero balance
-    if (snapshots[user][0].blockNumber > blockNumber) {
-      return 0;
+    require(
+      fromBalanceBefore >= amount,
+      'ERC20: transfer amount exceeds balance'
+    );
+    unchecked {
+      _balances[from].balance = fromBalanceBefore - uint104(amount);
     }
 
-    return _binarySearch(snapshots[user], snapshotsCount, blockNumber);
+    _balances[to].balance = toBalanceBefore + uint104(amount);
+
+    _afterTokenTransfer(from, to, fromBalanceBefore, toBalanceBefore, amount);
+    emit Transfer(from, to, amount);
   }
 
-  function _binarySearch(
-    mapping(uint256 => Snapshot) storage snapshots,
-    uint256 snapshotsCount,
-    uint256 blockNumber
-  ) internal view returns (uint256) {
-    unchecked {
-      // First check most recent balance
-      if (snapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
-        return snapshots[snapshotsCount - 1].value;
-      }
+  function _approve(
+    address owner,
+    address spender,
+    uint256 amount
+  ) internal virtual {
+    require(owner != address(0), 'ERC20: approve from the zero address');
+    require(spender != address(0), 'ERC20: approve to the zero address');
+
+    _allowances[owner][spender] = amount;
+    emit Approval(owner, spender, amount);
+  }
 
-      uint256 lower = 0;
-      uint256 upper = snapshotsCount - 1;
-      while (upper > lower) {
-        uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
-        Snapshot memory snapshot = snapshots[center];
-        if (snapshot.blockNumber == blockNumber) {
-          return snapshot.value;
-        } else if (snapshot.blockNumber < blockNumber) {
-          lower = center;
-        } else {
-          upper = center - 1;
-        }
+  function _spendAllowance(
+    address owner,
+    address spender,
+    uint256 amount
+  ) internal virtual {
+    uint256 currentAllowance = allowance(owner, spender);
+    if (currentAllowance != type(uint256).max) {
+      require(currentAllowance >= amount, 'ERC20: insufficient allowance');
+      unchecked {
+        _approve(owner, spender, currentAllowance - amount);
       }
-      return snapshots[lower].value;
     }
   }
 
   /**
-   * @dev returns the delegation data (snapshot, snapshotsCount, list of delegates) by delegation type
-   * NOTE: Ideal implementation would have mapped this in a struct by delegation type. Unfortunately,
-   * the AAVE token and StakeToken already include a mapping for the snapshots, so we require contracts
-   * who inherit from this to provide access to the delegation data by overriding this method.
-   * @param delegationType the type of delegation
+   * @dev after token transfer hook, added for delegation system
+   * @param from token sender
+   * @param to token recipient
+   * @param fromBalanceBefore balance of the sender before transfer
+   * @param toBalanceBefore balance of the recipient before transfer
+   * @param amount amount of tokens sent
    **/
-  function _getDelegationDataByType(
-    DelegationType delegationType
-  )
-    internal
-    view
-    virtual
-    returns (
-      mapping(address => mapping(uint256 => Snapshot)) storage, //snapshots
-      mapping(address => uint256) storage, //snapshots count
-      mapping(address => address) storage //delegatees list
-    );
+  function _afterTokenTransfer(
+    address from,
+    address to,
+    uint256 fromBalanceBefore,
+    uint256 toBalanceBefore,
+    uint256 amount
+  ) internal virtual {}
+}
 
-  /**
-   * @dev Writes a snapshot for an owner of tokens
-   * @param owner The owner of the tokens
-   * @param oldValue The value before the operation that is gonna be executed after the snapshot
-   * @param newValue The value after the operation
+/**
+ * @title BaseMintableAaveToken
+ * @author BGD labs
+ * @notice extension for BaseAaveToken adding mint/burn and transfer hooks
+ */
+contract BaseMintableAaveToken is BaseAaveToken {
+  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
+   * the total supply.
+   *
+   * Emits a {Transfer} event with `from` set to the zero address.
+   *
+   * Requirements:
+   *
+   * - `account` cannot be the zero address.
    */
-  function _writeSnapshot(
-    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-    mapping(address => uint256) storage snapshotsCounts,
-    address owner,
-    uint128 oldValue,
-    uint128 newValue
-  ) internal {
-    uint128 currentBlock = uint128(block.number);
-
-    uint256 ownerSnapshotsCount = snapshotsCounts[owner];
-    mapping(uint256 => Snapshot) storage snapshotsOwner = snapshots[owner];
-
-    // Doing multiple operations in the same block
-    if (
-      ownerSnapshotsCount != 0 &&
-      snapshotsOwner[ownerSnapshotsCount - 1].blockNumber == currentBlock
-    ) {
-      snapshotsOwner[ownerSnapshotsCount - 1].value = newValue;
-    } else {
-      snapshotsOwner[ownerSnapshotsCount] = Snapshot(currentBlock, newValue);
-      snapshotsCounts[owner] = ownerSnapshotsCount + 1;
-    }
+  function _mint(address account, uint104 amount) internal virtual {
+    require(account != address(0), 'ERC20: mint to the zero address');
+
+    _beforeTokenTransfer(address(0), account, amount);
+
+    _totalSupply += amount;
+    _balances[account].balance += amount;
+    emit Transfer(address(0), account, amount);
+
+    _afterTokenTransfer(address(0), account, amount);
   }
 
   /**
-   * @dev returns the user delegatee. If a user never performed any delegation,
-   * his delegated address will be 0x0. In that case we simply return the user itself
-   * @param delegator the address of the user for which return the delegatee
-   * @param delegates the array of delegates for a particular type of delegation
-   **/
-  function _getDelegatee(
-    address delegator,
-    mapping(address => address) storage delegates
-  ) internal view returns (address) {
-    address previousDelegatee = delegates[delegator];
-
-    if (previousDelegatee == address(0)) {
-      return delegator;
+   * @dev Destroys `amount` tokens from `account`, reducing the
+   * total supply.
+   *
+   * Emits a {Transfer} event with `to` set to the zero address.
+   *
+   * Requirements:
+   *
+   * - `account` cannot be the zero address.
+   * - `account` must have at least `amount` tokens.
+   */
+  function _burn(address account, uint104 amount) internal virtual {
+    require(account != address(0), 'ERC20: burn from the zero address');
+
+    _beforeTokenTransfer(account, address(0), amount);
+
+    uint104 accountBalance = _balances[account].balance;
+    require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
+    unchecked {
+      _balances[account].balance = accountBalance - amount;
+      // Overflow not possible: amount <= accountBalance <= totalSupply.
+      _totalSupply -= amount;
     }
 
-    return previousDelegatee;
+    emit Transfer(account, address(0), amount);
+
+    _afterTokenTransfer(account, address(0), amount);
   }
-}
 
-/**
- * @title ERC20WithSnapshot
- * @notice ERC20 including snapshots of balances on transfer-related actions
- * @author Aave
- **/
-abstract contract GovernancePowerWithSnapshot is
-  GovernancePowerDelegationERC20
-{
   /**
-   * @dev The following storage layout points to the prior StakedToken.sol implementation:
-   * _snapshots => _votingSnapshots
-   * _snapshotsCounts =>  _votingSnapshotsCounts
-   * _aaveGovernance => _aaveGovernance
+   * @dev Hook that is called before any transfer of tokens. This includes
+   * minting and burning.
+   *
+   * Calling conditions:
+   *
+   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
+   * will be transferred to `to`.
+   * - when `from` is zero, `amount` tokens will be minted for `to`.
+   * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
+   * - `from` and `to` are never both zero.
+   *
+   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
    */
-  mapping(address => mapping(uint256 => Snapshot)) public _votingSnapshots;
-  mapping(address => uint256) public _votingSnapshotsCounts;
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
 
-  /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
-  /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
-  /// to control all potential reentrancies by calling back the this contract
-  /// @dev DEPRECATED
-  ITransferHook public _aaveGovernance;
+  /**
+   * @dev Hook that is called after any transfer of tokens. This includes
+   * minting and burning.
+   *
+   * Calling conditions:
+   *
+   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
+   * has been transferred to `to`.
+   * - when `from` is zero, `amount` tokens have been minted for `to`.
+   * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
+   * - `from` and `to` are never both zero.
+   *
+   * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
+   */
+  function _afterTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
 }
 
 /**
@@ -1747,6 +1215,7 @@ abstract contract GovernancePowerWithSnapshot is
  */
 abstract contract StakedTokenV2 is
   IStakedTokenV2,
+  BaseMintableAaveToken,
   GovernancePowerWithSnapshot,
   VersionedInitializable,
   AaveDistributionManager
@@ -1796,7 +1265,7 @@ abstract contract StakedTokenV2 is
     address rewardsVault,
     address emissionManager,
     uint128 distributionDuration
-  ) ERC20() AaveDistributionManager(emissionManager, distributionDuration) {
+  ) AaveDistributionManager(emissionManager, distributionDuration) {
     STAKED_TOKEN = stakedToken;
     REWARD_TOKEN = rewardToken;
     UNSTAKE_WINDOW = unstakeWindow;
@@ -1869,75 +1338,6 @@ abstract contract StakedTokenV2 is
     _approve(owner, spender, value);
   }
 
-  /**
-   * @dev Delegates power from signatory to `delegatee`
-   * @param delegatee The address to delegate votes to
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   * @param nonce The contract state required to match the signature
-   * @param expiry The time at which to expire the signature
-   * @param v The recovery byte of the signature
-   * @param r Half of the ECDSA signature pair
-   * @param s Half of the ECDSA signature pair
-   */
-  function delegateByTypeBySig(
-    address delegatee,
-    DelegationType delegationType,
-    uint256 nonce,
-    uint256 expiry,
-    uint8 v,
-    bytes32 r,
-    bytes32 s
-  ) public {
-    bytes32 structHash = keccak256(
-      abi.encode(
-        DELEGATE_BY_TYPE_TYPEHASH,
-        delegatee,
-        uint256(delegationType),
-        nonce,
-        expiry
-      )
-    );
-    bytes32 digest = keccak256(
-      abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash)
-    );
-    address signatory = ecrecover(digest, v, r, s);
-    require(signatory != address(0), 'INVALID_SIGNATURE');
-    require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
-    require(block.timestamp <= expiry, 'INVALID_EXPIRATION');
-    _delegateByType(signatory, delegatee, delegationType);
-  }
-
-  /**
-   * @dev Delegates power from signatory to `delegatee`
-   * @param delegatee The address to delegate votes to
-   * @param nonce The contract state required to match the signature
-   * @param expiry The time at which to expire the signature
-   * @param v The recovery byte of the signature
-   * @param r Half of the ECDSA signature pair
-   * @param s Half of the ECDSA signature pair
-   */
-  function delegateBySig(
-    address delegatee,
-    uint256 nonce,
-    uint256 expiry,
-    uint8 v,
-    bytes32 r,
-    bytes32 s
-  ) public {
-    bytes32 structHash = keccak256(
-      abi.encode(DELEGATE_TYPEHASH, delegatee, nonce, expiry)
-    );
-    bytes32 digest = keccak256(
-      abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash)
-    );
-    address signatory = ecrecover(digest, v, r, s);
-    require(signatory != address(0), 'INVALID_SIGNATURE');
-    require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
-    require(block.timestamp <= expiry, 'INVALID_EXPIRATION');
-    _delegateByType(signatory, delegatee, DelegationType.VOTING_POWER);
-    _delegateByType(signatory, delegatee, DelegationType.PROPOSITION_POWER);
-  }
-
   /**
    * @dev Updates the user state related with his accrued rewards
    * @param user Address of the user
@@ -1967,34 +1367,6 @@ abstract contract StakedTokenV2 is
 
     return unclaimedRewards;
   }
-
-  /**
-   * @dev returns relevant storage slots for a DelegationType
-   * @param delegationType the requested DelegationType
-   * @return the relevant storage
-   */
-  function _getDelegationDataByType(
-    DelegationType delegationType
-  )
-    internal
-    view
-    override
-    returns (
-      mapping(address => mapping(uint256 => Snapshot)) storage, //snapshots
-      mapping(address => uint256) storage, //snapshots count
-      mapping(address => address) storage //delegatees list
-    )
-  {
-    if (delegationType == DelegationType.VOTING_POWER) {
-      return (_votingSnapshots, _votingSnapshotsCounts, _votingDelegates);
-    } else {
-      return (
-        _propositionPowerSnapshots,
-        _propositionPowerSnapshotsCounts,
-        _propositionPowerDelegates
-      );
-    }
-  }
 }
 
 interface IStakedTokenV3 is IStakedTokenV2 {
@@ -3516,6 +2888,633 @@ library SafeCast {
   }
 }
 
+/** @notice influenced by OpenZeppelin SafeCast lib, which is missing to uint72 cast
+ * @author BGD Labs
+ */
+library SafeCast72 {
+  /**
+   * @dev Returns the downcasted uint72 from uint256, reverting on
+   * overflow (when the input is greater than largest uint72).
+   *
+   * Counterpart to Solidity's `uint16` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 72 bits
+   */
+  function toUint72(uint256 value) internal pure returns (uint72) {
+    require(
+      value <= type(uint72).max,
+      "SafeCast: value doesn't fit in 72 bits"
+    );
+    return uint72(value);
+  }
+}
+
+interface IGovernancePowerDelegationToken {
+  enum GovernancePowerType {
+    VOTING,
+    PROPOSITION
+  }
+
+  /**
+   * @dev emitted when a user delegates to another
+   * @param delegator the user which delegated governance power
+   * @param delegatee the delegatee
+   * @param delegationType the type of delegation (VOTING, PROPOSITION)
+   **/
+  event DelegateChanged(
+    address indexed delegator,
+    address indexed delegatee,
+    GovernancePowerType delegationType
+  );
+
+  // @dev we removed DelegatedPowerChanged event because to reconstruct the full state of the system,
+  // is enough to have Transfer and DelegateChanged TODO: document it
+
+  /**
+   * @dev delegates the specific power to a delegatee
+   * @param delegatee the user which delegated power will change
+   * @param delegationType the type of delegation (VOTING, PROPOSITION)
+   **/
+  function delegateByType(
+    address delegatee,
+    GovernancePowerType delegationType
+  ) external;
+
+  /**
+   * @dev delegates all the governance powers to a specific user
+   * @param delegatee the user to which the powers will be delegated
+   **/
+  function delegate(address delegatee) external;
+
+  /**
+   * @dev returns the delegatee of an user
+   * @param delegator the address of the delegator
+   * @param delegationType the type of delegation (VOTING, PROPOSITION)
+   * @return address of the specified delegatee
+   **/
+  function getDelegateeByType(
+    address delegator,
+    GovernancePowerType delegationType
+  ) external view returns (address);
+
+  /**
+   * @dev returns delegates of an user
+   * @param delegator the address of the delegator
+   * @return a tuple of addresses the VOTING and PROPOSITION delegatee
+   **/
+  function getDelegates(
+    address delegator
+  ) external view returns (address, address);
+
+  /**
+   * @dev returns the current voting or proposition power of a user.
+   * @param user the user
+   * @param delegationType the type of delegation (VOTING, PROPOSITION)
+   * @return the current voting or proposition power of a user
+   **/
+  function getPowerCurrent(
+    address user,
+    GovernancePowerType delegationType
+  ) external view returns (uint256);
+
+  /**
+   * @dev returns the current voting or proposition power of a user.
+   * @param user the user
+   * @return the current voting and proposition power of a user
+   **/
+  function getPowersCurrent(
+    address user
+  ) external view returns (uint256, uint256);
+
+  /**
+   * @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
+   * @param delegator the owner of the funds
+   * @param delegatee the user to who owner delegates his governance power
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   * @param deadline the deadline timestamp, type(uint256).max for no deadline
+   * @param v signature param
+   * @param s signature param
+   * @param r signature param
+   */
+  function metaDelegateByType(
+    address delegator,
+    address delegatee,
+    GovernancePowerType delegationType,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external;
+
+  /**
+   * @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
+   * @param delegator the owner of the funds
+   * @param delegatee the user to who delegator delegates his voting and proposition governance power
+   * @param deadline the deadline timestamp, type(uint256).max for no deadline
+   * @param v signature param
+   * @param s signature param
+   * @param r signature param
+   */
+  function metaDelegate(
+    address delegator,
+    address delegatee,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external;
+}
+
+/**
+ * @notice The contract implements generic delegation functionality for the upcoming governance v3
+ * @author BGD Labs
+ * @dev to make it's pluggable to any exising token it has a set of virtual functions
+ *   for simple access to balances and permit functionality
+ * @dev ************ IMPORTANT SECURITY CONSIDERATION ************
+ *   current version of the token can be used only with asset which has 18 decimals
+ *   and possible totalSupply lower then 4722366482869645213696,
+ *   otherwise at least POWER_SCALE_FACTOR should be adjusted !!!
+ *   *************************************************************
+ */
+abstract contract BaseDelegation is IGovernancePowerDelegationToken {
+  struct DelegationState {
+    uint72 delegatedPropositionBalance;
+    uint72 delegatedVotingBalance;
+    DelegationMode delegationMode;
+  }
+
+  mapping(address => address) internal _votingDelegatee;
+  mapping(address => address) internal _propositionDelegatee;
+
+  /** @dev we assume that for the governance system delegation with 18 decimals of precision is not needed,
+   *   by this constant we reduce it by 10, to 8 decimals.
+   *   In case of Aave token this will allow to work with up to 47'223'664'828'696,45213696 total supply
+   *   If your token already have less then 10 decimals, please change it to appropriate.
+   */
+  uint256 public constant POWER_SCALE_FACTOR = 1e10;
+
+  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
+    keccak256(
+      'DelegateByType(address delegator,address delegatee,uint8 delegationType,uint256 nonce,uint256 deadline)'
+    );
+  bytes32 public constant DELEGATE_TYPEHASH =
+    keccak256(
+      'Delegate(address delegator,address delegatee,uint256 nonce,uint256 deadline)'
+    );
+
+  /**
+   * @notice returns eip-2612 compatible domain separator
+   * @dev we expect that existing tokens, ie Aave, already have, so we want to reuse
+   * @return domain separator
+   */
+  function _getDomainSeparator() internal view virtual returns (bytes32);
+
+  /**
+   * @notice gets the delegation state of a user
+   * @param user address
+   * @return state of a user's delegation
+   */
+  function _getDelegationState(
+    address user
+  ) internal view virtual returns (DelegationState memory);
+
+  /**
+   * @notice returns the token balance of a user
+   * @param user address
+   * @return current nonce before increase
+   */
+  function _getBalance(address user) internal view virtual returns (uint256);
+
+  /**
+   * @notice increases and return the current nonce of a user
+   * @dev should use `return nonce++;` pattern
+   * @param user address
+   * @return current nonce before increase
+   */
+  function _incrementNonces(address user) internal virtual returns (uint256);
+
+  /**
+   * @notice sets the delegation state of a user
+   * @param user address
+   * @param delegationState state of a user's delegation
+   */
+  function _setDelegationState(
+    address user,
+    DelegationState memory delegationState
+  ) internal virtual;
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function delegateByType(
+    address delegatee,
+    GovernancePowerType delegationType
+  ) external virtual override {
+    _delegateByType(msg.sender, delegatee, delegationType);
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function delegate(address delegatee) external override {
+    _delegateByType(msg.sender, delegatee, GovernancePowerType.VOTING);
+    _delegateByType(msg.sender, delegatee, GovernancePowerType.PROPOSITION);
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function getDelegateeByType(
+    address delegator,
+    GovernancePowerType delegationType
+  ) external view override returns (address) {
+    return
+      _getDelegateeByType(
+        delegator,
+        _getDelegationState(delegator),
+        delegationType
+      );
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function getDelegates(
+    address delegator
+  ) external view override returns (address, address) {
+    DelegationState memory delegatorBalance = _getDelegationState(delegator);
+    return (
+      _getDelegateeByType(
+        delegator,
+        delegatorBalance,
+        GovernancePowerType.VOTING
+      ),
+      _getDelegateeByType(
+        delegator,
+        delegatorBalance,
+        GovernancePowerType.PROPOSITION
+      )
+    );
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function getPowerCurrent(
+    address user,
+    GovernancePowerType delegationType
+  ) public view virtual override returns (uint256) {
+    DelegationState memory userState = _getDelegationState(user);
+    uint256 userOwnPower = uint8(userState.delegationMode) &
+      (uint8(delegationType) + 1) ==
+      0
+      ? _getBalance(user)
+      : 0;
+    uint256 userDelegatedPower = _getDelegatedPowerByType(
+      userState,
+      delegationType
+    );
+    return userOwnPower + userDelegatedPower;
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function getPowersCurrent(
+    address user
+  ) external view override returns (uint256, uint256) {
+    return (
+      getPowerCurrent(user, GovernancePowerType.VOTING),
+      getPowerCurrent(user, GovernancePowerType.PROPOSITION)
+    );
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function metaDelegateByType(
+    address delegator,
+    address delegatee,
+    GovernancePowerType delegationType,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external override {
+    require(delegator != address(0), 'INVALID_OWNER');
+    //solium-disable-next-line
+    require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
+    bytes32 digest = keccak256(
+      abi.encodePacked(
+        '\x19\x01',
+        _getDomainSeparator(),
+        keccak256(
+          abi.encode(
+            DELEGATE_BY_TYPE_TYPEHASH,
+            delegator,
+            delegatee,
+            delegationType,
+            _incrementNonces(delegator),
+            deadline
+          )
+        )
+      )
+    );
+
+    require(delegator == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
+    _delegateByType(delegator, delegatee, delegationType);
+  }
+
+  /// @inheritdoc IGovernancePowerDelegationToken
+  function metaDelegate(
+    address delegator,
+    address delegatee,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external override {
+    require(delegator != address(0), 'INVALID_OWNER');
+    //solium-disable-next-line
+    require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
+    bytes32 digest = keccak256(
+      abi.encodePacked(
+        '\x19\x01',
+        _getDomainSeparator(),
+        keccak256(
+          abi.encode(
+            DELEGATE_TYPEHASH,
+            delegator,
+            delegatee,
+            _incrementNonces(delegator),
+            deadline
+          )
+        )
+      )
+    );
+
+    require(delegator == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
+    _delegateByType(delegator, delegatee, GovernancePowerType.VOTING);
+    _delegateByType(delegator, delegatee, GovernancePowerType.PROPOSITION);
+  }
+
+  /**
+   * @dev Modifies the delegated power of a `delegatee` account by type (VOTING, PROPOSITION).
+   * Passing the impact on the delegation of `delegatee` account before and after to reduce conditionals and not lose
+   * any precision.
+   * @param impactOnDelegationBefore how much impact a balance of another account had over the delegation of a `delegatee`
+   * before an action.
+   * For example, if the action is a delegation from one account to another, the impact before the action will be 0.
+   * @param impactOnDelegationAfter how much impact a balance of another account will have  over the delegation of a `delegatee`
+   * after an action.
+   * For example, if the action is a delegation from one account to another, the impact after the action will be the whole balance
+   * of the account changing the delegatee.
+   * @param delegatee the user whom delegated governance power will be changed
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   **/
+  function _governancePowerTransferByType(
+    uint256 impactOnDelegationBefore,
+    uint256 impactOnDelegationAfter,
+    address delegatee,
+    GovernancePowerType delegationType
+  ) internal {
+    if (delegatee == address(0)) return;
+    if (impactOnDelegationBefore == impactOnDelegationAfter) return;
+
+    // we use uint72, because this is the most optimal for AaveTokenV3
+    // To make delegated balance fit into uint72 we're decreasing precision of delegated balance by POWER_SCALE_FACTOR
+    uint72 impactOnDelegationBefore72 = SafeCast72.toUint72(
+      impactOnDelegationBefore / POWER_SCALE_FACTOR
+    );
+    uint72 impactOnDelegationAfter72 = SafeCast72.toUint72(
+      impactOnDelegationAfter / POWER_SCALE_FACTOR
+    );
+
+    DelegationState memory delegateeState = _getDelegationState(delegatee);
+    if (delegationType == GovernancePowerType.VOTING) {
+      delegateeState.delegatedVotingBalance =
+        delegateeState.delegatedVotingBalance -
+        impactOnDelegationBefore72 +
+        impactOnDelegationAfter72;
+    } else {
+      delegateeState.delegatedPropositionBalance =
+        delegateeState.delegatedPropositionBalance -
+        impactOnDelegationBefore72 +
+        impactOnDelegationAfter72;
+    }
+    _setDelegationState(delegatee, delegateeState);
+  }
+
+  /**
+   * @dev performs all state changes related delegation changes on transfer
+   * @param from token sender
+   * @param to token recipient
+   * @param fromBalanceBefore balance of the sender before transfer
+   * @param toBalanceBefore balance of the recipient before transfer
+   * @param amount amount of tokens sent
+   **/
+  function _delegationChangeOnTransfer(
+    address from,
+    address to,
+    uint256 fromBalanceBefore,
+    uint256 toBalanceBefore,
+    uint256 amount
+  ) internal {
+    if (from == to) {
+      return;
+    }
+
+    if (from != address(0)) {
+      DelegationState memory fromUserState = _getDelegationState(from);
+      uint256 fromBalanceAfter = fromBalanceBefore - amount;
+      if (fromUserState.delegationMode != DelegationMode.NO_DELEGATION) {
+        _governancePowerTransferByType(
+          fromBalanceBefore,
+          fromBalanceAfter,
+          _getDelegateeByType(from, fromUserState, GovernancePowerType.VOTING),
+          GovernancePowerType.VOTING
+        );
+        _governancePowerTransferByType(
+          fromBalanceBefore,
+          fromBalanceAfter,
+          _getDelegateeByType(
+            from,
+            fromUserState,
+            GovernancePowerType.PROPOSITION
+          ),
+          GovernancePowerType.PROPOSITION
+        );
+      }
+    }
+
+    if (to != address(0)) {
+      DelegationState memory toUserState = _getDelegationState(to);
+      uint256 toBalanceAfter = toBalanceBefore + amount;
+
+      if (toUserState.delegationMode != DelegationMode.NO_DELEGATION) {
+        _governancePowerTransferByType(
+          toBalanceBefore,
+          toBalanceAfter,
+          _getDelegateeByType(to, toUserState, GovernancePowerType.VOTING),
+          GovernancePowerType.VOTING
+        );
+        _governancePowerTransferByType(
+          toBalanceBefore,
+          toBalanceAfter,
+          _getDelegateeByType(to, toUserState, GovernancePowerType.PROPOSITION),
+          GovernancePowerType.PROPOSITION
+        );
+      }
+    }
+  }
+
+  /**
+   * @dev Extracts from state and returns delegated governance power (Voting, Proposition)
+   * @param userState the current state of a user
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   **/
+  function _getDelegatedPowerByType(
+    DelegationState memory userState,
+    GovernancePowerType delegationType
+  ) internal pure returns (uint256) {
+    return
+      POWER_SCALE_FACTOR *
+      (
+        delegationType == GovernancePowerType.VOTING
+          ? userState.delegatedVotingBalance
+          : userState.delegatedPropositionBalance
+      );
+  }
+
+  /**
+   * @dev Extracts from state and returns the delegatee of a delegator by type of governance power (Voting, Proposition)
+   * - If the delegator doesn't have any delegatee, returns address(0)
+   * @param delegator delegator
+   * @param userState the current state of a user
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   **/
+  function _getDelegateeByType(
+    address delegator,
+    DelegationState memory userState,
+    GovernancePowerType delegationType
+  ) internal view returns (address) {
+    if (delegationType == GovernancePowerType.VOTING) {
+      return
+        /// With the & operation, we cover both VOTING_DELEGATED delegation and FULL_POWER_DELEGATED
+        /// as VOTING_DELEGATED is equivalent to 01 in binary and FULL_POWER_DELEGATED is equivalent to 11
+        (uint8(userState.delegationMode) &
+          uint8(DelegationMode.VOTING_DELEGATED)) != 0
+          ? _votingDelegatee[delegator]
+          : address(0);
+    }
+    return
+      userState.delegationMode >= DelegationMode.PROPOSITION_DELEGATED
+        ? _propositionDelegatee[delegator]
+        : address(0);
+  }
+
+  /**
+   * @dev Changes user's delegatee address by type of governance power (Voting, Proposition)
+   * @param delegator delegator
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   * @param _newDelegatee the new delegatee
+   **/
+  function _updateDelegateeByType(
+    address delegator,
+    GovernancePowerType delegationType,
+    address _newDelegatee
+  ) internal {
+    address newDelegatee = _newDelegatee == delegator
+      ? address(0)
+      : _newDelegatee;
+    if (delegationType == GovernancePowerType.VOTING) {
+      _votingDelegatee[delegator] = newDelegatee;
+    } else {
+      _propositionDelegatee[delegator] = newDelegatee;
+    }
+  }
+
+  /**
+   * @dev Updates the specific flag which signaling about existence of delegation of governance power (Voting, Proposition)
+   * @param userState a user state to change
+   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
+   * @param willDelegate next state of delegation
+   **/
+  function _updateDelegationModeByType(
+    DelegationState memory userState,
+    GovernancePowerType delegationType,
+    bool willDelegate
+  ) internal pure returns (DelegationState memory) {
+    if (willDelegate) {
+      // Because GovernancePowerType starts from 0, we should add 1 first, then we apply bitwise OR
+      userState.delegationMode = DelegationMode(
+        uint8(userState.delegationMode) | (uint8(delegationType) + 1)
+      );
+    } else {
+      // First bitwise NEGATION, ie was 01, after XOR with 11 will be 10,
+      // then bitwise AND, which means it will keep only another delegation type if it exists
+      userState.delegationMode = DelegationMode(
+        uint8(userState.delegationMode) &
+          ((uint8(delegationType) + 1) ^
+            uint8(DelegationMode.FULL_POWER_DELEGATED))
+      );
+    }
+    return userState;
+  }
+
+  /**
+   * @dev This is the equivalent of an ERC20 transfer(), but for a power type: an atomic transfer of a balance (power).
+   * When needed, it decreases the power of the `delegator` and when needed, it increases the power of the `delegatee`
+   * @param delegator delegator
+   * @param _delegatee the user which delegated power will change
+   * @param delegationType the type of delegation (VOTING, PROPOSITION)
+   **/
+  function _delegateByType(
+    address delegator,
+    address _delegatee,
+    GovernancePowerType delegationType
+  ) internal {
+    // Here we unify the property that delegating power to address(0) == delegating power to yourself == no delegation
+    // So from now on, not being delegating is (exclusively) that delegatee == address(0)
+    address delegatee = _delegatee == delegator ? address(0) : _delegatee;
+
+    // We read the whole struct before validating delegatee, because in the optimistic case
+    // (_delegatee != currentDelegatee) we will reuse userState in the rest of the function
+    DelegationState memory delegatorState = _getDelegationState(delegator);
+    address currentDelegatee = _getDelegateeByType(
+      delegator,
+      delegatorState,
+      delegationType
+    );
+    if (delegatee == currentDelegatee) return;
+
+    bool delegatingNow = currentDelegatee != address(0);
+    bool willDelegateAfter = delegatee != address(0);
+    uint256 delegatorBalance = _getBalance(delegator);
+
+    if (delegatingNow) {
+      _governancePowerTransferByType(
+        delegatorBalance,
+        0,
+        currentDelegatee,
+        delegationType
+      );
+    }
+
+    if (willDelegateAfter) {
+      _governancePowerTransferByType(
+        0,
+        delegatorBalance,
+        delegatee,
+        delegationType
+      );
+    }
+
+    _updateDelegateeByType(delegator, delegationType, delegatee);
+
+    if (willDelegateAfter != delegatingNow) {
+      _setDelegationState(
+        delegator,
+        _updateDelegationModeByType(
+          delegatorState,
+          delegationType,
+          willDelegateAfter
+        )
+      );
+    }
+
+    emit DelegateChanged(delegator, delegatee, delegationType);
+  }
+}
+
 /**
  * @title StakedTokenV3
  * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
@@ -3525,11 +3524,13 @@ contract StakedTokenV3 is
   StakedTokenV2,
   IStakedTokenV3,
   RoleManager,
-  IAaveDistributionManager
+  IAaveDistributionManager,
+  BaseDelegation
 {
   using SafeERC20 for IERC20;
   using PercentageMath for uint256;
   using SafeCast for uint256;
+  using SafeCast for uint104;
 
   uint256 public constant SLASH_ADMIN_ROLE = 0;
   uint256 public constant COOLDOWN_ADMIN_ROLE = 1;
@@ -3542,7 +3543,7 @@ contract StakedTokenV3 is
   uint256 public immutable LOWER_BOUND;
 
   // Reserved storage space to allow for layout changes in the future.
-  uint256[8] private ______gap;
+  uint256[6] private ______gap;
   /// @notice Seconds between starting cooldown and being able to withdraw
   uint256 internal _cooldownSeconds;
   /// @notice The maximum amount of funds that can be slashed at any given time
@@ -3705,7 +3706,7 @@ contract StakedTokenV3 is
     address to,
     uint256 amount
   ) external override(IStakedTokenV2, StakedTokenV2) {
-    _redeem(msg.sender, to, amount);
+    _redeem(msg.sender, to, amount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3714,7 +3715,7 @@ contract StakedTokenV3 is
     address to,
     uint256 amount
   ) external override onlyClaimHelper {
-    _redeem(from, to, amount);
+    _redeem(from, to, amount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV2
@@ -3741,7 +3742,7 @@ contract StakedTokenV3 is
     uint256 redeemAmount
   ) external override {
     _claimRewards(msg.sender, to, claimAmount);
-    _redeem(msg.sender, to, redeemAmount);
+    _redeem(msg.sender, to, redeemAmount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3752,7 +3753,7 @@ contract StakedTokenV3 is
     uint256 redeemAmount
   ) external override onlyClaimHelper {
     _claimRewards(from, to, claimAmount);
-    _redeem(from, to, redeemAmount);
+    _redeem(from, to, redeemAmount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3956,7 +3957,7 @@ contract StakedTokenV3 is
 
     STAKED_TOKEN.safeTransferFrom(from, address(this), amount);
 
-    _mint(to, sharesToMint);
+    _mint(to, sharesToMint.toUint104());
 
     emit Staked(from, to, amount, sharesToMint);
   }
@@ -3967,13 +3968,13 @@ contract StakedTokenV3 is
    * @param to Address to redeem to
    * @param amount Amount to redeem
    */
-  function _redeem(address from, address to, uint256 amount) internal {
+  function _redeem(address from, address to, uint104 amount) internal {
     require(amount != 0, 'INVALID_ZERO_AMOUNT');
 
     CooldownSnapshot memory cooldownSnapshot = stakersCooldowns[from];
     if (!inPostSlashingPeriod) {
       require(
-        (block.timestamp > cooldownSnapshot.timestamp + _cooldownSeconds),
+        (block.timestamp >= cooldownSnapshot.timestamp + _cooldownSeconds),
         'INSUFFICIENT_COOLDOWN'
       );
       require(
@@ -3995,7 +3996,7 @@ contract StakedTokenV3 is
 
     uint256 underlyingToRedeem = previewRedeem(amountToRedeem);
 
-    _burn(from, amountToRedeem);
+    _burn(from, amountToRedeem.toUint104());
 
     if (cooldownSnapshot.timestamp != 0) {
       if (cooldownSnapshot.amount - amountToRedeem == 0) {
@@ -4058,11 +4059,66 @@ contract StakedTokenV3 is
         if (balanceOfFrom == amount) {
           delete stakersCooldowns[from];
         } else if (balanceOfFrom - amount < previousSenderCooldown.amount) {
-          stakersCooldowns[from].amount = uint184(balanceOfFrom - amount);
+          stakersCooldowns[from].amount = uint216(balanceOfFrom - amount);
         }
       }
     }
 
+    _delegationChangeOnTransfer(
+      from,
+      to,
+      _getBalance(from),
+      _getBalance(to),
+      amount
+    );
+
     super._transfer(from, to, amount);
   }
+
+  function _getDelegationState(
+    address user
+  ) internal view override returns (DelegationState memory) {
+    DelegationAwareBalance memory userState = _balances[user];
+    return
+      DelegationState({
+        delegatedPropositionBalance: userState.delegatedPropositionBalance,
+        delegatedVotingBalance: userState.delegatedVotingBalance,
+        delegationMode: userState.delegationMode
+      });
+  }
+
+  function _getBalance(address user) internal view override returns (uint256) {
+    return balanceOf(user);
+  }
+
+  function getPowerCurrent(
+    address user,
+    GovernancePowerType delegationType
+  ) public view override returns (uint256) {
+    return
+      (super.getPowerCurrent(user, delegationType) * EXCHANGE_RATE_UNIT) /
+      getExchangeRate();
+  }
+
+  function _setDelegationState(
+    address user,
+    DelegationState memory delegationState
+  ) internal override {
+    DelegationAwareBalance storage userState = _balances[user];
+    userState.delegatedPropositionBalance = delegationState
+      .delegatedPropositionBalance;
+    userState.delegatedVotingBalance = delegationState.delegatedVotingBalance;
+    userState.delegationMode = delegationState.delegationMode;
+  }
+
+  function _incrementNonces(address user) internal override returns (uint256) {
+    unchecked {
+      // Does not make sense to check because it's not realistic to reach uint256.max in nonce
+      return _nonces[user]++;
+    }
+  }
+
+  function _getDomainSeparator() internal view override returns (bytes32) {
+    return DOMAIN_SEPARATOR;
+  }
 }
```
