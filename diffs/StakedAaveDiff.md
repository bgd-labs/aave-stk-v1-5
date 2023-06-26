```diff
diff --git a/src/flattened/CurrentStakedAaveV3Flattened.sol b/src/flattened/StakedAaveV3Flattened.sol
index 12d5367..fc5e5da 100644
--- a/src/flattened/CurrentStakedAaveV3Flattened.sol
+++ b/src/flattened/StakedAaveV3Flattened.sol
@@ -98,8 +98,6 @@ library DistributionTypes {
   }
 }
 
-// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
-
 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
 
 /**
@@ -124,838 +122,6 @@ interface IERC20Metadata is IERC20 {
   function decimals() external view returns (uint8);
 }
 
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
-/**
- * @notice implementation of the AAVE token contract
- * @author Aave
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
-  struct Snapshot {
-    uint128 blockNumber;
-    uint128 value;
-  }
-
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
-  }
-
-  /**
-   * @dev delegates all the powers to a specific user
-   * @param delegatee the user to which the power will be delegated
-   **/
-  function delegate(address delegatee) external override {
-    _delegateByType(msg.sender, delegatee, DelegationType.VOTING_POWER);
-    _delegateByType(msg.sender, delegatee, DelegationType.PROPOSITION_POWER);
-  }
-
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
-  }
-
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
-
-    ) = _getDelegationDataByType(delegationType);
-
-    return _searchByBlockNumber(snapshots, snapshotsCounts, user, block.number);
-  }
-
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
-
-  /**
-   * @dev returns the total supply at a certain block number
-   * used by the voting strategy contracts to calculate the total votes needed for threshold/quorum
-   * In this initial implementation with no AAVE minting, simply returns the current supply
-   * A snapshots mapping will need to be added in case a mint function is added to the AAVE token in the future
-   **/
-  function totalSupplyAt(uint256) external view override returns (uint256) {
-    return super.totalSupply();
-  }
-
-  /**
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
-  }
-
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
-
-    (
-      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-      mapping(address => uint256) storage snapshotsCounts,
-
-    ) = _getDelegationDataByType(delegationType);
-
-    if (from != address(0)) {
-      uint256 previous = 0;
-      uint256 fromSnapshotsCount = snapshotsCounts[from];
-
-      if (fromSnapshotsCount != 0) {
-        previous = snapshots[from][fromSnapshotsCount - 1].value;
-      } else {
-        previous = balanceOf(from);
-      }
-
-      _writeSnapshot(
-        snapshots,
-        snapshotsCounts,
-        from,
-        uint128(previous),
-        uint128(previous - amount)
-      );
-
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
-
-      _writeSnapshot(
-        snapshots,
-        snapshotsCounts,
-        to,
-        uint128(previous),
-        uint128(previous + amount)
-      );
-
-      emit DelegatedPowerChanged(to, previous + amount, delegationType);
-    }
-  }
-
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
-
-    // Check implicit zero balance
-    if (snapshots[user][0].blockNumber > blockNumber) {
-      return 0;
-    }
-
-    return _binarySearch(snapshots[user], snapshotsCount, blockNumber);
-  }
-
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
-
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
-      }
-      return snapshots[lower].value;
-    }
-  }
-
-  /**
-   * @dev returns the delegation data (snapshot, snapshotsCount, list of delegates) by delegation type
-   * NOTE: Ideal implementation would have mapped this in a struct by delegation type. Unfortunately,
-   * the AAVE token and StakeToken already include a mapping for the snapshots, so we require contracts
-   * who inherit from this to provide access to the delegation data by overriding this method.
-   * @param delegationType the type of delegation
-   **/
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
-
-  /**
-   * @dev Writes a snapshot for an owner of tokens
-   * @param owner The owner of the tokens
-   * @param oldValue The value before the operation that is gonna be executed after the snapshot
-   * @param newValue The value after the operation
-   */
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
-  }
-
-  /**
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
-    }
-
-    return previousDelegatee;
-  }
-}
-
 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
 
 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
@@ -1419,6 +585,1235 @@ interface IStakedTokenV2 {
   ) external;
 }
 
+// Contract modified from OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol) to remove local
+// fallback storage variables, so contract does not affect on existing storage layout. This works as its used on contracts
+// that have name and revision < 32 bytes
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
+
+/**
+ * @dev Standard math utilities missing in the Solidity language.
+ */
+library Math {
+  enum Rounding {
+    Down, // Toward negative infinity
+    Up, // Toward infinity
+    Zero // Toward zero
+  }
+
+  /**
+   * @dev Returns the largest of two numbers.
+   */
+  function max(uint256 a, uint256 b) internal pure returns (uint256) {
+    return a > b ? a : b;
+  }
+
+  /**
+   * @dev Returns the smallest of two numbers.
+   */
+  function min(uint256 a, uint256 b) internal pure returns (uint256) {
+    return a < b ? a : b;
+  }
+
+  /**
+   * @dev Returns the average of two numbers. The result is rounded towards
+   * zero.
+   */
+  function average(uint256 a, uint256 b) internal pure returns (uint256) {
+    // (a + b) / 2 can overflow.
+    return (a & b) + (a ^ b) / 2;
+  }
+
+  /**
+   * @dev Returns the ceiling of the division of two numbers.
+   *
+   * This differs from standard division with `/` in that it rounds up instead
+   * of rounding down.
+   */
+  function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
+    // (a + b - 1) / b can overflow on addition, so we distribute.
+    return a == 0 ? 0 : (a - 1) / b + 1;
+  }
+
+  /**
+   * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
+   * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
+   * with further edits by Uniswap Labs also under MIT license.
+   */
+  function mulDiv(
+    uint256 x,
+    uint256 y,
+    uint256 denominator
+  ) internal pure returns (uint256 result) {
+    unchecked {
+      // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
+      // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
+      // variables such that product = prod1 * 2^256 + prod0.
+      uint256 prod0; // Least significant 256 bits of the product
+      uint256 prod1; // Most significant 256 bits of the product
+      assembly {
+        let mm := mulmod(x, y, not(0))
+        prod0 := mul(x, y)
+        prod1 := sub(sub(mm, prod0), lt(mm, prod0))
+      }
+
+      // Handle non-overflow cases, 256 by 256 division.
+      if (prod1 == 0) {
+        // Solidity will revert if denominator == 0, unlike the div opcode on its own.
+        // The surrounding unchecked block does not change this fact.
+        // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
+        return prod0 / denominator;
+      }
+
+      // Make sure the result is less than 2^256. Also prevents denominator == 0.
+      require(denominator > prod1, 'Math: mulDiv overflow');
+
+      ///////////////////////////////////////////////
+      // 512 by 256 division.
+      ///////////////////////////////////////////////
+
+      // Make division exact by subtracting the remainder from [prod1 prod0].
+      uint256 remainder;
+      assembly {
+        // Compute remainder using mulmod.
+        remainder := mulmod(x, y, denominator)
+
+        // Subtract 256 bit number from 512 bit number.
+        prod1 := sub(prod1, gt(remainder, prod0))
+        prod0 := sub(prod0, remainder)
+      }
+
+      // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
+      // See https://cs.stackexchange.com/q/138556/92363.
+
+      // Does not overflow because the denominator cannot be zero at this stage in the function.
+      uint256 twos = denominator & (~denominator + 1);
+      assembly {
+        // Divide denominator by twos.
+        denominator := div(denominator, twos)
+
+        // Divide [prod1 prod0] by twos.
+        prod0 := div(prod0, twos)
+
+        // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
+        twos := add(div(sub(0, twos), twos), 1)
+      }
+
+      // Shift in bits from prod1 into prod0.
+      prod0 |= prod1 * twos;
+
+      // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
+      // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
+      // four bits. That is, denominator * inv = 1 mod 2^4.
+      uint256 inverse = (3 * denominator) ^ 2;
+
+      // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
+      // in modular arithmetic, doubling the correct bits in each step.
+      inverse *= 2 - denominator * inverse; // inverse mod 2^8
+      inverse *= 2 - denominator * inverse; // inverse mod 2^16
+      inverse *= 2 - denominator * inverse; // inverse mod 2^32
+      inverse *= 2 - denominator * inverse; // inverse mod 2^64
+      inverse *= 2 - denominator * inverse; // inverse mod 2^128
+      inverse *= 2 - denominator * inverse; // inverse mod 2^256
+
+      // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
+      // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
+      // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
+      // is no longer required.
+      result = prod0 * inverse;
+      return result;
+    }
+  }
+
+  /**
+   * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
+   */
+  function mulDiv(
+    uint256 x,
+    uint256 y,
+    uint256 denominator,
+    Rounding rounding
+  ) internal pure returns (uint256) {
+    uint256 result = mulDiv(x, y, denominator);
+    if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
+      result += 1;
+    }
+    return result;
+  }
+
+  /**
+   * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
+   *
+   * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
+   */
+  function sqrt(uint256 a) internal pure returns (uint256) {
+    if (a == 0) {
+      return 0;
+    }
+
+    // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
+    //
+    // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
+    // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
+    //
+    // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
+    // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
+    // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
+    //
+    // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
+    uint256 result = 1 << (log2(a) >> 1);
+
+    // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
+    // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
+    // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
+    // into the expected uint128 result.
+    unchecked {
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      result = (result + a / result) >> 1;
+      return min(result, a / result);
+    }
+  }
+
+  /**
+   * @notice Calculates sqrt(a), following the selected rounding direction.
+   */
+  function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
+    unchecked {
+      uint256 result = sqrt(a);
+      return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
+    }
+  }
+
+  /**
+   * @dev Return the log in base 2, rounded down, of a positive value.
+   * Returns 0 if given 0.
+   */
+  function log2(uint256 value) internal pure returns (uint256) {
+    uint256 result = 0;
+    unchecked {
+      if (value >> 128 > 0) {
+        value >>= 128;
+        result += 128;
+      }
+      if (value >> 64 > 0) {
+        value >>= 64;
+        result += 64;
+      }
+      if (value >> 32 > 0) {
+        value >>= 32;
+        result += 32;
+      }
+      if (value >> 16 > 0) {
+        value >>= 16;
+        result += 16;
+      }
+      if (value >> 8 > 0) {
+        value >>= 8;
+        result += 8;
+      }
+      if (value >> 4 > 0) {
+        value >>= 4;
+        result += 4;
+      }
+      if (value >> 2 > 0) {
+        value >>= 2;
+        result += 2;
+      }
+      if (value >> 1 > 0) {
+        result += 1;
+      }
+    }
+    return result;
+  }
+
+  /**
+   * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
+   * Returns 0 if given 0.
+   */
+  function log2(
+    uint256 value,
+    Rounding rounding
+  ) internal pure returns (uint256) {
+    unchecked {
+      uint256 result = log2(value);
+      return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
+    }
+  }
+
+  /**
+   * @dev Return the log in base 10, rounded down, of a positive value.
+   * Returns 0 if given 0.
+   */
+  function log10(uint256 value) internal pure returns (uint256) {
+    uint256 result = 0;
+    unchecked {
+      if (value >= 10 ** 64) {
+        value /= 10 ** 64;
+        result += 64;
+      }
+      if (value >= 10 ** 32) {
+        value /= 10 ** 32;
+        result += 32;
+      }
+      if (value >= 10 ** 16) {
+        value /= 10 ** 16;
+        result += 16;
+      }
+      if (value >= 10 ** 8) {
+        value /= 10 ** 8;
+        result += 8;
+      }
+      if (value >= 10 ** 4) {
+        value /= 10 ** 4;
+        result += 4;
+      }
+      if (value >= 10 ** 2) {
+        value /= 10 ** 2;
+        result += 2;
+      }
+      if (value >= 10 ** 1) {
+        result += 1;
+      }
+    }
+    return result;
+  }
+
+  /**
+   * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
+   * Returns 0 if given 0.
+   */
+  function log10(
+    uint256 value,
+    Rounding rounding
+  ) internal pure returns (uint256) {
+    unchecked {
+      uint256 result = log10(value);
+      return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
+    }
+  }
+
+  /**
+   * @dev Return the log in base 256, rounded down, of a positive value.
+   * Returns 0 if given 0.
+   *
+   * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
+   */
+  function log256(uint256 value) internal pure returns (uint256) {
+    uint256 result = 0;
+    unchecked {
+      if (value >> 128 > 0) {
+        value >>= 128;
+        result += 16;
+      }
+      if (value >> 64 > 0) {
+        value >>= 64;
+        result += 8;
+      }
+      if (value >> 32 > 0) {
+        value >>= 32;
+        result += 4;
+      }
+      if (value >> 16 > 0) {
+        value >>= 16;
+        result += 2;
+      }
+      if (value >> 8 > 0) {
+        result += 1;
+      }
+    }
+    return result;
+  }
+
+  /**
+   * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
+   * Returns 0 if given 0.
+   */
+  function log256(
+    uint256 value,
+    Rounding rounding
+  ) internal pure returns (uint256) {
+    unchecked {
+      uint256 result = log256(value);
+      return
+        result +
+        (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
+    }
+  }
+}
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
+
+/**
+ * @dev Standard signed math utilities missing in the Solidity language.
+ */
+library SignedMath {
+  /**
+   * @dev Returns the largest of two signed numbers.
+   */
+  function max(int256 a, int256 b) internal pure returns (int256) {
+    return a > b ? a : b;
+  }
+
+  /**
+   * @dev Returns the smallest of two signed numbers.
+   */
+  function min(int256 a, int256 b) internal pure returns (int256) {
+    return a < b ? a : b;
+  }
+
+  /**
+   * @dev Returns the average of two signed numbers without overflow.
+   * The result is rounded towards zero.
+   */
+  function average(int256 a, int256 b) internal pure returns (int256) {
+    // Formula from the book "Hacker's Delight"
+    int256 x = (a & b) + ((a ^ b) >> 1);
+    return x + (int256(uint256(x) >> 255) & (a ^ b));
+  }
+
+  /**
+   * @dev Returns the absolute unsigned value of a signed value.
+   */
+  function abs(int256 n) internal pure returns (uint256) {
+    unchecked {
+      // must be unchecked in order to support `n = type(int256).min`
+      return uint256(n >= 0 ? n : -n);
+    }
+  }
+}
+
+/**
+ * @dev String operations.
+ */
+library Strings {
+  bytes16 private constant _SYMBOLS = '0123456789abcdef';
+  uint8 private constant _ADDRESS_LENGTH = 20;
+
+  /**
+   * @dev Converts a `uint256` to its ASCII `string` decimal representation.
+   */
+  function toString(uint256 value) internal pure returns (string memory) {
+    unchecked {
+      uint256 length = Math.log10(value) + 1;
+      string memory buffer = new string(length);
+      uint256 ptr;
+      /// @solidity memory-safe-assembly
+      assembly {
+        ptr := add(buffer, add(32, length))
+      }
+      while (true) {
+        ptr--;
+        /// @solidity memory-safe-assembly
+        assembly {
+          mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
+        }
+        value /= 10;
+        if (value == 0) break;
+      }
+      return buffer;
+    }
+  }
+
+  /**
+   * @dev Converts a `int256` to its ASCII `string` decimal representation.
+   */
+  function toString(int256 value) internal pure returns (string memory) {
+    return
+      string(
+        abi.encodePacked(value < 0 ? '-' : '', toString(SignedMath.abs(value)))
+      );
+  }
+
+  /**
+   * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
+   */
+  function toHexString(uint256 value) internal pure returns (string memory) {
+    unchecked {
+      return toHexString(value, Math.log256(value) + 1);
+    }
+  }
+
+  /**
+   * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
+   */
+  function toHexString(
+    uint256 value,
+    uint256 length
+  ) internal pure returns (string memory) {
+    bytes memory buffer = new bytes(2 * length + 2);
+    buffer[0] = '0';
+    buffer[1] = 'x';
+    for (uint256 i = 2 * length + 1; i > 1; --i) {
+      buffer[i] = _SYMBOLS[value & 0xf];
+      value >>= 4;
+    }
+    require(value == 0, 'Strings: hex length insufficient');
+    return string(buffer);
+  }
+
+  /**
+   * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
+   */
+  function toHexString(address addr) internal pure returns (string memory) {
+    return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
+  }
+
+  /**
+   * @dev Returns true if the two strings are equal.
+   */
+  function equal(
+    string memory a,
+    string memory b
+  ) internal pure returns (bool) {
+    return keccak256(bytes(a)) == keccak256(bytes(b));
+  }
+}
+
+/**
+ * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
+ *
+ * These functions can be used to verify that a message was signed by the holder
+ * of the private keys of a given address.
+ */
+library ECDSA {
+  enum RecoverError {
+    NoError,
+    InvalidSignature,
+    InvalidSignatureLength,
+    InvalidSignatureS,
+    InvalidSignatureV // Deprecated in v4.8
+  }
+
+  function _throwError(RecoverError error) private pure {
+    if (error == RecoverError.NoError) {
+      return; // no error: do nothing
+    } else if (error == RecoverError.InvalidSignature) {
+      revert('ECDSA: invalid signature');
+    } else if (error == RecoverError.InvalidSignatureLength) {
+      revert('ECDSA: invalid signature length');
+    } else if (error == RecoverError.InvalidSignatureS) {
+      revert("ECDSA: invalid signature 's' value");
+    }
+  }
+
+  /**
+   * @dev Returns the address that signed a hashed message (`hash`) with
+   * `signature` or error string. This address can then be used for verification purposes.
+   *
+   * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
+   * this function rejects them by requiring the `s` value to be in the lower
+   * half order, and the `v` value to be either 27 or 28.
+   *
+   * IMPORTANT: `hash` _must_ be the result of a hash operation for the
+   * verification to be secure: it is possible to craft signatures that
+   * recover to arbitrary addresses for non-hashed data. A safe way to ensure
+   * this is by receiving a hash of the original message (which may otherwise
+   * be too long), and then calling {toEthSignedMessageHash} on it.
+   *
+   * Documentation for signature generation:
+   * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
+   * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
+   *
+   * _Available since v4.3._
+   */
+  function tryRecover(
+    bytes32 hash,
+    bytes memory signature
+  ) internal pure returns (address, RecoverError) {
+    if (signature.length == 65) {
+      bytes32 r;
+      bytes32 s;
+      uint8 v;
+      // ecrecover takes the signature parameters, and the only way to get them
+      // currently is to use assembly.
+      /// @solidity memory-safe-assembly
+      assembly {
+        r := mload(add(signature, 0x20))
+        s := mload(add(signature, 0x40))
+        v := byte(0, mload(add(signature, 0x60)))
+      }
+      return tryRecover(hash, v, r, s);
+    } else {
+      return (address(0), RecoverError.InvalidSignatureLength);
+    }
+  }
+
+  /**
+   * @dev Returns the address that signed a hashed message (`hash`) with
+   * `signature`. This address can then be used for verification purposes.
+   *
+   * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
+   * this function rejects them by requiring the `s` value to be in the lower
+   * half order, and the `v` value to be either 27 or 28.
+   *
+   * IMPORTANT: `hash` _must_ be the result of a hash operation for the
+   * verification to be secure: it is possible to craft signatures that
+   * recover to arbitrary addresses for non-hashed data. A safe way to ensure
+   * this is by receiving a hash of the original message (which may otherwise
+   * be too long), and then calling {toEthSignedMessageHash} on it.
+   */
+  function recover(
+    bytes32 hash,
+    bytes memory signature
+  ) internal pure returns (address) {
+    (address recovered, RecoverError error) = tryRecover(hash, signature);
+    _throwError(error);
+    return recovered;
+  }
+
+  /**
+   * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
+   *
+   * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
+   *
+   * _Available since v4.3._
+   */
+  function tryRecover(
+    bytes32 hash,
+    bytes32 r,
+    bytes32 vs
+  ) internal pure returns (address, RecoverError) {
+    bytes32 s = vs &
+      bytes32(
+        0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
+      );
+    uint8 v = uint8((uint256(vs) >> 255) + 27);
+    return tryRecover(hash, v, r, s);
+  }
+
+  /**
+   * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
+   *
+   * _Available since v4.2._
+   */
+  function recover(
+    bytes32 hash,
+    bytes32 r,
+    bytes32 vs
+  ) internal pure returns (address) {
+    (address recovered, RecoverError error) = tryRecover(hash, r, vs);
+    _throwError(error);
+    return recovered;
+  }
+
+  /**
+   * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
+   * `r` and `s` signature fields separately.
+   *
+   * _Available since v4.3._
+   */
+  function tryRecover(
+    bytes32 hash,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) internal pure returns (address, RecoverError) {
+    // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
+    // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
+    // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
+    // signatures from current libraries generate a unique signature with an s-value in the lower half order.
+    //
+    // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
+    // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
+    // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
+    // these malleable signatures as well.
+    if (
+      uint256(s) >
+      0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
+    ) {
+      return (address(0), RecoverError.InvalidSignatureS);
+    }
+
+    // If the signature is valid (and not malleable), return the signer address
+    address signer = ecrecover(hash, v, r, s);
+    if (signer == address(0)) {
+      return (address(0), RecoverError.InvalidSignature);
+    }
+
+    return (signer, RecoverError.NoError);
+  }
+
+  /**
+   * @dev Overload of {ECDSA-recover} that receives the `v`,
+   * `r` and `s` signature fields separately.
+   */
+  function recover(
+    bytes32 hash,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) internal pure returns (address) {
+    (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
+    _throwError(error);
+    return recovered;
+  }
+
+  /**
+   * @dev Returns an Ethereum Signed Message, created from a `hash`. This
+   * produces hash corresponding to the one signed with the
+   * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
+   * JSON-RPC method as part of EIP-191.
+   *
+   * See {recover}.
+   */
+  function toEthSignedMessageHash(
+    bytes32 hash
+  ) internal pure returns (bytes32 message) {
+    // 32 is the length in bytes of hash,
+    // enforced by the type signature above
+    /// @solidity memory-safe-assembly
+    assembly {
+      mstore(0x00, '\x19Ethereum Signed Message:\n32')
+      mstore(0x1c, hash)
+      message := keccak256(0x00, 0x3c)
+    }
+  }
+
+  /**
+   * @dev Returns an Ethereum Signed Message, created from `s`. This
+   * produces hash corresponding to the one signed with the
+   * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
+   * JSON-RPC method as part of EIP-191.
+   *
+   * See {recover}.
+   */
+  function toEthSignedMessageHash(
+    bytes memory s
+  ) internal pure returns (bytes32) {
+    return
+      keccak256(
+        abi.encodePacked(
+          '\x19Ethereum Signed Message:\n',
+          Strings.toString(s.length),
+          s
+        )
+      );
+  }
+
+  /**
+   * @dev Returns an Ethereum Signed Typed Data, created from a
+   * `domainSeparator` and a `structHash`. This produces hash corresponding
+   * to the one signed with the
+   * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
+   * JSON-RPC method as part of EIP-712.
+   *
+   * See {recover}.
+   */
+  function toTypedDataHash(
+    bytes32 domainSeparator,
+    bytes32 structHash
+  ) internal pure returns (bytes32 data) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      let ptr := mload(0x40)
+      mstore(ptr, '\x19\x01')
+      mstore(add(ptr, 0x02), domainSeparator)
+      mstore(add(ptr, 0x22), structHash)
+      data := keccak256(ptr, 0x42)
+    }
+  }
+
+  /**
+   * @dev Returns an Ethereum Signed Data with intended validator, created from a
+   * `validator` and `data` according to the version 0 of EIP-191.
+   *
+   * See {recover}.
+   */
+  function toDataWithIntendedValidatorHash(
+    address validator,
+    bytes memory data
+  ) internal pure returns (bytes32) {
+    return keccak256(abi.encodePacked('\x19\x00', validator, data));
+  }
+}
+
+// OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
+// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
+
+/**
+ * @dev Library for reading and writing primitive types to specific storage slots.
+ *
+ * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
+ * This library helps with reading and writing to such slots without the need for inline assembly.
+ *
+ * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
+ *
+ * Example usage to set ERC1967 implementation slot:
+ * ```solidity
+ * contract ERC1967 {
+ *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
+ *
+ *     function _getImplementation() internal view returns (address) {
+ *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
+ *     }
+ *
+ *     function _setImplementation(address newImplementation) internal {
+ *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
+ *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
+ *     }
+ * }
+ * ```
+ *
+ * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
+ * _Available since v4.9 for `string`, `bytes`._
+ */
+library StorageSlot {
+  struct AddressSlot {
+    address value;
+  }
+
+  struct BooleanSlot {
+    bool value;
+  }
+
+  struct Bytes32Slot {
+    bytes32 value;
+  }
+
+  struct Uint256Slot {
+    uint256 value;
+  }
+
+  struct StringSlot {
+    string value;
+  }
+
+  struct BytesSlot {
+    bytes value;
+  }
+
+  /**
+   * @dev Returns an `AddressSlot` with member `value` located at `slot`.
+   */
+  function getAddressSlot(
+    bytes32 slot
+  ) internal pure returns (AddressSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
+   */
+  function getBooleanSlot(
+    bytes32 slot
+  ) internal pure returns (BooleanSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
+   */
+  function getBytes32Slot(
+    bytes32 slot
+  ) internal pure returns (Bytes32Slot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
+   */
+  function getUint256Slot(
+    bytes32 slot
+  ) internal pure returns (Uint256Slot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `StringSlot` with member `value` located at `slot`.
+   */
+  function getStringSlot(
+    bytes32 slot
+  ) internal pure returns (StringSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
+   */
+  function getStringSlot(
+    string storage store
+  ) internal pure returns (StringSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := store.slot
+    }
+  }
+
+  /**
+   * @dev Returns an `BytesSlot` with member `value` located at `slot`.
+   */
+  function getBytesSlot(
+    bytes32 slot
+  ) internal pure returns (BytesSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := slot
+    }
+  }
+
+  /**
+   * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
+   */
+  function getBytesSlot(
+    bytes storage store
+  ) internal pure returns (BytesSlot storage r) {
+    /// @solidity memory-safe-assembly
+    assembly {
+      r.slot := store.slot
+    }
+  }
+}
+
+// | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
+// | length  | 0x                                                              BB |
+type ShortString is bytes32;
+
+/**
+ * @dev This library provides functions to convert short memory strings
+ * into a `ShortString` type that can be used as an immutable variable.
+ *
+ * Strings of arbitrary length can be optimized using this library if
+ * they are short enough (up to 31 bytes) by packing them with their
+ * length (1 byte) in a single EVM word (32 bytes). Additionally, a
+ * fallback mechanism can be used for every other case.
+ *
+ * Usage example:
+ *
+ * ```solidity
+ * contract Named {
+ *     using ShortStrings for *;
+ *
+ *     ShortString private immutable _name;
+ *     string private _nameFallback;
+ *
+ *     constructor(string memory contractName) {
+ *         _name = contractName.toShortStringWithFallback(_nameFallback);
+ *     }
+ *
+ *     function name() external view returns (string memory) {
+ *         return _name.toStringWithFallback(_nameFallback);
+ *     }
+ * }
+ * ```
+ */
+library ShortStrings {
+  // Used as an identifier for strings longer than 31 bytes.
+  bytes32 private constant _FALLBACK_SENTINEL =
+    0x00000000000000000000000000000000000000000000000000000000000000FF;
+
+  error StringTooLong(string str);
+  error InvalidShortString();
+
+  /**
+   * @dev Encode a string of at most 31 chars into a `ShortString`.
+   *
+   * This will trigger a `StringTooLong` error is the input string is too long.
+   */
+  function toShortString(
+    string memory str
+  ) internal pure returns (ShortString) {
+    bytes memory bstr = bytes(str);
+    if (bstr.length > 31) {
+      revert StringTooLong(str);
+    }
+    return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
+  }
+
+  /**
+   * @dev Decode a `ShortString` back to a "normal" string.
+   */
+  function toString(ShortString sstr) internal pure returns (string memory) {
+    uint256 len = byteLength(sstr);
+    // using `new string(len)` would work locally but is not memory safe.
+    string memory str = new string(32);
+    /// @solidity memory-safe-assembly
+    assembly {
+      mstore(str, len)
+      mstore(add(str, 0x20), sstr)
+    }
+    return str;
+  }
+
+  /**
+   * @dev Return the length of a `ShortString`.
+   */
+  function byteLength(ShortString sstr) internal pure returns (uint256) {
+    uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
+    if (result > 31) {
+      revert InvalidShortString();
+    }
+    return result;
+  }
+
+  /**
+   * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
+   */
+  function toShortStringWithFallback(
+    string memory value,
+    string storage store
+  ) internal returns (ShortString) {
+    if (bytes(value).length < 32) {
+      return toShortString(value);
+    } else {
+      StorageSlot.getStringSlot(store).value = value;
+      return ShortString.wrap(_FALLBACK_SENTINEL);
+    }
+  }
+
+  /**
+   * @dev Decode a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
+   */
+  function toStringWithFallback(
+    ShortString value,
+    string storage store
+  ) internal pure returns (string memory) {
+    if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
+      return toString(value);
+    } else {
+      return store;
+    }
+  }
+
+  /**
+   * @dev Return the length of a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
+   *
+   * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
+   * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
+   */
+  function byteLengthWithFallback(
+    ShortString value,
+    string storage store
+  ) internal view returns (uint256) {
+    if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
+      return byteLength(value);
+    } else {
+      return bytes(store).length;
+    }
+  }
+}
+
+interface IERC5267 {
+  /**
+   * @dev MAY be emitted to signal that the domain could have changed.
+   */
+  event EIP712DomainChanged();
+
+  /**
+   * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
+   * signature.
+   */
+  function eip712Domain()
+    external
+    view
+    returns (
+      bytes1 fields,
+      string memory name,
+      string memory version,
+      uint256 chainId,
+      address verifyingContract,
+      bytes32 salt,
+      uint256[] memory extensions
+    );
+}
+
+/**
+ * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
+ *
+ * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
+ * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
+ * they need in their contracts using a combination of `abi.encode` and `keccak256`.
+ *
+ * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
+ * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
+ * ({_hashTypedDataV4}).
+ *
+ * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
+ * the chain id to protect against replay attacks on an eventual fork of the chain.
+ *
+ * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
+ * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
+ *
+ * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
+ * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
+ * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
+ *
+ * _Available since v3.4._
+ *
+ * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
+ */
+abstract contract EIP712 is IERC5267 {
+  using ShortStrings for *;
+
+  bytes32 private constant _TYPE_HASH =
+    keccak256(
+      'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
+    );
+
+  // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
+  // invalidate the cached domain separator if the chain id changes.
+  bytes32 private immutable _cachedDomainSeparator;
+  uint256 private immutable _cachedChainId;
+  address private immutable _cachedThis;
+
+  bytes32 private immutable _hashedName;
+  bytes32 private immutable _hashedVersion;
+
+  ShortString private immutable _name;
+  ShortString private immutable _version;
+
+  /**
+   * @dev Initializes the domain separator and parameter caches.
+   *
+   * The meaning of `name` and `version` is specified in
+   * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
+   *
+   * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
+   * - `version`: the current major version of the signing domain.
+   *
+   * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
+   * contract upgrade].
+   */
+  /// @dev BGD: removed usage of fallback variables to not modify previous storage layout. As we know that the length of
+  ///           name and version will not be bigger than 32 bytes we use toShortString as there is no need to use the fallback system.
+  constructor(string memory name, string memory version) {
+    _name = name.toShortString();
+    _version = version.toShortString();
+    _hashedName = keccak256(bytes(name));
+    _hashedVersion = keccak256(bytes(version));
+
+    _cachedChainId = block.chainid;
+    _cachedDomainSeparator = _buildDomainSeparator();
+    _cachedThis = address(this);
+  }
+
+  /**
+   * @dev Returns the domain separator for the current chain.
+   */
+  function _domainSeparatorV4() internal view returns (bytes32) {
+    if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
+      return _cachedDomainSeparator;
+    } else {
+      return _buildDomainSeparator();
+    }
+  }
+
+  function _buildDomainSeparator() private view returns (bytes32) {
+    return
+      keccak256(
+        abi.encode(
+          _TYPE_HASH,
+          _hashedName,
+          _hashedVersion,
+          block.chainid,
+          address(this)
+        )
+      );
+  }
+
+  /**
+   * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
+   * function returns the hash of the fully encoded EIP712 message for this domain.
+   *
+   * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
+   *
+   * ```solidity
+   * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
+   *     keccak256("Mail(address to,string contents)"),
+   *     mailTo,
+   *     keccak256(bytes(mailContents))
+   * )));
+   * address signer = ECDSA.recover(digest, signature);
+   * ```
+   */
+  function _hashTypedDataV4(
+    bytes32 structHash
+  ) internal view virtual returns (bytes32) {
+    return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
+  }
+
+  /**
+   * @dev See {EIP-5267}.
+   *
+   * _Available since v4.9._
+   */
+  function eip712Domain()
+    public
+    view
+    virtual
+    returns (
+      bytes1 fields,
+      string memory name,
+      string memory version,
+      uint256 chainId,
+      address verifyingContract,
+      bytes32 salt,
+      uint256[] memory extensions
+    )
+  {
+    return (
+      hex'0f', // 01111
+      _EIP712Name(),
+      _EIP712Version(),
+      block.chainid,
+      address(this),
+      bytes32(0),
+      new uint256[](0)
+    );
+  }
+
+  /**
+   * @dev The name parameter for the EIP712 domain.
+   *
+   * NOTE: By default this function reads _name which is an immutable value.
+   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
+   *
+   * _Available since v5.0._
+   */
+  /// @dev BGD: we use toString instead of toStringWithFallback as we dont have fallback, to not modify previous storage layout
+  // solhint-disable-next-line func-name-mixedcase
+  function _EIP712Name() internal view returns (string memory) {
+    return _name.toString(); // _name.toStringWithFallback(_nameFallback);
+  }
+
+  /**
+   * @dev The version parameter for the EIP712 domain.
+   *
+   * NOTE: By default this function reads _version which is an immutable value.
+   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
+   *
+   * _Available since v5.0._
+   */
+  /// @dev BGD: we use toString instead of toStringWithFallback as we dont have fallback, to not modify previous storage layout
+  // solhint-disable-next-line func-name-mixedcase
+  function _EIP712Version() internal view returns (string memory) {
+    return _version.toString();
+  }
+}
+
 /**
  * @title VersionedInitializable
  *
@@ -1721,23 +2116,325 @@ interface ITransferHook {
  * @notice ERC20 including snapshots of balances on transfer-related actions
  * @author Aave
  **/
-abstract contract GovernancePowerWithSnapshot is
-  GovernancePowerDelegationERC20
-{
+abstract contract GovernancePowerWithSnapshot {
+  struct Snapshot {
+    uint128 blockNumber;
+    uint128 value;
+  }
+  /// @dev DEPRECATED
+  mapping(address => mapping(uint256 => Snapshot))
+    public deprecated_votingSnapshots;
+  /// @dev DEPRECATED
+  mapping(address => uint256) public deprecated_votingSnapshotsCounts;
+  /// @dev DEPRECATED
+  ITransferHook public deprecated_aaveGovernance;
+}
+
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
+  }
+
+  function _msgData() internal view virtual returns (bytes calldata) {
+    return msg.data;
+  }
+}
+
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
+  }
+
+  mapping(address => DelegationAwareBalance) internal _balances;
+
+  mapping(address => mapping(address => uint256)) internal _allowances;
+
+  uint256 internal _totalSupply;
+
+  string internal _name;
+  string internal _symbol;
+
+  // @dev DEPRECATED
+  // kept for backwards compatibility with old storage layout
+  uint8 private ______DEPRECATED_OLD_ERC20_DECIMALS;
+
   /**
-   * @dev The following storage layout points to the prior StakedToken.sol implementation:
-   * _snapshots => _votingSnapshots
-   * _snapshotsCounts =>  _votingSnapshotsCounts
-   * _aaveGovernance => _aaveGovernance
+   * @dev Returns the name of the token.
    */
-  mapping(address => mapping(uint256 => Snapshot)) public _votingSnapshots;
-  mapping(address => uint256) public _votingSnapshotsCounts;
+  function name() public view virtual override returns (string memory) {
+    return _name;
+  }
 
-  /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
-  /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
-  /// to control all potential reentrancies by calling back the this contract
-  /// @dev DEPRECATED
-  ITransferHook public _aaveGovernance;
+  /**
+   * @dev Returns the symbol of the token, usually a shorter version of the
+   * name.
+   */
+  function symbol() public view virtual override returns (string memory) {
+    return _symbol;
+  }
+
+  function decimals() public view virtual override returns (uint8) {
+    return 18;
+  }
+
+  function totalSupply() public view virtual override returns (uint256) {
+    return _totalSupply;
+  }
+
+  function balanceOf(
+    address account
+  ) public view virtual override returns (uint256) {
+    return _balances[account].balance;
+  }
+
+  function transfer(
+    address to,
+    uint256 amount
+  ) public virtual override returns (bool) {
+    address owner = _msgSender();
+    _transfer(owner, to, amount);
+    return true;
+  }
+
+  function allowance(
+    address owner,
+    address spender
+  ) public view virtual override returns (uint256) {
+    return _allowances[owner][spender];
+  }
+
+  function approve(
+    address spender,
+    uint256 amount
+  ) public virtual override returns (bool) {
+    address owner = _msgSender();
+    _approve(owner, spender, amount);
+    return true;
+  }
+
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
+
+  function increaseAllowance(
+    address spender,
+    uint256 addedValue
+  ) public virtual returns (bool) {
+    address owner = _msgSender();
+    _approve(owner, spender, _allowances[owner][spender] + addedValue);
+    return true;
+  }
+
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
+    }
+
+    return true;
+  }
+
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
+
+    require(
+      fromBalanceBefore >= amount,
+      'ERC20: transfer amount exceeds balance'
+    );
+    unchecked {
+      _balances[from].balance = fromBalanceBefore - uint104(amount);
+    }
+
+    _balances[to].balance = toBalanceBefore + uint104(amount);
+
+    _afterTokenTransfer(from, to, fromBalanceBefore, toBalanceBefore, amount);
+    emit Transfer(from, to, amount);
+  }
+
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
+
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
+      }
+    }
+  }
+
+  /**
+   * @dev after token transfer hook, added for delegation system
+   * @param from token sender
+   * @param to token recipient
+   * @param fromBalanceBefore balance of the sender before transfer
+   * @param toBalanceBefore balance of the recipient before transfer
+   * @param amount amount of tokens sent
+   **/
+  function _afterTokenTransfer(
+    address from,
+    address to,
+    uint256 fromBalanceBefore,
+    uint256 toBalanceBefore,
+    uint256 amount
+  ) internal virtual {}
+}
+
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
+   */
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
+  }
+
+  /**
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
+    }
+
+    emit Transfer(account, address(0), amount);
+
+    _afterTokenTransfer(account, address(0), amount);
+  }
+
+  /**
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
+   */
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal virtual {}
+
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
@@ -1747,9 +2444,11 @@ abstract contract GovernancePowerWithSnapshot is
  */
 abstract contract StakedTokenV2 is
   IStakedTokenV2,
+  BaseMintableAaveToken,
   GovernancePowerWithSnapshot,
   VersionedInitializable,
-  AaveDistributionManager
+  AaveDistributionManager,
+  EIP712
 {
   using SafeERC20 for IERC20;
 
@@ -1771,16 +2470,13 @@ abstract contract StakedTokenV2 is
   mapping(address => address) internal _votingDelegates;
 
   mapping(address => mapping(uint256 => Snapshot))
-    internal _propositionPowerSnapshots;
-  mapping(address => uint256) internal _propositionPowerSnapshotsCounts;
-  mapping(address => address) internal _propositionPowerDelegates;
+    internal deprecated_propositionPowerSnapshots;
+  mapping(address => uint256)
+    internal deprecated_propositionPowerSnapshotsCounts;
+  mapping(address => address) internal deprecated_propositionPowerDelegates;
+
+  bytes32 public _______DEPRECATED_DOMAIN_SEPARATOR;
 
-  bytes32 public DOMAIN_SEPARATOR;
-  bytes public constant EIP712_REVISION = bytes('1');
-  bytes32 internal constant EIP712_DOMAIN =
-    keccak256(
-      'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
-    );
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256(
       'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'
@@ -1796,13 +2492,30 @@ abstract contract StakedTokenV2 is
     address rewardsVault,
     address emissionManager,
     uint128 distributionDuration
-  ) ERC20() AaveDistributionManager(emissionManager, distributionDuration) {
+  )
+    AaveDistributionManager(emissionManager, distributionDuration)
+    EIP712('Staked Aave', '2')
+  {
     STAKED_TOKEN = stakedToken;
     REWARD_TOKEN = rewardToken;
     UNSTAKE_WINDOW = unstakeWindow;
     REWARDS_VAULT = rewardsVault;
   }
 
+  /**
+   * @notice Get the domain separator for the token
+   * @dev Return cached value if chainId matches cache, otherwise recomputes separator
+   * @return The domain separator of the token at current chain
+   */
+  function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
+    return _domainSeparatorV4();
+  }
+
+  /// @dev maintained for backwards compatibility. See EIP712 _EIP712Version
+  function EIP712_REVISION() external view returns (bytes memory) {
+    return bytes(_EIP712Version());
+  }
+
   /// @inheritdoc IStakedTokenV2
   function stake(address onBehalfOf, uint256 amount) external virtual override;
 
@@ -1845,99 +2558,26 @@ abstract contract StakedTokenV2 is
     //solium-disable-next-line
     require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
     uint256 currentValidNonce = _nonces[owner];
-    bytes32 digest = keccak256(
-      abi.encodePacked(
-        '\x19\x01',
-        DOMAIN_SEPARATOR,
-        keccak256(
-          abi.encode(
-            PERMIT_TYPEHASH,
-            owner,
-            spender,
-            value,
-            currentValidNonce,
-            deadline
-          )
+    bytes32 digest = _hashTypedDataV4(
+      keccak256(
+        abi.encode(
+          PERMIT_TYPEHASH,
+          owner,
+          spender,
+          value,
+          currentValidNonce,
+          deadline
         )
       )
     );
 
-    require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
+    require(owner == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
     unchecked {
       _nonces[owner] = currentValidNonce + 1;
     }
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
@@ -1967,34 +2607,6 @@ abstract contract StakedTokenV2 is
 
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
@@ -3516,6 +4128,627 @@ library SafeCast {
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
+    bytes32 digest = ECDSA.toTypedDataHash(
+      _getDomainSeparator(),
+      keccak256(
+        abi.encode(
+          DELEGATE_BY_TYPE_TYPEHASH,
+          delegator,
+          delegatee,
+          delegationType,
+          _incrementNonces(delegator),
+          deadline
+        )
+      )
+    );
+
+    require(delegator == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
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
+    bytes32 digest = ECDSA.toTypedDataHash(
+      _getDomainSeparator(),
+      keccak256(
+        abi.encode(
+          DELEGATE_TYPEHASH,
+          delegator,
+          delegatee,
+          _incrementNonces(delegator),
+          deadline
+        )
+      )
+    );
+
+    require(delegator == ECDSA.recover(digest, v, r, s), 'INVALID_SIGNATURE');
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
@@ -3525,11 +4758,13 @@ contract StakedTokenV3 is
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
@@ -3542,7 +4777,7 @@ contract StakedTokenV3 is
   uint256 public immutable LOWER_BOUND;
 
   // Reserved storage space to allow for layout changes in the future.
-  uint256[8] private ______gap;
+  uint256[6] private ______gap;
   /// @notice Seconds between starting cooldown and being able to withdraw
   uint256 internal _cooldownSeconds;
   /// @notice The maximum amount of funds that can be slashed at any given time
@@ -3604,7 +4839,7 @@ contract StakedTokenV3 is
    * @return The revision
    */
   function REVISION() public pure virtual returns (uint256) {
-    return 3;
+    return 4;
   }
 
   /**
@@ -3618,21 +4853,7 @@ contract StakedTokenV3 is
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
-  }
+  function initialize() external virtual initializer {}
 
   function _initialize(
     address slashingAdmin,
@@ -3705,7 +4926,7 @@ contract StakedTokenV3 is
     address to,
     uint256 amount
   ) external override(IStakedTokenV2, StakedTokenV2) {
-    _redeem(msg.sender, to, amount);
+    _redeem(msg.sender, to, amount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3714,7 +4935,7 @@ contract StakedTokenV3 is
     address to,
     uint256 amount
   ) external override onlyClaimHelper {
-    _redeem(from, to, amount);
+    _redeem(from, to, amount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV2
@@ -3741,7 +4962,7 @@ contract StakedTokenV3 is
     uint256 redeemAmount
   ) external override {
     _claimRewards(msg.sender, to, claimAmount);
-    _redeem(msg.sender, to, redeemAmount);
+    _redeem(msg.sender, to, redeemAmount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3752,7 +4973,7 @@ contract StakedTokenV3 is
     uint256 redeemAmount
   ) external override onlyClaimHelper {
     _claimRewards(from, to, claimAmount);
-    _redeem(from, to, redeemAmount);
+    _redeem(from, to, redeemAmount.toUint104());
   }
 
   /// @inheritdoc IStakedTokenV3
@@ -3956,7 +5177,7 @@ contract StakedTokenV3 is
 
     STAKED_TOKEN.safeTransferFrom(from, address(this), amount);
 
-    _mint(to, sharesToMint);
+    _mint(to, sharesToMint.toUint104());
 
     emit Staked(from, to, amount, sharesToMint);
   }
@@ -3967,13 +5188,13 @@ contract StakedTokenV3 is
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
@@ -3995,7 +5216,7 @@ contract StakedTokenV3 is
 
     uint256 underlyingToRedeem = previewRedeem(amountToRedeem);
 
-    _burn(from, amountToRedeem);
+    _burn(from, amountToRedeem.toUint104());
 
     if (cooldownSnapshot.timestamp != 0) {
       if (cooldownSnapshot.amount - amountToRedeem == 0) {
@@ -4058,13 +5279,68 @@ contract StakedTokenV3 is
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
+    return DOMAIN_SEPARATOR();
+  }
 }
 
 interface IGhoVariableDebtTokenTransferHook {
@@ -4094,19 +5370,6 @@ interface IStakedAaveV3 is IStakedTokenV3 {
 
   event GHODebtTokenChanged(address indexed newDebtToken);
 
-  /**
-   * @dev Returnes the number of excahngeRate snapshots
-   */
-  function getExchangeRateSnapshotsCount() external view returns (uint32);
-
-  /**
-   * @dev Returns the exchangeRate for a specified index
-   * @param index Index of the exchangeRate
-   */
-  function getExchangeRateSnapshot(
-    uint32 index
-  ) external view returns (ExchangeRateSnapshot memory);
-
   /**
    * @dev Sets the GHO debt token (only callable by SHORT_EXECUTOR)
    * @param newGHODebtToken Address to GHO debt token
@@ -4176,15 +5439,16 @@ interface IERC20WithPermit is IERC20 {
 contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
   using SafeCast for uint256;
 
-  uint32 internal _exchangeRateSnapshotsCount;
+  uint32 internal deprecated_exchangeRateSnapshotsCount;
   /// @notice Snapshots of the exchangeRate for a given block
-  mapping(uint256 => ExchangeRateSnapshot) internal _exchangeRateSnapshots;
+  mapping(uint256 => ExchangeRateSnapshot)
+    internal deprecated_exchangeRateSnapshots;
 
   /// @notice GHO debt token to be used in the _beforeTokenTransfer hook
   IGhoVariableDebtTokenTransferHook public ghoDebtToken;
 
   function REVISION() public pure virtual override returns (uint256) {
-    return 5;
+    return 6;
   }
 
   constructor(
@@ -4211,24 +5475,7 @@ contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
   /**
    * @dev Called by the proxy contract
    */
-  function initialize(
-    address slashingAdmin,
-    address cooldownPauseAdmin,
-    address claimHelper,
-    uint256 maxSlashablePercentage,
-    uint256 cooldownSeconds
-  ) external override initializer {
-    _initialize(
-      slashingAdmin,
-      cooldownPauseAdmin,
-      claimHelper,
-      maxSlashablePercentage,
-      cooldownSeconds
-    );
-
-    // needed to claimRewardsAndStake works without a custom approval each time
-    STAKED_TOKEN.approve(address(this), type(uint256).max);
-  }
+  function initialize() external override initializer {}
 
   /// @inheritdoc IStakedAaveV3
   function setGHODebtToken(
@@ -4277,18 +5524,6 @@ contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
     _stake(from, from, amount);
   }
 
-  /// @inheritdoc IStakedAaveV3
-  function getExchangeRateSnapshotsCount() external view returns (uint32) {
-    return _exchangeRateSnapshotsCount;
-  }
-
-  /// @inheritdoc IStakedAaveV3
-  function getExchangeRateSnapshot(
-    uint32 index
-  ) external view returns (ExchangeRateSnapshot memory) {
-    return _exchangeRateSnapshots[index];
-  }
-
   /**
    * @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn
    * - On _transfer, it writes snapshots for both "from" and "to"
@@ -4315,101 +5550,5 @@ contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
         )
       {} catch (bytes memory) {}
     }
-    address votingFromDelegatee = _votingDelegates[from];
-    address votingToDelegatee = _votingDelegates[to];
-
-    if (votingFromDelegatee == address(0)) {
-      votingFromDelegatee = from;
-    }
-    if (votingToDelegatee == address(0)) {
-      votingToDelegatee = to;
-    }
-
-    _moveDelegatesByType(
-      votingFromDelegatee,
-      votingToDelegatee,
-      amount,
-      DelegationType.VOTING_POWER
-    );
-
-    address propPowerFromDelegatee = _propositionPowerDelegates[from];
-    address propPowerToDelegatee = _propositionPowerDelegates[to];
-
-    if (propPowerFromDelegatee == address(0)) {
-      propPowerFromDelegatee = from;
-    }
-    if (propPowerToDelegatee == address(0)) {
-      propPowerToDelegatee = to;
-    }
-
-    _moveDelegatesByType(
-      propPowerFromDelegatee,
-      propPowerToDelegatee,
-      amount,
-      DelegationType.PROPOSITION_POWER
-    );
-  }
-
-  /// @dev Modified version accounting for exchange rate at block
-  /// @inheritdoc GovernancePowerDelegationERC20
-  function _searchByBlockNumber(
-    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
-    mapping(address => uint256) storage snapshotsCounts,
-    address user,
-    uint256 blockNumber
-  ) internal view override returns (uint256) {
-    return
-      (super._searchByBlockNumber(
-        snapshots,
-        snapshotsCounts,
-        user,
-        blockNumber
-      ) * EXCHANGE_RATE_UNIT) /
-      _binarySearchExchangeRate(
-        _exchangeRateSnapshots,
-        _exchangeRateSnapshotsCount,
-        blockNumber
-      );
-  }
-
-  /**
-   * @dev Updates the exchangeRate and emits events accordingly
-   * @param newExchangeRate the new exchange rate
-   */
-  function _updateExchangeRate(uint216 newExchangeRate) internal override {
-    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = ExchangeRateSnapshot(
-      block.number.toUint40(),
-      newExchangeRate
-    );
-    ++_exchangeRateSnapshotsCount;
-    super._updateExchangeRate(newExchangeRate);
-  }
-
-  function _binarySearchExchangeRate(
-    mapping(uint256 => ExchangeRateSnapshot) storage snapshots,
-    uint256 snapshotsCount,
-    uint256 blockNumber
-  ) internal view returns (uint256) {
-    unchecked {
-      // First check most recent balance
-      if (snapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
-        return snapshots[snapshotsCount - 1].value;
-      }
-
-      uint256 lower = 0;
-      uint256 upper = snapshotsCount - 1;
-      while (upper > lower) {
-        uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
-        ExchangeRateSnapshot memory snapshot = snapshots[center];
-        if (snapshot.blockNumber == blockNumber) {
-          return snapshot.value;
-        } else if (snapshot.blockNumber < blockNumber) {
-          lower = center;
-        } else {
-          upper = center - 1;
-        }
-      }
-      return snapshots[lower].value;
-    }
   }
 }
```
