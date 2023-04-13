```diff
diff --git a/src/etherscan/mainnet_0xE2E8Badc5d50f8a6188577B89f50701cDE2D4e19/StakedTokenV2Rev4/src/contracts/StakedTokenV2Rev4.sol b/src/flattened/StakedAaveV3Flattened.sol
index 708a687..39c188c 100644
--- a/src/etherscan/mainnet_0xE2E8Badc5d50f8a6188577B89f50701cDE2D4e19/StakedTokenV2Rev4/src/contracts/StakedTokenV2Rev4.sol
+++ b/src/flattened/StakedAaveV3Flattened.sol
@@ -1,120 +1,26 @@
 // SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.7.5;
-pragma experimental ABIEncoderV2;
+pragma solidity ^0.8.0;
 
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
-  function delegateByType(address delegatee, DelegationType delegationType)
-    external
-    virtual;
-
-  /**
-   * @dev delegates all the powers to a specific user
-   * @param delegatee the user to which the power will be delegated
-   **/
-  function delegate(address delegatee) external virtual;
-
-  /**
-   * @dev returns the delegatee of an user
-   * @param delegator the address of the delegator
-   **/
-  function getDelegateeByType(address delegator, DelegationType delegationType)
-    external
-    view
-    virtual
-    returns (address);
-
-  /**
-   * @dev returns the current delegated power of a user. The current power is the
-   * power delegated at the time of the last snapshot
-   * @param user the user
-   **/
-  function getPowerCurrent(address user, DelegationType delegationType)
-    external
-    view
-    virtual
-    returns (uint256);
-
-  /**
-   * @dev returns the delegated power of a user at a certain block
-   * @param user the user
-   **/
-  function getPowerAtBlock(
-    address user,
-    uint256 blockNumber,
-    DelegationType delegationType
-  ) external view virtual returns (uint256);
-
-  /**
-   * @dev returns the total supply at a certain block number
-   **/
-  function totalSupplyAt(uint256 blockNumber)
-    external
-    view
-    virtual
-    returns (uint256);
-}
-
-/**
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Provides information about the current execution context, including the
- * sender of the transaction and its data. While these are generally available
- * via msg.sender and msg.data, they should not be accessed in such a direct
- * manner, since when dealing with GSN meta-transactions the account sending and
- * paying for execution may not be the actual sender (as far as an application
- * is concerned).
- *
- * This contract is only required for intermediate, library-like contracts.
- */
-abstract contract Context {
-  function _msgSender() internal view virtual returns (address payable) {
-    return msg.sender;
-  }
-
-  function _msgData() internal view virtual returns (bytes memory) {
-    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
-    return msg.data;
-  }
-}
+// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
 
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
- * From https://github.com/OpenZeppelin/openzeppelin-contracts
  */
 interface IERC20 {
+  /**
+   * @dev Emitted when `value` tokens are moved from one account (`from`) to
+   * another (`to`).
+   *
+   * Note that `value` may be zero.
+   */
+  event Transfer(address indexed from, address indexed to, uint256 value);
+
+  /**
+   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
+   * a call to {approve}. `value` is the new allowance.
+   */
+  event Approval(address indexed owner, address indexed spender, uint256 value);
+
   /**
    * @dev Returns the amount of tokens in existence.
    */
@@ -126,13 +32,13 @@ interface IERC20 {
   function balanceOf(address account) external view returns (uint256);
 
   /**
-   * @dev Moves `amount` tokens from the caller's account to `recipient`.
+   * @dev Moves `amount` tokens from the caller's account to `to`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
-  function transfer(address recipient, uint256 amount) external returns (bool);
+  function transfer(address to, uint256 amount) external returns (bool);
 
   /**
    * @dev Returns the remaining number of tokens that `spender` will be
@@ -163,7 +69,7 @@ interface IERC20 {
   function approve(address spender, uint256 amount) external returns (bool);
 
   /**
-   * @dev Moves `amount` tokens from `sender` to `recipient` using the
+   * @dev Moves `amount` tokens from `from` to `to` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
@@ -172,248 +78,71 @@ interface IERC20 {
    * Emits a {Transfer} event.
    */
   function transferFrom(
-    address sender,
-    address recipient,
+    address from,
+    address to,
     uint256 amount
   ) external returns (bool);
-
-  /**
-   * @dev Emitted when `value` tokens are moved from one account (`from`) to
-   * another (`to`).
-   *
-   * Note that `value` may be zero.
-   */
-  event Transfer(address indexed from, address indexed to, uint256 value);
-
-  /**
-   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
-   * a call to {approve}. `value` is the new allowance.
-   */
-  event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-/**
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Wrappers over Solidity's arithmetic operations with added overflow
- * checks.
- *
- * Arithmetic operations in Solidity wrap on overflow. This can easily result
- * in bugs, because programmers usually assume that an overflow raises an
- * error, which is the standard behavior in high level programming languages.
- * `SafeMath` restores this intuition by reverting the transaction when an
- * operation overflows.
- *
- * Using this library instead of the unchecked operations eliminates an entire
- * class of bugs, so it's recommended to use it always.
- */
-library SafeMath {
-  /**
-   * @dev Returns the addition of two unsigned integers, reverting on
-   * overflow.
-   *
-   * Counterpart to Solidity's `+` operator.
-   *
-   * Requirements:
-   * - Addition cannot overflow.
-   */
-  function add(uint256 a, uint256 b) internal pure returns (uint256) {
-    uint256 c = a + b;
-    require(c >= a, 'SafeMath: addition overflow');
-
-    return c;
+library DistributionTypes {
+  struct AssetConfigInput {
+    uint128 emissionPerSecond;
+    uint256 totalStaked;
+    address underlyingAsset;
   }
 
-  /**
-   * @dev Returns the subtraction of two unsigned integers, reverting on
-   * overflow (when the result is negative).
-   *
-   * Counterpart to Solidity's `-` operator.
-   *
-   * Requirements:
-   * - Subtraction cannot overflow.
-   */
-  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
-    return sub(a, b, 'SafeMath: subtraction overflow');
+  struct UserStakeInput {
+    address underlyingAsset;
+    uint256 stakedByUser;
+    uint256 totalStaked;
   }
+}
 
-  /**
-   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
-   * overflow (when the result is negative).
-   *
-   * Counterpart to Solidity's `-` operator.
-   *
-   * Requirements:
-   * - Subtraction cannot overflow.
-   */
-  function sub(
-    uint256 a,
-    uint256 b,
-    string memory errorMessage
-  ) internal pure returns (uint256) {
-    require(b <= a, errorMessage);
-    uint256 c = a - b;
-
-    return c;
-  }
-
-  /**
-   * @dev Returns the multiplication of two unsigned integers, reverting on
-   * overflow.
-   *
-   * Counterpart to Solidity's `*` operator.
-   *
-   * Requirements:
-   * - Multiplication cannot overflow.
-   */
-  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
-    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
-    // benefit is lost if 'b' is also tested.
-    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
-    if (a == 0) {
-      return 0;
-    }
-
-    uint256 c = a * b;
-    require(c / a == b, 'SafeMath: multiplication overflow');
+// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
 
-    return c;
-  }
+// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
 
+/**
+ * @dev Interface for the optional metadata functions from the ERC20 standard.
+ *
+ * _Available since v4.1._
+ */
+interface IERC20Metadata is IERC20 {
   /**
-   * @dev Returns the integer division of two unsigned integers. Reverts on
-   * division by zero. The result is rounded towards zero.
-   *
-   * Counterpart to Solidity's `/` operator. Note: this function uses a
-   * `revert` opcode (which leaves remaining gas untouched) while Solidity
-   * uses an invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
+   * @dev Returns the name of the token.
    */
-  function div(uint256 a, uint256 b) internal pure returns (uint256) {
-    return div(a, b, 'SafeMath: division by zero');
-  }
+  function name() external view returns (string memory);
 
   /**
-   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
-   * division by zero. The result is rounded towards zero.
-   *
-   * Counterpart to Solidity's `/` operator. Note: this function uses a
-   * `revert` opcode (which leaves remaining gas untouched) while Solidity
-   * uses an invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
+   * @dev Returns the symbol of the token.
    */
-  function div(
-    uint256 a,
-    uint256 b,
-    string memory errorMessage
-  ) internal pure returns (uint256) {
-    // Solidity only automatically asserts when dividing by 0
-    require(b > 0, errorMessage);
-    uint256 c = a / b;
-    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
-
-    return c;
-  }
+  function symbol() external view returns (string memory);
 
   /**
-   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
-   * Reverts when dividing by zero.
-   *
-   * Counterpart to Solidity's `%` operator. This function uses a `revert`
-   * opcode (which leaves remaining gas untouched) while Solidity uses an
-   * invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
+   * @dev Returns the decimals places of the token.
    */
-  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
-    return mod(a, b, 'SafeMath: modulo by zero');
-  }
-
-  /**
-   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
-   * Reverts with custom message when dividing by zero.
-   *
-   * Counterpart to Solidity's `%` operator. This function uses a `revert`
-   * opcode (which leaves remaining gas untouched) while Solidity uses an
-   * invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
-   */
-  function mod(
-    uint256 a,
-    uint256 b,
-    string memory errorMessage
-  ) internal pure returns (uint256) {
-    require(b != 0, errorMessage);
-    return a % b;
-  }
+  function decimals() external view returns (uint8);
 }
 
+// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
+
 /**
- * @dev Collection of functions related to the address type
- * From https://github.com/OpenZeppelin/openzeppelin-contracts
+ * @dev Provides information about the current execution context, including the
+ * sender of the transaction and its data. While these are generally available
+ * via msg.sender and msg.data, they should not be accessed in such a direct
+ * manner, since when dealing with meta-transactions the account sending and
+ * paying for execution may not be the actual sender (as far as an application
+ * is concerned).
+ *
+ * This contract is only required for intermediate, library-like contracts.
  */
-library Address {
-  /**
-   * @dev Returns true if `account` is a contract.
-   *
-   * [IMPORTANT]
-   * ====
-   * It is unsafe to assume that an address for which this function returns
-   * false is an externally-owned account (EOA) and not a contract.
-   *
-   * Among others, `isContract` will return false for the following
-   * types of addresses:
-   *
-   *  - an externally-owned account
-   *  - a contract in construction
-   *  - an address where a contract will be created
-   *  - an address where a contract lived, but was destroyed
-   * ====
-   */
-  function isContract(address account) internal view returns (bool) {
-    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
-    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
-    // for accounts without code, i.e. `keccak256('')`
-    bytes32 codehash;
-    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
-    // solhint-disable-next-line no-inline-assembly
-    assembly {
-      codehash := extcodehash(account)
-    }
-    return (codehash != accountHash && codehash != 0x0);
+abstract contract Context {
+  function _msgSender() internal view virtual returns (address) {
+    return msg.sender;
   }
 
-  /**
-   * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
-   * `recipient`, forwarding all available gas and reverting on errors.
-   *
-   * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
-   * of certain opcodes, possibly making contracts go over the 2300 gas limit
-   * imposed by `transfer`, making them unable to receive funds via
-   * `transfer`. {sendValue} removes this limitation.
-   *
-   * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
-   *
-   * IMPORTANT: because control is transferred to `recipient`, care must be
-   * taken to not create reentrancy vulnerabilities. Consider using
-   * {ReentrancyGuard} or the
-   * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
-   */
-  function sendValue(address payable recipient, uint256 amount) internal {
-    require(address(this).balance >= amount, 'Address: insufficient balance');
-
-    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
-    (bool success, ) = recipient.call{value: amount}('');
-    require(
-      success,
-      'Address: unable to send value, recipient may have reverted'
-    );
+  function _msgData() internal view virtual returns (bytes calldata) {
+    return msg.data;
   }
 }
 
@@ -425,12 +154,13 @@ library Address {
  * For a generic mechanism see {ERC20PresetMinterPauser}.
  *
  * TIP: For a detailed writeup see our guide
- * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
+ * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
  * to implement supply mechanisms].
  *
- * We have followed general OpenZeppelin guidelines: functions revert instead
- * of returning `false` on failure. This behavior is nonetheless conventional
- * and does not conflict with the expectations of ERC20 applications.
+ * We have followed general OpenZeppelin Contracts guidelines: functions revert
+ * instead returning `false` on failure. This behavior is nonetheless
+ * conventional and does not conflict with the expectations of ERC20
+ * applications.
  *
  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
  * This allows applications to reconstruct the allowance for all accounts just
@@ -441,39 +171,32 @@ library Address {
  * functions have been added to mitigate the well-known issues around setting
  * allowances. See {IERC20-approve}.
  */
-contract ERC20 is Context, IERC20 {
-  using SafeMath for uint256;
-  using Address for address;
-
-  mapping(address => uint256) private _balances;
+contract ERC20 is Context, IERC20, IERC20Metadata {
+  mapping(address => uint256) internal _balances;
 
   mapping(address => mapping(address => uint256)) private _allowances;
 
-  uint256 private _totalSupply;
+  uint256 internal _totalSupply;
 
-  string internal _name;
-  string internal _symbol;
-  uint8 private _decimals;
+  string private _name;
+  string private _symbol;
+  uint8 private _decimals; // @deprecated
 
   /**
-   * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
-   * a default value of 18.
+   * @dev Sets the values for {name} and {symbol}.
    *
-   * To select a different value for {decimals}, use {_setupDecimals}.
+   * The default value of {decimals} is 18. To select a different value for
+   * {decimals} you should overload it.
    *
-   * All three of these values are immutable: they can only be set once during
+   * All two of these values are immutable: they can only be set once during
    * construction.
    */
-  constructor(string memory name, string memory symbol) public {
-    _name = name;
-    _symbol = symbol;
-    _decimals = 18;
-  }
+  constructor() {}
 
   /**
    * @dev Returns the name of the token.
    */
-  function name() public view returns (string memory) {
+  function name() public view virtual override returns (string memory) {
     return _name;
   }
 
@@ -481,38 +204,44 @@ contract ERC20 is Context, IERC20 {
    * @dev Returns the symbol of the token, usually a shorter version of the
    * name.
    */
-  function symbol() public view returns (string memory) {
+  function symbol() public view virtual override returns (string memory) {
     return _symbol;
   }
 
   /**
    * @dev Returns the number of decimals used to get its user representation.
    * For example, if `decimals` equals `2`, a balance of `505` tokens should
-   * be displayed to a user as `5,05` (`505 / 10 ** 2`).
+   * be displayed to a user as `5.05` (`505 / 10 ** 2`).
    *
    * Tokens usually opt for a value of 18, imitating the relationship between
-   * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
-   * called.
+   * Ether and Wei. This is the value {ERC20} uses, unless this function is
+   * overridden;
    *
    * NOTE: This information is only used for _display_ purposes: it in
    * no way affects any of the arithmetic of the contract, including
    * {IERC20-balanceOf} and {IERC20-transfer}.
    */
-  function decimals() public view returns (uint8) {
-    return _decimals;
+  function decimals() public view virtual override returns (uint8) {
+    return 18;
   }
 
   /**
    * @dev See {IERC20-totalSupply}.
    */
-  function totalSupply() public view override returns (uint256) {
+  function totalSupply() public view virtual override returns (uint256) {
     return _totalSupply;
   }
 
   /**
    * @dev See {IERC20-balanceOf}.
    */
-  function balanceOf(address account) public view override returns (uint256) {
+  function balanceOf(address account)
+    public
+    view
+    virtual
+    override
+    returns (uint256)
+  {
     return _balances[account];
   }
 
@@ -521,16 +250,17 @@ contract ERC20 is Context, IERC20 {
    *
    * Requirements:
    *
-   * - `recipient` cannot be the zero address.
+   * - `to` cannot be the zero address.
    * - the caller must have a balance of at least `amount`.
    */
-  function transfer(address recipient, uint256 amount)
+  function transfer(address to, uint256 amount)
     public
     virtual
     override
     returns (bool)
   {
-    _transfer(_msgSender(), recipient, amount);
+    address owner = _msgSender();
+    _transfer(owner, to, amount);
     return true;
   }
 
@@ -550,6 +280,9 @@ contract ERC20 is Context, IERC20 {
   /**
    * @dev See {IERC20-approve}.
    *
+   * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
+   * `transferFrom`. This is semantically equivalent to an infinite approval.
+   *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
@@ -560,7 +293,8 @@ contract ERC20 is Context, IERC20 {
     override
     returns (bool)
   {
-    _approve(_msgSender(), spender, amount);
+    address owner = _msgSender();
+    _approve(owner, spender, amount);
     return true;
   }
 
@@ -568,28 +302,26 @@ contract ERC20 is Context, IERC20 {
    * @dev See {IERC20-transferFrom}.
    *
    * Emits an {Approval} event indicating the updated allowance. This is not
-   * required by the EIP. See the note at the beginning of {ERC20};
+   * required by the EIP. See the note at the beginning of {ERC20}.
+   *
+   * NOTE: Does not update the allowance if the current allowance
+   * is the maximum `uint256`.
    *
    * Requirements:
-   * - `sender` and `recipient` cannot be the zero address.
-   * - `sender` must have a balance of at least `amount`.
-   * - the caller must have allowance for ``sender``'s tokens of at least
+   *
+   * - `from` and `to` cannot be the zero address.
+   * - `from` must have a balance of at least `amount`.
+   * - the caller must have allowance for ``from``'s tokens of at least
    * `amount`.
    */
   function transferFrom(
-    address sender,
-    address recipient,
+    address from,
+    address to,
     uint256 amount
   ) public virtual override returns (bool) {
-    _transfer(sender, recipient, amount);
-    _approve(
-      sender,
-      _msgSender(),
-      _allowances[sender][_msgSender()].sub(
-        amount,
-        'ERC20: transfer amount exceeds allowance'
-      )
-    );
+    address spender = _msgSender();
+    _spendAllowance(from, spender, amount);
+    _transfer(from, to, amount);
     return true;
   }
 
@@ -610,11 +342,8 @@ contract ERC20 is Context, IERC20 {
     virtual
     returns (bool)
   {
-    _approve(
-      _msgSender(),
-      spender,
-      _allowances[_msgSender()][spender].add(addedValue)
-    );
+    address owner = _msgSender();
+    _approve(owner, spender, allowance(owner, spender) + addedValue);
     return true;
   }
 
@@ -637,47 +366,55 @@ contract ERC20 is Context, IERC20 {
     virtual
     returns (bool)
   {
-    _approve(
-      _msgSender(),
-      spender,
-      _allowances[_msgSender()][spender].sub(
-        subtractedValue,
-        'ERC20: decreased allowance below zero'
-      )
+    address owner = _msgSender();
+    uint256 currentAllowance = allowance(owner, spender);
+    require(
+      currentAllowance >= subtractedValue,
+      'ERC20: decreased allowance below zero'
     );
+    unchecked {
+      _approve(owner, spender, currentAllowance - subtractedValue);
+    }
+
     return true;
   }
 
   /**
-   * @dev Moves tokens `amount` from `sender` to `recipient`.
+   * @dev Moves `amount` of tokens from `from` to `to`.
    *
-   * This is internal function is equivalent to {transfer}, and can be used to
+   * This internal function is equivalent to {transfer}, and can be used to
    * e.g. implement automatic token fees, slashing mechanisms, etc.
    *
    * Emits a {Transfer} event.
    *
    * Requirements:
    *
-   * - `sender` cannot be the zero address.
-   * - `recipient` cannot be the zero address.
-   * - `sender` must have a balance of at least `amount`.
+   * - `from` cannot be the zero address.
+   * - `to` cannot be the zero address.
+   * - `from` must have a balance of at least `amount`.
    */
   function _transfer(
-    address sender,
-    address recipient,
+    address from,
+    address to,
     uint256 amount
   ) internal virtual {
-    require(sender != address(0), 'ERC20: transfer from the zero address');
-    require(recipient != address(0), 'ERC20: transfer to the zero address');
+    require(from != address(0), 'ERC20: transfer from the zero address');
+    require(to != address(0), 'ERC20: transfer to the zero address');
 
-    _beforeTokenTransfer(sender, recipient, amount);
+    _beforeTokenTransfer(from, to, amount);
 
-    _balances[sender] = _balances[sender].sub(
-      amount,
-      'ERC20: transfer amount exceeds balance'
-    );
-    _balances[recipient] = _balances[recipient].add(amount);
-    emit Transfer(sender, recipient, amount);
+    uint256 fromBalance = _balances[from];
+    require(fromBalance >= amount, 'ERC20: transfer amount exceeds balance');
+    unchecked {
+      _balances[from] = fromBalance - amount;
+      // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
+      // decrementing then incrementing.
+      _balances[to] += amount;
+    }
+
+    emit Transfer(from, to, amount);
+
+    _afterTokenTransfer(from, to, amount);
   }
 
   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
@@ -685,18 +422,23 @@ contract ERC20 is Context, IERC20 {
    *
    * Emits a {Transfer} event with `from` set to the zero address.
    *
-   * Requirements
+   * Requirements:
    *
-   * - `to` cannot be the zero address.
+   * - `account` cannot be the zero address.
    */
   function _mint(address account, uint256 amount) internal virtual {
     require(account != address(0), 'ERC20: mint to the zero address');
 
     _beforeTokenTransfer(address(0), account, amount);
 
-    _totalSupply = _totalSupply.add(amount);
-    _balances[account] = _balances[account].add(amount);
+    _totalSupply += amount;
+    unchecked {
+      // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
+      _balances[account] += amount;
+    }
     emit Transfer(address(0), account, amount);
+
+    _afterTokenTransfer(address(0), account, amount);
   }
 
   /**
@@ -705,7 +447,7 @@ contract ERC20 is Context, IERC20 {
    *
    * Emits a {Transfer} event with `to` set to the zero address.
    *
-   * Requirements
+   * Requirements:
    *
    * - `account` cannot be the zero address.
    * - `account` must have at least `amount` tokens.
@@ -715,18 +457,23 @@ contract ERC20 is Context, IERC20 {
 
     _beforeTokenTransfer(account, address(0), amount);
 
-    _balances[account] = _balances[account].sub(
-      amount,
-      'ERC20: burn amount exceeds balance'
-    );
-    _totalSupply = _totalSupply.sub(amount);
+    uint256 accountBalance = _balances[account];
+    require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
+    unchecked {
+      _balances[account] = accountBalance - amount;
+      // Overflow not possible: amount <= accountBalance <= totalSupply.
+      _totalSupply -= amount;
+    }
+
     emit Transfer(account, address(0), amount);
+
+    _afterTokenTransfer(account, address(0), amount);
   }
 
   /**
-   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
+   * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
    *
-   * This is internal function is equivalent to `approve`, and can be used to
+   * This internal function is equivalent to `approve`, and can be used to
    * e.g. set automatic allowances for certain subsystems, etc.
    *
    * Emits an {Approval} event.
@@ -749,14 +496,25 @@ contract ERC20 is Context, IERC20 {
   }
 
   /**
-   * @dev Sets {decimals} to a value other than the default one of 18.
+   * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
    *
-   * WARNING: This function should only be called from the constructor. Most
-   * applications that interact with token contracts will not expect
-   * {decimals} to ever change, and may work incorrectly if it does.
+   * Does not update the allowance amount in case of infinite allowance.
+   * Revert if not enough allowance is available.
+   *
+   * Might emit an {Approval} event.
    */
-  function _setupDecimals(uint8 decimals_) internal {
-    _decimals = decimals_;
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
   }
 
   /**
@@ -766,7 +524,7 @@ contract ERC20 is Context, IERC20 {
    * Calling conditions:
    *
    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
-   * will be to transferred to `to`.
+   * will be transferred to `to`.
    * - when `from` is zero, `amount` tokens will be minted for `to`.
    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
    * - `from` and `to` are never both zero.
@@ -778,44 +536,721 @@ contract ERC20 is Context, IERC20 {
     address to,
     uint256 amount
   ) internal virtual {}
-}
 
-interface IStakedAave {
-  function stake(address to, uint256 amount) external;
-
-  function redeem(address to, uint256 amount) external;
-
-  function cooldown() external;
-
-  function claimRewards(address to, uint256 amount) external;
-}
-
-interface ITransferHook {
-  function onTransfer(
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
     address from,
     address to,
     uint256 amount
-  ) external;
+  ) internal virtual {}
 }
 
-library DistributionTypes {
-  struct AssetConfigInput {
-    uint128 emissionPerSecond;
-    uint256 totalStaked;
-    address underlyingAsset;
+interface IGovernancePowerDelegationToken {
+  enum DelegationType {
+    VOTING_POWER,
+    PROPOSITION_POWER
   }
 
-  struct UserStakeInput {
-    address underlyingAsset;
-    uint256 stakedByUser;
-    uint256 totalStaked;
+  /**
+   * @dev emitted when a user delegates to another
+   * @param delegator the delegator
+   * @param delegatee the delegatee
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  event DelegateChanged(
+    address indexed delegator,
+    address indexed delegatee,
+    DelegationType delegationType
+  );
+
+  /**
+   * @dev emitted when an action changes the delegated power of a user
+   * @param user the user which delegated power has changed
+   * @param amount the amount of delegated power for the user
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  event DelegatedPowerChanged(
+    address indexed user,
+    uint256 amount,
+    DelegationType delegationType
+  );
+
+  /**
+   * @dev delegates the specific power to a delegatee
+   * @param delegatee the user which delegated power has changed
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  function delegateByType(address delegatee, DelegationType delegationType)
+    external;
+
+  /**
+   * @dev delegates all the powers to a specific user
+   * @param delegatee the user to which the power will be delegated
+   **/
+  function delegate(address delegatee) external;
+
+  /**
+   * @dev returns the delegatee of an user
+   * @param delegator the address of the delegator
+   **/
+  function getDelegateeByType(address delegator, DelegationType delegationType)
+    external
+    view
+    returns (address);
+
+  /**
+   * @dev returns the current delegated power of a user. The current power is the
+   * power delegated at the time of the last snapshot
+   * @param user the user
+   **/
+  function getPowerCurrent(address user, DelegationType delegationType)
+    external
+    view
+    returns (uint256);
+
+  /**
+   * @dev returns the delegated power of a user at a certain block
+   * @param user the user
+   **/
+  function getPowerAtBlock(
+    address user,
+    uint256 blockNumber,
+    DelegationType delegationType
+  ) external view returns (uint256);
+
+  /**
+   * @dev returns the total supply at a certain block number
+   **/
+  function totalSupplyAt(uint256 blockNumber) external view returns (uint256);
+}
+
+/**
+ * @notice implementation of the AAVE token contract
+ * @author Aave
+ */
+abstract contract GovernancePowerDelegationERC20 is
+  ERC20,
+  IGovernancePowerDelegationToken
+{
+  /// @notice The EIP-712 typehash for the delegation struct used by the contract
+  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
+    keccak256(
+      'DelegateByType(address delegatee,uint256 type,uint256 nonce,uint256 expiry)'
+    );
+
+  bytes32 public constant DELEGATE_TYPEHASH =
+    keccak256('Delegate(address delegatee,uint256 nonce,uint256 expiry)');
+
+  /// @dev snapshot of a value on a specific block, used for votes
+  struct Snapshot {
+    uint128 blockNumber;
+    uint128 value;
+  }
+
+  /**
+   * @dev delegates one specific power to a delegatee
+   * @param delegatee the user which delegated power has changed
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  function delegateByType(address delegatee, DelegationType delegationType)
+    external
+    override
+  {
+    _delegateByType(msg.sender, delegatee, delegationType);
+  }
+
+  /**
+   * @dev delegates all the powers to a specific user
+   * @param delegatee the user to which the power will be delegated
+   **/
+  function delegate(address delegatee) external override {
+    _delegateByType(msg.sender, delegatee, DelegationType.VOTING_POWER);
+    _delegateByType(msg.sender, delegatee, DelegationType.PROPOSITION_POWER);
+  }
+
+  /**
+   * @dev returns the delegatee of an user
+   * @param delegator the address of the delegator
+   **/
+  function getDelegateeByType(address delegator, DelegationType delegationType)
+    external
+    view
+    override
+    returns (address)
+  {
+    (
+      ,
+      ,
+      mapping(address => address) storage delegates
+    ) = _getDelegationDataByType(delegationType);
+
+    return _getDelegatee(delegator, delegates);
+  }
+
+  /**
+   * @dev returns the current delegated power of a user. The current power is the
+   * power delegated at the time of the last snapshot
+   * @param user the user
+   **/
+  function getPowerCurrent(address user, DelegationType delegationType)
+    external
+    view
+    override
+    returns (uint256)
+  {
+    (
+      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+      mapping(address => uint256) storage snapshotsCounts,
+
+    ) = _getDelegationDataByType(delegationType);
+
+    return _searchByBlockNumber(snapshots, snapshotsCounts, user, block.number);
+  }
+
+  /**
+   * @dev returns the delegated power of a user at a certain block
+   * @param user the user
+   **/
+  function getPowerAtBlock(
+    address user,
+    uint256 blockNumber,
+    DelegationType delegationType
+  ) external view override returns (uint256) {
+    (
+      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+      mapping(address => uint256) storage snapshotsCounts,
+
+    ) = _getDelegationDataByType(delegationType);
+
+    return _searchByBlockNumber(snapshots, snapshotsCounts, user, blockNumber);
+  }
+
+  /**
+   * @dev returns the total supply at a certain block number
+   * used by the voting strategy contracts to calculate the total votes needed for threshold/quorum
+   * In this initial implementation with no AAVE minting, simply returns the current supply
+   * A snapshots mapping will need to be added in case a mint function is added to the AAVE token in the future
+   **/
+  function totalSupplyAt(uint256) external view override returns (uint256) {
+    return super.totalSupply();
+  }
+
+  /**
+   * @dev delegates the specific power to a delegatee
+   * @param delegatee the user which delegated power has changed
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  function _delegateByType(
+    address delegator,
+    address delegatee,
+    DelegationType delegationType
+  ) internal {
+    require(delegatee != address(0), 'INVALID_DELEGATEE');
+
+    (
+      ,
+      ,
+      mapping(address => address) storage delegates
+    ) = _getDelegationDataByType(delegationType);
+
+    uint256 delegatorBalance = balanceOf(delegator);
+
+    address previousDelegatee = _getDelegatee(delegator, delegates);
+
+    delegates[delegator] = delegatee;
+
+    _moveDelegatesByType(
+      previousDelegatee,
+      delegatee,
+      delegatorBalance,
+      delegationType
+    );
+    emit DelegateChanged(delegator, delegatee, delegationType);
+  }
+
+  /**
+   * @dev moves delegated power from one user to another
+   * @param from the user from which delegated power is moved
+   * @param to the user that will receive the delegated power
+   * @param amount the amount of delegated power to be moved
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   **/
+  function _moveDelegatesByType(
+    address from,
+    address to,
+    uint256 amount,
+    DelegationType delegationType
+  ) internal {
+    if (from == to) {
+      return;
+    }
+
+    (
+      mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+      mapping(address => uint256) storage snapshotsCounts,
+
+    ) = _getDelegationDataByType(delegationType);
+
+    if (from != address(0)) {
+      uint256 previous = 0;
+      uint256 fromSnapshotsCount = snapshotsCounts[from];
+
+      if (fromSnapshotsCount != 0) {
+        previous = snapshots[from][fromSnapshotsCount - 1].value;
+      } else {
+        previous = balanceOf(from);
+      }
+
+      _writeSnapshot(
+        snapshots,
+        snapshotsCounts,
+        from,
+        uint128(previous),
+        uint128(previous - amount)
+      );
+
+      emit DelegatedPowerChanged(from, previous - amount, delegationType);
+    }
+    if (to != address(0)) {
+      uint256 previous = 0;
+      uint256 toSnapshotsCount = snapshotsCounts[to];
+      if (toSnapshotsCount != 0) {
+        previous = snapshots[to][toSnapshotsCount - 1].value;
+      } else {
+        previous = balanceOf(to);
+      }
+
+      _writeSnapshot(
+        snapshots,
+        snapshotsCounts,
+        to,
+        uint128(previous),
+        uint128(previous + amount)
+      );
+
+      emit DelegatedPowerChanged(to, previous + amount, delegationType);
+    }
+  }
+
+  /**
+   * @dev searches a snapshot by block number. Uses binary search.
+   * @param snapshots the snapshots mapping
+   * @param snapshotsCounts the number of snapshots
+   * @param user the user for which the snapshot is being searched
+   * @param blockNumber the block number being searched
+   **/
+  function _searchByBlockNumber(
+    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+    mapping(address => uint256) storage snapshotsCounts,
+    address user,
+    uint256 blockNumber
+  ) internal view virtual returns (uint256) {
+    require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
+
+    uint256 snapshotsCount = snapshotsCounts[user];
+
+    if (snapshotsCount == 0) {
+      return balanceOf(user);
+    }
+
+    // Check implicit zero balance
+    if (snapshots[user][0].blockNumber > blockNumber) {
+      return 0;
+    }
+
+    return _binarySearch(snapshots[user], snapshotsCount, blockNumber);
+  }
+
+  function _binarySearch(
+    mapping(uint256 => Snapshot) storage snapshots,
+    uint256 snapshotsCount,
+    uint256 blockNumber
+  ) internal view returns (uint256) {
+    unchecked {
+      // First check most recent balance
+      if (snapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
+        return snapshots[snapshotsCount - 1].value;
+      }
+
+      uint256 lower = 0;
+      uint256 upper = snapshotsCount - 1;
+      while (upper > lower) {
+        uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
+        Snapshot memory snapshot = snapshots[center];
+        if (snapshot.blockNumber == blockNumber) {
+          return snapshot.value;
+        } else if (snapshot.blockNumber < blockNumber) {
+          lower = center;
+        } else {
+          upper = center - 1;
+        }
+      }
+      return snapshots[lower].value;
+    }
+  }
+
+  /**
+   * @dev returns the delegation data (snapshot, snapshotsCount, list of delegates) by delegation type
+   * NOTE: Ideal implementation would have mapped this in a struct by delegation type. Unfortunately,
+   * the AAVE token and StakeToken already include a mapping for the snapshots, so we require contracts
+   * who inherit from this to provide access to the delegation data by overriding this method.
+   * @param delegationType the type of delegation
+   **/
+  function _getDelegationDataByType(DelegationType delegationType)
+    internal
+    view
+    virtual
+    returns (
+      mapping(address => mapping(uint256 => Snapshot)) storage, //snapshots
+      mapping(address => uint256) storage, //snapshots count
+      mapping(address => address) storage //delegatees list
+    );
+
+  /**
+   * @dev Writes a snapshot for an owner of tokens
+   * @param owner The owner of the tokens
+   * @param oldValue The value before the operation that is gonna be executed after the snapshot
+   * @param newValue The value after the operation
+   */
+  function _writeSnapshot(
+    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+    mapping(address => uint256) storage snapshotsCounts,
+    address owner,
+    uint128 oldValue,
+    uint128 newValue
+  ) internal {
+    uint128 currentBlock = uint128(block.number);
+
+    uint256 ownerSnapshotsCount = snapshotsCounts[owner];
+    mapping(uint256 => Snapshot) storage snapshotsOwner = snapshots[owner];
+
+    // Doing multiple operations in the same block
+    if (
+      ownerSnapshotsCount != 0 &&
+      snapshotsOwner[ownerSnapshotsCount - 1].blockNumber == currentBlock
+    ) {
+      snapshotsOwner[ownerSnapshotsCount - 1].value = newValue;
+    } else {
+      snapshotsOwner[ownerSnapshotsCount] = Snapshot(currentBlock, newValue);
+      snapshotsCounts[owner] = ownerSnapshotsCount + 1;
+    }
+  }
+
+  /**
+   * @dev returns the user delegatee. If a user never performed any delegation,
+   * his delegated address will be 0x0. In that case we simply return the user itself
+   * @param delegator the address of the user for which return the delegatee
+   * @param delegates the array of delegates for a particular type of delegation
+   **/
+  function _getDelegatee(
+    address delegator,
+    mapping(address => address) storage delegates
+  ) internal view returns (address) {
+    address previousDelegatee = delegates[delegator];
+
+    if (previousDelegatee == address(0)) {
+      return delegator;
+    }
+
+    return previousDelegatee;
+  }
+}
+
+// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
+
+/**
+ * @dev Collection of functions related to the address type
+ */
+library Address {
+  /**
+   * @dev Returns true if `account` is a contract.
+   *
+   * [IMPORTANT]
+   * ====
+   * It is unsafe to assume that an address for which this function returns
+   * false is an externally-owned account (EOA) and not a contract.
+   *
+   * Among others, `isContract` will return false for the following
+   * types of addresses:
+   *
+   *  - an externally-owned account
+   *  - a contract in construction
+   *  - an address where a contract will be created
+   *  - an address where a contract lived, but was destroyed
+   * ====
+   *
+   * [IMPORTANT]
+   * ====
+   * You shouldn't rely on `isContract` to protect against flash loan attacks!
+   *
+   * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
+   * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
+   * constructor.
+   * ====
+   */
+  function isContract(address account) internal view returns (bool) {
+    // This method relies on extcodesize/address.code.length, which returns 0
+    // for contracts in construction, since the code is only stored at the end
+    // of the constructor execution.
+
+    return account.code.length > 0;
+  }
+
+  /**
+   * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
+   * `recipient`, forwarding all available gas and reverting on errors.
+   *
+   * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
+   * of certain opcodes, possibly making contracts go over the 2300 gas limit
+   * imposed by `transfer`, making them unable to receive funds via
+   * `transfer`. {sendValue} removes this limitation.
+   *
+   * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
+   *
+   * IMPORTANT: because control is transferred to `recipient`, care must be
+   * taken to not create reentrancy vulnerabilities. Consider using
+   * {ReentrancyGuard} or the
+   * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
+   */
+  function sendValue(address payable recipient, uint256 amount) internal {
+    require(address(this).balance >= amount, 'Address: insufficient balance');
+
+    (bool success, ) = recipient.call{value: amount}('');
+    require(
+      success,
+      'Address: unable to send value, recipient may have reverted'
+    );
+  }
+
+  /**
+   * @dev Performs a Solidity function call using a low level `call`. A
+   * plain `call` is an unsafe replacement for a function call: use this
+   * function instead.
+   *
+   * If `target` reverts with a revert reason, it is bubbled up by this
+   * function (like regular Solidity function calls).
+   *
+   * Returns the raw returned data. To convert to the expected return value,
+   * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
+   *
+   * Requirements:
+   *
+   * - `target` must be a contract.
+   * - calling `target` with `data` must not revert.
+   *
+   * _Available since v3.1._
+   */
+  function functionCall(address target, bytes memory data)
+    internal
+    returns (bytes memory)
+  {
+    return
+      functionCallWithValue(target, data, 0, 'Address: low-level call failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
+   * `errorMessage` as a fallback revert reason when `target` reverts.
+   *
+   * _Available since v3.1._
+   */
+  function functionCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    return functionCallWithValue(target, data, 0, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but also transferring `value` wei to `target`.
+   *
+   * Requirements:
+   *
+   * - the calling contract must have an ETH balance of at least `value`.
+   * - the called Solidity function must be `payable`.
+   *
+   * _Available since v3.1._
+   */
+  function functionCallWithValue(
+    address target,
+    bytes memory data,
+    uint256 value
+  ) internal returns (bytes memory) {
+    return
+      functionCallWithValue(
+        target,
+        data,
+        value,
+        'Address: low-level call with value failed'
+      );
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
+   * with `errorMessage` as a fallback revert reason when `target` reverts.
+   *
+   * _Available since v3.1._
+   */
+  function functionCallWithValue(
+    address target,
+    bytes memory data,
+    uint256 value,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    require(
+      address(this).balance >= value,
+      'Address: insufficient balance for call'
+    );
+    (bool success, bytes memory returndata) = target.call{value: value}(data);
+    return
+      verifyCallResultFromTarget(target, success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but performing a static call.
+   *
+   * _Available since v3.3._
+   */
+  function functionStaticCall(address target, bytes memory data)
+    internal
+    view
+    returns (bytes memory)
+  {
+    return
+      functionStaticCall(target, data, 'Address: low-level static call failed');
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+   * but performing a static call.
+   *
+   * _Available since v3.3._
+   */
+  function functionStaticCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal view returns (bytes memory) {
+    (bool success, bytes memory returndata) = target.staticcall(data);
+    return
+      verifyCallResultFromTarget(target, success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+   * but performing a delegate call.
+   *
+   * _Available since v3.4._
+   */
+  function functionDelegateCall(address target, bytes memory data)
+    internal
+    returns (bytes memory)
+  {
+    return
+      functionDelegateCall(
+        target,
+        data,
+        'Address: low-level delegate call failed'
+      );
+  }
+
+  /**
+   * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+   * but performing a delegate call.
+   *
+   * _Available since v3.4._
+   */
+  function functionDelegateCall(
+    address target,
+    bytes memory data,
+    string memory errorMessage
+  ) internal returns (bytes memory) {
+    (bool success, bytes memory returndata) = target.delegatecall(data);
+    return
+      verifyCallResultFromTarget(target, success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
+   * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
+   *
+   * _Available since v4.8._
+   */
+  function verifyCallResultFromTarget(
+    address target,
+    bool success,
+    bytes memory returndata,
+    string memory errorMessage
+  ) internal view returns (bytes memory) {
+    if (success) {
+      if (returndata.length == 0) {
+        // only check isContract if the call was successful and the return data is empty
+        // otherwise we already know that it was a contract
+        require(isContract(target), 'Address: call to non-contract');
+      }
+      return returndata;
+    } else {
+      _revert(returndata, errorMessage);
+    }
+  }
+
+  /**
+   * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
+   * revert reason or using the provided one.
+   *
+   * _Available since v4.3._
+   */
+  function verifyCallResult(
+    bool success,
+    bytes memory returndata,
+    string memory errorMessage
+  ) internal pure returns (bytes memory) {
+    if (success) {
+      return returndata;
+    } else {
+      _revert(returndata, errorMessage);
+    }
+  }
+
+  function _revert(bytes memory returndata, string memory errorMessage)
+    private
+    pure
+  {
+    // Look for revert reason and bubble it up if present
+    if (returndata.length > 0) {
+      // The easiest way to bubble the revert reason is using memory via assembly
+      /// @solidity memory-safe-assembly
+      assembly {
+        let returndata_size := mload(returndata)
+        revert(add(32, returndata), returndata_size)
+      }
+    } else {
+      revert(errorMessage);
+    }
   }
 }
 
 /**
  * @title SafeERC20
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Wrappers around ERC20 operations that throw on failure (when the token
+ * @dev Wrappers around ERC20 operations that throw on failure (when the token
  * contract returns false). Tokens that return no value (and instead revert or
  * throw on failure) are also supported, non-reverting calls are assumed to be
  * successful.
@@ -823,7 +1258,6 @@ library DistributionTypes {
  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
  */
 library SafeERC20 {
-  using SafeMath for uint256;
   using Address for address;
 
   function safeTransfer(
@@ -831,7 +1265,7 @@ library SafeERC20 {
     address to,
     uint256 value
   ) internal {
-    callOptionalReturn(
+    _callOptionalReturn(
       token,
       abi.encodeWithSelector(token.transfer.selector, to, value)
     );
@@ -843,37 +1277,85 @@ library SafeERC20 {
     address to,
     uint256 value
   ) internal {
-    callOptionalReturn(
+    _callOptionalReturn(
       token,
       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
     );
   }
 
+  /**
+   * @dev Deprecated. This function has issues similar to the ones found in
+   * {IERC20-approve}, and its usage is discouraged.
+   *
+   * Whenever possible, use {safeIncreaseAllowance} and
+   * {safeDecreaseAllowance} instead.
+   */
   function safeApprove(
     IERC20 token,
     address spender,
     uint256 value
   ) internal {
+    // safeApprove should only be called when setting an initial allowance,
+    // or when resetting it to zero. To increase and decrease it, use
+    // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
     require(
       (value == 0) || (token.allowance(address(this), spender) == 0),
       'SafeERC20: approve from non-zero to non-zero allowance'
     );
-    callOptionalReturn(
+    _callOptionalReturn(
       token,
       abi.encodeWithSelector(token.approve.selector, spender, value)
     );
   }
 
-  function callOptionalReturn(IERC20 token, bytes memory data) private {
-    require(address(token).isContract(), 'SafeERC20: call to non-contract');
+  function safeIncreaseAllowance(
+    IERC20 token,
+    address spender,
+    uint256 value
+  ) internal {
+    uint256 newAllowance = token.allowance(address(this), spender) + value;
+    _callOptionalReturn(
+      token,
+      abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
+    );
+  }
 
-    // solhint-disable-next-line avoid-low-level-calls
-    (bool success, bytes memory returndata) = address(token).call(data);
-    require(success, 'SafeERC20: low-level call failed');
+  function safeDecreaseAllowance(
+    IERC20 token,
+    address spender,
+    uint256 value
+  ) internal {
+    unchecked {
+      uint256 oldAllowance = token.allowance(address(this), spender);
+      require(
+        oldAllowance >= value,
+        'SafeERC20: decreased allowance below zero'
+      );
+      uint256 newAllowance = oldAllowance - value;
+      _callOptionalReturn(
+        token,
+        abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
+      );
+    }
+  }
 
+  /**
+   * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
+   * on the return value: the return value is optional (but if data is returned, it must not be false).
+   * @param token The token targeted by the call.
+   * @param data The call data (encoded using abi.encode or one of its variants).
+   */
+  function _callOptionalReturn(IERC20 token, bytes memory data) private {
+    // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
+    // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
+    // the target address contains contract code and also asserts for success in the low-level call.
+
+    bytes memory returndata = address(token).functionCall(
+      data,
+      'SafeERC20: low-level call failed'
+    );
     if (returndata.length > 0) {
       // Return data is optional
-      // solhint-disable-next-line max-line-length
       require(
         abi.decode(returndata, (bool)),
         'SafeERC20: ERC20 operation did not succeed'
@@ -882,6 +1364,84 @@ library SafeERC20 {
   }
 }
 
+interface IAaveDistributionManager {
+  function configureAssets(
+    DistributionTypes.AssetConfigInput[] memory assetsConfigInput
+  ) external;
+}
+
+interface IStakedTokenV2 {
+  struct CooldownSnapshot {
+    uint40 timestamp;
+    uint216 amount;
+  }
+
+  event RewardsAccrued(address user, uint256 amount);
+  event RewardsClaimed(
+    address indexed from,
+    address indexed to,
+    uint256 amount
+  );
+  event Cooldown(address indexed user, uint256 amount);
+
+  /**
+   * @dev Allows staking a specified amount of STAKED_TOKEN
+   * @param to The address to receiving the shares
+   * @param amount The amount of assets to be staked
+   */
+  function stake(address to, uint256 amount) external;
+
+  /**
+   * @dev Redeems shares, and stop earning rewards
+   * @param to Address to redeem to
+   * @param amount Amount of shares to redeem
+   */
+  function redeem(address to, uint256 amount) external;
+
+  /**
+   * @dev Activates the cooldown period to unstake
+   * - It can't be called if the user is not staking
+   */
+  function cooldown() external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
+   * @param to Address to send the claimed rewards
+   * @param amount Amount to stake
+   */
+  function claimRewards(address to, uint256 amount) external;
+
+  /**
+   * @dev Return the total rewards pending to claim by an staker
+   * @param staker The staker address
+   * @return The rewards
+   */
+  function getTotalRewardsBalance(address staker)
+    external
+    view
+    returns (uint256);
+
+  /**
+   * @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
+   * @param owner the owner of the funds
+   * @param spender the spender
+   * @param value the amount
+   * @param deadline the deadline timestamp, type(uint256).max for no deadline
+   * @param v signature param
+   * @param s signature param
+   * @param r signature param
+   */
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
  * @title VersionedInitializable
  *
@@ -925,20 +1485,12 @@ abstract contract VersionedInitializable {
   uint256[50] private ______gap;
 }
 
-interface IAaveDistributionManager {
-  function configureAssets(
-    DistributionTypes.AssetConfigInput[] calldata assetsConfigInput
-  ) external;
-}
-
 /**
  * @title AaveDistributionManager
  * @notice Accounting contract to manage multiple staking distributions
  * @author Aave
- **/
-contract AaveDistributionManager is IAaveDistributionManager {
-  using SafeMath for uint256;
-
+ */
+contract AaveDistributionManager {
   struct AssetData {
     uint128 emissionPerSecond;
     uint128 lastUpdateTimestamp;
@@ -962,20 +1514,18 @@ contract AaveDistributionManager is IAaveDistributionManager {
     uint256 index
   );
 
-  constructor(address emissionManager, uint256 distributionDuration) public {
-    DISTRIBUTION_END = block.timestamp.add(distributionDuration);
+  constructor(address emissionManager, uint256 distributionDuration) {
+    DISTRIBUTION_END = block.timestamp + distributionDuration;
     EMISSION_MANAGER = emissionManager;
   }
 
   /**
    * @dev Configures the distribution of rewards for a list of assets
    * @param assetsConfigInput The list of configurations to apply
-   **/
-  function configureAssets(
-    DistributionTypes.AssetConfigInput[] calldata assetsConfigInput
-  ) external override {
-    require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
-
+   */
+  function _configureAssets(
+    DistributionTypes.AssetConfigInput[] memory assetsConfigInput
+  ) internal {
     for (uint256 i = 0; i < assetsConfigInput.length; i++) {
       AssetData storage assetConfig = assets[
         assetsConfigInput[i].underlyingAsset
@@ -1002,7 +1552,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param assetConfig Storage pointer to the distribution's config
    * @param totalStaked Current total of staked assets for this distribution
    * @return The new distribution index
-   **/
+   */
   function _updateAssetStateInternal(
     address underlyingAsset,
     AssetData storage assetConfig,
@@ -1039,7 +1589,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param stakedByUser Amount of tokens staked by the user in the distribution at the moment
    * @param totalStaked Total tokens staked in the distribution
    * @return The accrued rewards for the user until the moment
-   **/
+   */
   function _updateUserAssetInternal(
     address user,
     address asset,
@@ -1069,7 +1619,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param user The address of the user
    * @param stakes List of structs of the user data related with his stake
    * @return The accrued rewards for the user until the moment
-   **/
+   */
   function _claimRewards(
     address user,
     DistributionTypes.UserStakeInput[] memory stakes
@@ -1077,14 +1627,14 @@ contract AaveDistributionManager is IAaveDistributionManager {
     uint256 accruedRewards = 0;
 
     for (uint256 i = 0; i < stakes.length; i++) {
-      accruedRewards = accruedRewards.add(
+      accruedRewards =
+        accruedRewards +
         _updateUserAssetInternal(
           user,
           stakes[i].underlyingAsset,
           stakes[i].stakedByUser,
           stakes[i].totalStaked
-        )
-      );
+        );
     }
 
     return accruedRewards;
@@ -1095,7 +1645,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param user The address of the user
    * @param stakes List of structs of the user data related with his stake
    * @return The accrued rewards for the user until the moment
-   **/
+   */
   function _getUnclaimedRewards(
     address user,
     DistributionTypes.UserStakeInput[] memory stakes
@@ -1111,9 +1661,13 @@ contract AaveDistributionManager is IAaveDistributionManager {
         stakes[i].totalStaked
       );
 
-      accruedRewards = accruedRewards.add(
-        _getRewards(stakes[i].stakedByUser, assetIndex, assetConfig.users[user])
-      );
+      accruedRewards =
+        accruedRewards +
+        _getRewards(
+          stakes[i].stakedByUser,
+          assetIndex,
+          assetConfig.users[user]
+        );
     }
     return accruedRewards;
   }
@@ -1124,16 +1678,15 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param reserveIndex Current index of the distribution
    * @param userIndex Index stored for the user, representation his staking moment
    * @return The rewards
-   **/
+   */
   function _getRewards(
     uint256 principalUserBalance,
     uint256 reserveIndex,
     uint256 userIndex
   ) internal pure returns (uint256) {
     return
-      principalUserBalance.mul(reserveIndex.sub(userIndex)).div(
-        10**uint256(PRECISION)
-      );
+      (principalUserBalance * (reserveIndex - userIndex)) /
+      (10**uint256(PRECISION));
   }
 
   /**
@@ -1143,7 +1696,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param lastUpdateTimestamp Last moment this distribution was updated
    * @param totalBalance of tokens considered for the distribution
    * @return The new index.
-   **/
+   */
   function _getAssetIndex(
     uint256 currentIndex,
     uint256 emissionPerSecond,
@@ -1162,13 +1715,10 @@ contract AaveDistributionManager is IAaveDistributionManager {
     uint256 currentTimestamp = block.timestamp > DISTRIBUTION_END
       ? DISTRIBUTION_END
       : block.timestamp;
-    uint256 timeDelta = currentTimestamp.sub(lastUpdateTimestamp);
+    uint256 timeDelta = currentTimestamp - lastUpdateTimestamp;
     return
-      emissionPerSecond
-        .mul(timeDelta)
-        .mul(10**uint256(PRECISION))
-        .div(totalBalance)
-        .add(currentIndex);
+      ((emissionPerSecond * timeDelta * (10**uint256(PRECISION))) /
+        totalBalance) + currentIndex;
   }
 
   /**
@@ -1176,7 +1726,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param user Address of the user
    * @param asset The address of the reference asset of the distribution
    * @return The new index
-   **/
+   */
   function getUserAssetData(address user, address asset)
     public
     view
@@ -1186,332 +1736,12 @@ contract AaveDistributionManager is IAaveDistributionManager {
   }
 }
 
-/**
- * @notice implementation of the AAVE token contract
- * @author Aave
- */
-abstract contract GovernancePowerDelegationERC20 is
-  ERC20,
-  IGovernancePowerDelegationToken
-{
-  using SafeMath for uint256;
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
-  function delegateByType(address delegatee, DelegationType delegationType)
-    external
-    override
-  {
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
-  function getDelegateeByType(address delegator, DelegationType delegationType)
-    external
-    view
-    override
-    returns (address)
-  {
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
-  function getPowerCurrent(address user, DelegationType delegationType)
-    external
-    view
-    override
-    returns (uint256)
-  {
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
-  function totalSupplyAt(uint256 blockNumber)
-    external
-    view
-    override
-    returns (uint256)
-  {
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
+interface ITransferHook {
+  function onTransfer(
     address from,
     address to,
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
-        uint128(previous.sub(amount))
-      );
-
-      emit DelegatedPowerChanged(from, previous.sub(amount), delegationType);
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
-        uint128(previous.add(amount))
-      );
-
-      emit DelegatedPowerChanged(to, previous.add(amount), delegationType);
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
-  ) internal view returns (uint256) {
-    require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
-
-    uint256 snapshotsCount = snapshotsCounts[user];
-
-    if (snapshotsCount == 0) {
-      return balanceOf(user);
-    }
-
-    // First check most recent balance
-    if (snapshots[user][snapshotsCount - 1].blockNumber <= blockNumber) {
-      return snapshots[user][snapshotsCount - 1].value;
-    }
-
-    // Next check implicit zero balance
-    if (snapshots[user][0].blockNumber > blockNumber) {
-      return 0;
-    }
-
-    uint256 lower = 0;
-    uint256 upper = snapshotsCount - 1;
-    while (upper > lower) {
-      uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
-      Snapshot memory snapshot = snapshots[user][center];
-      if (snapshot.blockNumber == blockNumber) {
-        return snapshot.value;
-      } else if (snapshot.blockNumber < blockNumber) {
-        lower = center;
-      } else {
-        upper = center - 1;
-      }
-    }
-    return snapshots[user][lower].value;
-  }
-
-  /**
-   * @dev returns the delegation data (snapshot, snapshotsCount, list of delegates) by delegation type
-   * NOTE: Ideal implementation would have mapped this in a struct by delegation type. Unfortunately,
-   * the AAVE token and StakeToken already include a mapping for the snapshots, so we require contracts
-   * who inherit from this to provide access to the delegation data by overriding this method.
-   * @param delegationType the type of delegation
-   **/
-  function _getDelegationDataByType(DelegationType delegationType)
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
+    uint256 amount
+  ) external;
 }
 
 /**
@@ -1522,8 +1752,6 @@ abstract contract GovernancePowerDelegationERC20 is
 abstract contract GovernancePowerWithSnapshot is
   GovernancePowerDelegationERC20
 {
-  using SafeMath for uint256;
-
   /**
    * @dev The following storage layout points to the prior StakedToken.sol implementation:
    * _snapshots => _votingSnapshots
@@ -1536,42 +1764,34 @@ abstract contract GovernancePowerWithSnapshot is
   /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
   /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
   /// to control all potential reentrancies by calling back the this contract
+  /// @dev DEPRECATED
   ITransferHook public _aaveGovernance;
-
-  function _setAaveGovernance(ITransferHook aaveGovernance) internal virtual {
-    _aaveGovernance = aaveGovernance;
-  }
 }
 
 /**
- * @title StakedToken
+ * @title StakedTokenV2
  * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
- * @author Aave
- **/
-contract StakedTokenV2Rev4 is
-  IStakedAave,
+ * @author BGD Labs
+ */
+abstract contract StakedTokenV2 is
+  IStakedTokenV2,
   GovernancePowerWithSnapshot,
   VersionedInitializable,
   AaveDistributionManager
 {
-  using SafeMath for uint256;
   using SafeERC20 for IERC20;
 
-  /// @dev Start of Storage layout from StakedToken v1
-  uint256 public constant REVISION = 4;
-
   IERC20 public immutable STAKED_TOKEN;
   IERC20 public immutable REWARD_TOKEN;
-  uint256 public immutable COOLDOWN_SECONDS;
 
-  /// @notice Seconds available to redeem once the cooldown period is fullfilled
+  /// @notice Seconds available to redeem once the cooldown period is fulfilled
   uint256 public immutable UNSTAKE_WINDOW;
 
   /// @notice Address to pull from the rewards, needs to have approved this contract
   address public immutable REWARDS_VAULT;
 
   mapping(address => uint256) public stakerRewardsToClaim;
-  mapping(address => uint256) public stakersCooldowns;
+  mapping(address => CooldownSnapshot) public stakersCooldowns;
 
   /// @dev End of Storage layout from StakedToken v1
 
@@ -1597,305 +1817,33 @@ contract StakedTokenV2Rev4 is
   /// @dev owner => next valid nonce to submit with permit()
   mapping(address => uint256) public _nonces;
 
-  event Staked(
-    address indexed from,
-    address indexed onBehalfOf,
-    uint256 amount
-  );
-  event Redeem(address indexed from, address indexed to, uint256 amount);
-
-  event RewardsAccrued(address user, uint256 amount);
-  event RewardsClaimed(
-    address indexed from,
-    address indexed to,
-    uint256 amount
-  );
-
-  event Cooldown(address indexed user);
-  event TokensRescued(
-    address indexed tokenRescued,
-    address indexed aaveMerkleDistributor,
-    uint256 amountRescued
-  );
-
   constructor(
     IERC20 stakedToken,
     IERC20 rewardToken,
-    uint256 cooldownSeconds,
     uint256 unstakeWindow,
     address rewardsVault,
     address emissionManager,
-    uint128 distributionDuration,
-    string memory name,
-    string memory symbol,
-    uint8 decimals
-  )
-    public
-    ERC20(name, symbol)
-    AaveDistributionManager(emissionManager, distributionDuration)
-  {
+    uint128 distributionDuration
+  ) ERC20() AaveDistributionManager(emissionManager, distributionDuration) {
     STAKED_TOKEN = stakedToken;
     REWARD_TOKEN = rewardToken;
-    COOLDOWN_SECONDS = cooldownSeconds;
     UNSTAKE_WINDOW = unstakeWindow;
     REWARDS_VAULT = rewardsVault;
-    _aaveGovernance = ITransferHook(address(0));
-    ERC20._setupDecimals(decimals);
-
-    lastInitializedRevision = REVISION;
-  }
-
-  /**
-   * @dev Called by the proxy contract
-   **/
-  function initialize(
-    address[] memory tokens,
-    uint256[] memory amounts,
-    address aaveMerkleDistributor
-  ) external initializer {
-    // send tokens to distributor
-    require(
-      tokens.length == amounts.length,
-      'initialize(): amounts and tokens lengths inconsistent'
-    );
-    for (uint256 i = 0; i < tokens.length; i++) {
-      IERC20(tokens[i]).safeTransfer(aaveMerkleDistributor, amounts[i]);
-
-      emit TokensRescued(tokens[i], aaveMerkleDistributor, amounts[i]);
-    }
-
-    require(
-      totalSupply() <= STAKED_TOKEN.balanceOf(address(this)),
-      'INVALID_COLLATERALIZATION'
-    );
   }
 
-  function stake(address onBehalfOf, uint256 amount) external override {
-    require(amount != 0, 'INVALID_ZERO_AMOUNT');
-    uint256 balanceOfUser = balanceOf(onBehalfOf);
-
-    uint256 accruedRewards = _updateUserAssetInternal(
-      onBehalfOf,
-      address(this),
-      balanceOfUser,
-      totalSupply()
-    );
-    if (accruedRewards != 0) {
-      emit RewardsAccrued(onBehalfOf, accruedRewards);
-      stakerRewardsToClaim[onBehalfOf] = stakerRewardsToClaim[onBehalfOf].add(
-        accruedRewards
-      );
-    }
-
-    stakersCooldowns[onBehalfOf] = getNextCooldownTimestamp(
-      0,
-      amount,
-      onBehalfOf,
-      balanceOfUser
-    );
-
-    _mint(onBehalfOf, amount);
-    IERC20(STAKED_TOKEN).safeTransferFrom(msg.sender, address(this), amount);
-
-    emit Staked(msg.sender, onBehalfOf, amount);
-  }
+  /// @inheritdoc IStakedTokenV2
+  function stake(address onBehalfOf, uint256 amount) external virtual override;
 
-  /**
-   * @dev Redeems staked tokens, and stop earning rewards
-   * @param to Address to redeem to
-   * @param amount Amount to redeem
-   **/
-  function redeem(address to, uint256 amount) external override {
-    require(amount != 0, 'INVALID_ZERO_AMOUNT');
-    //solium-disable-next-line
-    uint256 cooldownStartTimestamp = stakersCooldowns[msg.sender];
-    require(
-      block.timestamp > cooldownStartTimestamp.add(COOLDOWN_SECONDS),
-      'INSUFFICIENT_COOLDOWN'
-    );
-    require(
-      block.timestamp.sub(cooldownStartTimestamp.add(COOLDOWN_SECONDS)) <=
-        UNSTAKE_WINDOW,
-      'UNSTAKE_WINDOW_FINISHED'
-    );
-    uint256 balanceOfMessageSender = balanceOf(msg.sender);
+  /// @inheritdoc IStakedTokenV2
+  function redeem(address to, uint256 amount) external virtual override;
 
-    uint256 amountToRedeem = (amount > balanceOfMessageSender)
-      ? balanceOfMessageSender
-      : amount;
-
-    _updateCurrentUnclaimedRewards(msg.sender, balanceOfMessageSender, true);
-
-    _burn(msg.sender, amountToRedeem);
-
-    if (balanceOfMessageSender.sub(amountToRedeem) == 0) {
-      stakersCooldowns[msg.sender] = 0;
-    }
-
-    IERC20(STAKED_TOKEN).safeTransfer(to, amountToRedeem);
-
-    emit Redeem(msg.sender, to, amountToRedeem);
-  }
-
-  /**
-   * @dev Activates the cooldown period to unstake
-   * - It can't be called if the user is not staking
-   **/
-  function cooldown() external override {
-    require(balanceOf(msg.sender) != 0, 'INVALID_BALANCE_ON_COOLDOWN');
-    //solium-disable-next-line
-    stakersCooldowns[msg.sender] = block.timestamp;
-
-    emit Cooldown(msg.sender);
-  }
+  /// @inheritdoc IStakedTokenV2
+  function cooldown() external virtual override;
 
-  /**
-   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
-   * @param to Address to stake for
-   * @param amount Amount to stake
-   **/
-  function claimRewards(address to, uint256 amount) external override {
-    uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
-      msg.sender,
-      balanceOf(msg.sender),
-      false
-    );
-    uint256 amountToClaim = (amount == type(uint256).max)
-      ? newTotalRewards
-      : amount;
-
-    stakerRewardsToClaim[msg.sender] = newTotalRewards.sub(
-      amountToClaim,
-      'INVALID_AMOUNT'
-    );
-
-    REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
-
-    emit RewardsClaimed(msg.sender, to, amountToClaim);
-  }
-
-  /**
-   * @dev Internal ERC20 _transfer of the tokenized staked tokens
-   * @param from Address to transfer from
-   * @param to Address to transfer to
-   * @param amount Amount to transfer
-   **/
-  function _transfer(
-    address from,
-    address to,
-    uint256 amount
-  ) internal override {
-    uint256 balanceOfFrom = balanceOf(from);
-    // Sender
-    _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);
-
-    // Recipient
-    if (from != to) {
-      uint256 balanceOfTo = balanceOf(to);
-      _updateCurrentUnclaimedRewards(to, balanceOfTo, true);
-
-      uint256 previousSenderCooldown = stakersCooldowns[from];
-      stakersCooldowns[to] = getNextCooldownTimestamp(
-        previousSenderCooldown,
-        amount,
-        to,
-        balanceOfTo
-      );
-      // if cooldown was set and whole balance of sender was transferred - clear cooldown
-      if (balanceOfFrom == amount && previousSenderCooldown != 0) {
-        stakersCooldowns[from] = 0;
-      }
-    }
-
-    super._transfer(from, to, amount);
-  }
-
-  /**
-   * @dev Updates the user state related with his accrued rewards
-   * @param user Address of the user
-   * @param userBalance The current balance of the user
-   * @param updateStorage Boolean flag used to update or not the stakerRewardsToClaim of the user
-   * @return The unclaimed rewards that were added to the total accrued
-   **/
-  function _updateCurrentUnclaimedRewards(
-    address user,
-    uint256 userBalance,
-    bool updateStorage
-  ) internal returns (uint256) {
-    uint256 accruedRewards = _updateUserAssetInternal(
-      user,
-      address(this),
-      userBalance,
-      totalSupply()
-    );
-    uint256 unclaimedRewards = stakerRewardsToClaim[user].add(accruedRewards);
-
-    if (accruedRewards != 0) {
-      if (updateStorage) {
-        stakerRewardsToClaim[user] = unclaimedRewards;
-      }
-      emit RewardsAccrued(user, accruedRewards);
-    }
-
-    return unclaimedRewards;
-  }
-
-  /**
-   * @dev Calculates the how is gonna be a new cooldown timestamp depending on the sender/receiver situation
-   *  - If the timestamp of the sender is "better" or the timestamp of the recipient is 0, we take the one of the recipient
-   *  - Weighted average of from/to cooldown timestamps if:
-   *    # The sender doesn't have the cooldown activated (timestamp 0).
-   *    # The sender timestamp is expired
-   *    # The sender has a "worse" timestamp
-   *  - If the receiver's cooldown timestamp expired (too old), the next is 0
-   * @param fromCooldownTimestamp Cooldown timestamp of the sender
-   * @param amountToReceive Amount
-   * @param toAddress Address of the recipient
-   * @param toBalance Current balance of the receiver
-   * @return The new cooldown timestamp
-   **/
-  function getNextCooldownTimestamp(
-    uint256 fromCooldownTimestamp,
-    uint256 amountToReceive,
-    address toAddress,
-    uint256 toBalance
-  ) public view returns (uint256) {
-    uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
-    if (toCooldownTimestamp == 0) {
-      return 0;
-    }
-
-    uint256 minimalValidCooldownTimestamp = block
-      .timestamp
-      .sub(COOLDOWN_SECONDS)
-      .sub(UNSTAKE_WINDOW);
-
-    if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
-      toCooldownTimestamp = 0;
-    } else {
-      uint256 fromCooldownTimestamp = (minimalValidCooldownTimestamp >
-        fromCooldownTimestamp)
-        ? block.timestamp
-        : fromCooldownTimestamp;
-
-      if (fromCooldownTimestamp < toCooldownTimestamp) {
-        return toCooldownTimestamp;
-      } else {
-        toCooldownTimestamp = (
-          amountToReceive.mul(fromCooldownTimestamp).add(
-            toBalance.mul(toCooldownTimestamp)
-          )
-        ).div(amountToReceive.add(toBalance));
-      }
-    }
-    return toCooldownTimestamp;
-  }
+  /// @inheritdoc IStakedTokenV2
+  function claimRewards(address to, uint256 amount) external virtual override;
 
-  /**
-   * @dev Return the total rewards pending to claim by an staker
-   * @param staker The staker address
-   * @return The rewards
-   */
+  /// @inheritdoc IStakedTokenV2
   function getTotalRewardsBalance(address staker)
     external
     view
@@ -1909,30 +1857,11 @@ contract StakedTokenV2Rev4 is
       totalStaked: totalSupply()
     });
     return
-      stakerRewardsToClaim[staker].add(
-        _getUnclaimedRewards(staker, userStakeInputs)
-      );
+      stakerRewardsToClaim[staker] +
+      _getUnclaimedRewards(staker, userStakeInputs);
   }
 
-  /**
-   * @dev returns the revision of the implementation contract
-   * @return The revision
-   */
-  function getRevision() internal pure override returns (uint256) {
-    return REVISION;
-  }
-
-  /**
-   * @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
-   * @param owner the owner of the funds
-   * @param spender the spender
-   * @param value the amount
-   * @param deadline the deadline timestamp, type(uint256).max for no deadline
-   * @param v signature param
-   * @param s signature param
-   * @param r signature param
-   */
-
+  /// @inheritdoc IStakedTokenV2
   function permit(
     address owner,
     address spender,
@@ -1964,10 +1893,2426 @@ contract StakedTokenV2Rev4 is
     );
 
     require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
-    _nonces[owner] = currentValidNonce.add(1);
+    unchecked {
+      _nonces[owner] = currentValidNonce + 1;
+    }
     _approve(owner, spender, value);
   }
 
+  /**
+   * @dev Delegates power from signatory to `delegatee`
+   * @param delegatee The address to delegate votes to
+   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
+   * @param nonce The contract state required to match the signature
+   * @param expiry The time at which to expire the signature
+   * @param v The recovery byte of the signature
+   * @param r Half of the ECDSA signature pair
+   * @param s Half of the ECDSA signature pair
+   */
+  function delegateByTypeBySig(
+    address delegatee,
+    DelegationType delegationType,
+    uint256 nonce,
+    uint256 expiry,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) public {
+    bytes32 structHash = keccak256(
+      abi.encode(
+        DELEGATE_BY_TYPE_TYPEHASH,
+        delegatee,
+        uint256(delegationType),
+        nonce,
+        expiry
+      )
+    );
+    bytes32 digest = keccak256(
+      abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash)
+    );
+    address signatory = ecrecover(digest, v, r, s);
+    require(signatory != address(0), 'INVALID_SIGNATURE');
+    require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
+    require(block.timestamp <= expiry, 'INVALID_EXPIRATION');
+    _delegateByType(signatory, delegatee, delegationType);
+  }
+
+  /**
+   * @dev Delegates power from signatory to `delegatee`
+   * @param delegatee The address to delegate votes to
+   * @param nonce The contract state required to match the signature
+   * @param expiry The time at which to expire the signature
+   * @param v The recovery byte of the signature
+   * @param r Half of the ECDSA signature pair
+   * @param s Half of the ECDSA signature pair
+   */
+  function delegateBySig(
+    address delegatee,
+    uint256 nonce,
+    uint256 expiry,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) public {
+    bytes32 structHash = keccak256(
+      abi.encode(DELEGATE_TYPEHASH, delegatee, nonce, expiry)
+    );
+    bytes32 digest = keccak256(
+      abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash)
+    );
+    address signatory = ecrecover(digest, v, r, s);
+    require(signatory != address(0), 'INVALID_SIGNATURE');
+    require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
+    require(block.timestamp <= expiry, 'INVALID_EXPIRATION');
+    _delegateByType(signatory, delegatee, DelegationType.VOTING_POWER);
+    _delegateByType(signatory, delegatee, DelegationType.PROPOSITION_POWER);
+  }
+
+  /**
+   * @dev Updates the user state related with his accrued rewards
+   * @param user Address of the user
+   * @param userBalance The current balance of the user
+   * @param updateStorage Boolean flag used to update or not the stakerRewardsToClaim of the user
+   * @return The unclaimed rewards that were added to the total accrued
+   */
+  function _updateCurrentUnclaimedRewards(
+    address user,
+    uint256 userBalance,
+    bool updateStorage
+  ) internal returns (uint256) {
+    uint256 accruedRewards = _updateUserAssetInternal(
+      user,
+      address(this),
+      userBalance,
+      totalSupply()
+    );
+    uint256 unclaimedRewards = stakerRewardsToClaim[user] + accruedRewards;
+
+    if (accruedRewards != 0) {
+      if (updateStorage) {
+        stakerRewardsToClaim[user] = unclaimedRewards;
+      }
+      emit RewardsAccrued(user, accruedRewards);
+    }
+
+    return unclaimedRewards;
+  }
+
+  /**
+   * @dev returns relevant storage slots for a DelegationType
+   * @param delegationType the requested DelegationType
+   * @return the relevant storage
+   */
+  function _getDelegationDataByType(DelegationType delegationType)
+    internal
+    view
+    override
+    returns (
+      mapping(address => mapping(uint256 => Snapshot)) storage, //snapshots
+      mapping(address => uint256) storage, //snapshots count
+      mapping(address => address) storage //delegatees list
+    )
+  {
+    if (delegationType == DelegationType.VOTING_POWER) {
+      return (_votingSnapshots, _votingSnapshotsCounts, _votingDelegates);
+    } else {
+      return (
+        _propositionPowerSnapshots,
+        _propositionPowerSnapshotsCounts,
+        _propositionPowerDelegates
+      );
+    }
+  }
+}
+
+interface IStakedTokenV3 is IStakedTokenV2 {
+  event Staked(
+    address indexed from,
+    address indexed to,
+    uint256 assets,
+    uint256 shares
+  );
+  event Redeem(
+    address indexed from,
+    address indexed to,
+    uint256 assets,
+    uint256 shares
+  );
+  event MaxSlashablePercentageChanged(uint256 newPercentage);
+  event Slashed(address indexed destination, uint256 amount);
+  event SlashingExitWindowDurationChanged(uint256 windowSeconds);
+  event CooldownSecondsChanged(uint256 cooldownSeconds);
+  event ExchangeRateChanged(uint216 exchangeRate);
+  event FundsReturned(uint256 amount);
+  event SlashingSettled();
+
+  /**
+   * @dev Returns the current exchange rate
+   * @return exchangeRate as 18 decimal precision uint216
+   */
+  function getExchangeRate() external view returns (uint216);
+
+  /**
+   * @dev Executes a slashing of the underlying of a certain amount, transferring the seized funds
+   * to destination. Decreasing the amount of underlying will automatically adjust the exchange rate.
+   * A call to `slash` will start a slashing event which has to be settled via `settleSlashing`.
+   * As long as the slashing event is ongoing, stake and slash are deactivated.
+   * - MUST NOT be called when a previous slashing is still ongoing
+   * @param destination the address where seized funds will be transferred
+   * @param amount the amount to be slashed
+   * - if the amount bigger than maximum allowed, the maximum will be slashed instead.
+   * @return amount the amount slashed
+   */
+  function slash(address destination, uint256 amount)
+    external
+    returns (uint256);
+
+  /**
+   * @dev Settles an ongoing slashing event
+   */
+  function settleSlashing() external;
+
+  /**
+   * @dev Pulls STAKE_TOKEN and distributes them amongst current stakers by altering the exchange rate.
+   * This method is permissionless and intended to be used after a slashing event to return potential excess funds.
+   * @param amount amount of STAKE_TOKEN to pull.
+   */
+  function returnFunds(uint256 amount) external;
+
+  /**
+   * @dev Getter of the cooldown seconds
+   * @return cooldownSeconds the amount of seconds between starting the cooldown and being able to redeem
+   */
+  function getCooldownSeconds() external view returns (uint256);
+
+  /**
+   * @dev Getter of the cooldown seconds
+   * @return cooldownSeconds the amount of seconds between starting the cooldown and being able to redeem
+   */
+  function COOLDOWN_SECONDS() external view returns (uint256); // @deprecated
+
+  /**
+   * @dev Setter of cooldown seconds
+   * Can only be called by the cooldown admin
+   * @param cooldownSeconds the new amount of seconds you have to wait between starting the cooldown and being able to redeem
+   */
+  function setCooldownSeconds(uint256 cooldownSeconds) external;
+
+  /**
+   * @dev Getter of the max slashable percentage of the total staked amount.
+   * @return percentage the maximum slashable percentage
+   */
+  function getMaxSlashablePercentage() external view returns (uint256);
+
+  /**
+   * @dev Setter of max slashable percentage of the total staked amount.
+   * Can only be called by the slashing admin
+   * @param percentage the new maximum slashable percentage
+   */
+  function setMaxSlashablePercentage(uint256 percentage) external;
+
+  /**
+   * @dev returns the exact amount of shares that would be received for the provided number of assets
+   * @param assets the number of assets to stake
+   * @return uint256 shares the number of shares that would be received
+   */
+  function previewStake(uint256 assets) external view returns (uint256);
+
+  /**
+   * @dev Activates the cooldown period to unstake
+   * - It can't be called if the user is not staking
+   */
+  function cooldownOnBehalfOf(address from) external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to` on behalf of the user. Only the claim helper contract is allowed to call this function
+   * @param from The address of the user from to claim
+   * @param to Address to send the claimed rewards
+   * @param amount Amount to claim
+   */
+  function claimRewardsOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external returns (uint256);
+
+  /**
+   * @dev returns the exact amount of assets that would be redeemed for the provided number of shares
+   * @param shares the number of shares to redeem
+   * @return uint256 assets the number of assets that would be redeemed
+   */
+  function previewRedeem(uint256 shares) external view returns (uint256);
+
+  /**
+   * @dev Redeems shares for a user. Only the claim helper contract is allowed to call this function
+   * @param from Address to redeem from
+   * @param to Address to redeem to
+   * @param amount Amount of shares to redeem
+   */
+  function redeemOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and redeems to the provided address
+   * @param to Address to claim and redeem to
+   * @param claimAmount Amount to claim
+   * @param redeemAmount Amount to redeem
+   */
+  function claimRewardsAndRedeem(
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and redeems the `redeemAmount` to an address. Only the claim helper contract is allowed to call this function
+   * @param from The address of the from
+   * @param to Address to claim and redeem to
+   * @param claimAmount Amount to claim
+   * @param redeemAmount Amount to redeem
+   */
+  function claimRewardsAndRedeemOnBehalf(
+    address from,
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external;
+}
+
+/**
+ * @title PercentageMath library
+ * @author Aave
+ * @notice Provides functions to perform percentage calculations
+ * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
+ * @dev Operations are rounded half up
+ **/
+
+library PercentageMath {
+  uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
+  uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;
+
+  /**
+   * @dev Executes a percentage multiplication
+   * @param value The value of which the percentage needs to be calculated
+   * @param percentage The percentage of the value to be calculated
+   * @return The percentage of value
+   **/
+  function percentMul(uint256 value, uint256 percentage)
+    internal
+    pure
+    returns (uint256)
+  {
+    if (value == 0 || percentage == 0) {
+      return 0;
+    }
+
+    require(
+      value <= (type(uint256).max) / percentage,
+      'MATH_MULTIPLICATION_OVERFLOW'
+    );
+
+    return (value * percentage) / PERCENTAGE_FACTOR;
+  }
+
+  /**
+   * @dev Executes a percentage division
+   * @param value The value of which the percentage needs to be calculated
+   * @param percentage The percentage of the value to be calculated
+   * @return The value divided the percentage
+   **/
+  function percentDiv(uint256 value, uint256 percentage)
+    internal
+    pure
+    returns (uint256)
+  {
+    require(percentage != 0, 'MATH_DIVISION_BY_ZERO');
+
+    require(
+      value <= type(uint256).max / PERCENTAGE_FACTOR,
+      'MATH_MULTIPLICATION_OVERFLOW'
+    );
+
+    return (value * PERCENTAGE_FACTOR) / percentage;
+  }
+}
+
+/**
+ * @title RoleManager
+ * @notice Generic role manager to manage slashing and cooldown admin in StakedAaveV3.
+ *         It implements a claim admin role pattern to safely migrate between different admin addresses
+ * @author Aave
+ **/
+contract RoleManager {
+  struct InitAdmin {
+    uint256 role;
+    address admin;
+  }
+
+  mapping(uint256 => address) private _admins;
+  mapping(uint256 => address) private _pendingAdmins;
+
+  event PendingAdminChanged(address indexed newPendingAdmin, uint256 role);
+  event RoleClaimed(address indexed newAdmin, uint256 role);
+
+  modifier onlyRoleAdmin(uint256 role) {
+    require(_admins[role] == msg.sender, 'CALLER_NOT_ROLE_ADMIN');
+    _;
+  }
+
+  modifier onlyPendingRoleAdmin(uint256 role) {
+    require(
+      _pendingAdmins[role] == msg.sender,
+      'CALLER_NOT_PENDING_ROLE_ADMIN'
+    );
+    _;
+  }
+
+  /**
+   * @dev returns the admin associated with the specific role
+   * @param role the role associated with the admin being returned
+   **/
+  function getAdmin(uint256 role) public view returns (address) {
+    return _admins[role];
+  }
+
+  /**
+   * @dev returns the pending admin associated with the specific role
+   * @param role the role associated with the pending admin being returned
+   **/
+  function getPendingAdmin(uint256 role) public view returns (address) {
+    return _pendingAdmins[role];
+  }
+
+  /**
+   * @dev sets the pending admin for a specific role
+   * @param role the role associated with the new pending admin being set
+   * @param newPendingAdmin the address of the new pending admin
+   **/
+  function setPendingAdmin(uint256 role, address newPendingAdmin)
+    public
+    onlyRoleAdmin(role)
+  {
+    _pendingAdmins[role] = newPendingAdmin;
+    emit PendingAdminChanged(newPendingAdmin, role);
+  }
+
+  /**
+   * @dev allows the caller to become a specific role admin
+   * @param role the role associated with the admin claiming the new role
+   **/
+  function claimRoleAdmin(uint256 role) external onlyPendingRoleAdmin(role) {
+    _admins[role] = msg.sender;
+    _pendingAdmins[role] = address(0);
+    emit RoleClaimed(msg.sender, role);
+  }
+
+  function _initAdmins(InitAdmin[] memory initAdmins) internal {
+    for (uint256 i = 0; i < initAdmins.length; i++) {
+      require(
+        _admins[initAdmins[i].role] == address(0) &&
+          initAdmins[i].admin != address(0),
+        'ADMIN_CANNOT_BE_INITIALIZED'
+      );
+      _admins[initAdmins[i].role] = initAdmins[i].admin;
+      emit RoleClaimed(initAdmins[i].admin, initAdmins[i].role);
+    }
+  }
+}
+
+// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
+// This file was procedurally generated from scripts/generate/templates/SafeCast.js.
+
+/**
+ * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
+ * checks.
+ *
+ * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
+ * easily result in undesired exploitation or bugs, since developers usually
+ * assume that overflows raise errors. `SafeCast` restores this intuition by
+ * reverting the transaction when such an operation overflows.
+ *
+ * Using this library instead of the unchecked operations eliminates an entire
+ * class of bugs, so it's recommended to use it always.
+ *
+ * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
+ * all math on `uint256` and `int256` and then downcasting.
+ */
+library SafeCast {
+  /**
+   * @dev Returns the downcasted uint248 from uint256, reverting on
+   * overflow (when the input is greater than largest uint248).
+   *
+   * Counterpart to Solidity's `uint248` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 248 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint248(uint256 value) internal pure returns (uint248) {
+    require(
+      value <= type(uint248).max,
+      "SafeCast: value doesn't fit in 248 bits"
+    );
+    return uint248(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint240 from uint256, reverting on
+   * overflow (when the input is greater than largest uint240).
+   *
+   * Counterpart to Solidity's `uint240` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 240 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint240(uint256 value) internal pure returns (uint240) {
+    require(
+      value <= type(uint240).max,
+      "SafeCast: value doesn't fit in 240 bits"
+    );
+    return uint240(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint232 from uint256, reverting on
+   * overflow (when the input is greater than largest uint232).
+   *
+   * Counterpart to Solidity's `uint232` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 232 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint232(uint256 value) internal pure returns (uint232) {
+    require(
+      value <= type(uint232).max,
+      "SafeCast: value doesn't fit in 232 bits"
+    );
+    return uint232(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint224 from uint256, reverting on
+   * overflow (when the input is greater than largest uint224).
+   *
+   * Counterpart to Solidity's `uint224` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 224 bits
+   *
+   * _Available since v4.2._
+   */
+  function toUint224(uint256 value) internal pure returns (uint224) {
+    require(
+      value <= type(uint224).max,
+      "SafeCast: value doesn't fit in 224 bits"
+    );
+    return uint224(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint216 from uint256, reverting on
+   * overflow (when the input is greater than largest uint216).
+   *
+   * Counterpart to Solidity's `uint216` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 216 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint216(uint256 value) internal pure returns (uint216) {
+    require(
+      value <= type(uint216).max,
+      "SafeCast: value doesn't fit in 216 bits"
+    );
+    return uint216(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint208 from uint256, reverting on
+   * overflow (when the input is greater than largest uint208).
+   *
+   * Counterpart to Solidity's `uint208` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 208 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint208(uint256 value) internal pure returns (uint208) {
+    require(
+      value <= type(uint208).max,
+      "SafeCast: value doesn't fit in 208 bits"
+    );
+    return uint208(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint200 from uint256, reverting on
+   * overflow (when the input is greater than largest uint200).
+   *
+   * Counterpart to Solidity's `uint200` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 200 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint200(uint256 value) internal pure returns (uint200) {
+    require(
+      value <= type(uint200).max,
+      "SafeCast: value doesn't fit in 200 bits"
+    );
+    return uint200(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint192 from uint256, reverting on
+   * overflow (when the input is greater than largest uint192).
+   *
+   * Counterpart to Solidity's `uint192` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 192 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint192(uint256 value) internal pure returns (uint192) {
+    require(
+      value <= type(uint192).max,
+      "SafeCast: value doesn't fit in 192 bits"
+    );
+    return uint192(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint184 from uint256, reverting on
+   * overflow (when the input is greater than largest uint184).
+   *
+   * Counterpart to Solidity's `uint184` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 184 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint184(uint256 value) internal pure returns (uint184) {
+    require(
+      value <= type(uint184).max,
+      "SafeCast: value doesn't fit in 184 bits"
+    );
+    return uint184(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint176 from uint256, reverting on
+   * overflow (when the input is greater than largest uint176).
+   *
+   * Counterpart to Solidity's `uint176` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 176 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint176(uint256 value) internal pure returns (uint176) {
+    require(
+      value <= type(uint176).max,
+      "SafeCast: value doesn't fit in 176 bits"
+    );
+    return uint176(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint168 from uint256, reverting on
+   * overflow (when the input is greater than largest uint168).
+   *
+   * Counterpart to Solidity's `uint168` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 168 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint168(uint256 value) internal pure returns (uint168) {
+    require(
+      value <= type(uint168).max,
+      "SafeCast: value doesn't fit in 168 bits"
+    );
+    return uint168(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint160 from uint256, reverting on
+   * overflow (when the input is greater than largest uint160).
+   *
+   * Counterpart to Solidity's `uint160` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 160 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint160(uint256 value) internal pure returns (uint160) {
+    require(
+      value <= type(uint160).max,
+      "SafeCast: value doesn't fit in 160 bits"
+    );
+    return uint160(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint152 from uint256, reverting on
+   * overflow (when the input is greater than largest uint152).
+   *
+   * Counterpart to Solidity's `uint152` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 152 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint152(uint256 value) internal pure returns (uint152) {
+    require(
+      value <= type(uint152).max,
+      "SafeCast: value doesn't fit in 152 bits"
+    );
+    return uint152(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint144 from uint256, reverting on
+   * overflow (when the input is greater than largest uint144).
+   *
+   * Counterpart to Solidity's `uint144` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 144 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint144(uint256 value) internal pure returns (uint144) {
+    require(
+      value <= type(uint144).max,
+      "SafeCast: value doesn't fit in 144 bits"
+    );
+    return uint144(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint136 from uint256, reverting on
+   * overflow (when the input is greater than largest uint136).
+   *
+   * Counterpart to Solidity's `uint136` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 136 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint136(uint256 value) internal pure returns (uint136) {
+    require(
+      value <= type(uint136).max,
+      "SafeCast: value doesn't fit in 136 bits"
+    );
+    return uint136(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint128 from uint256, reverting on
+   * overflow (when the input is greater than largest uint128).
+   *
+   * Counterpart to Solidity's `uint128` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 128 bits
+   *
+   * _Available since v2.5._
+   */
+  function toUint128(uint256 value) internal pure returns (uint128) {
+    require(
+      value <= type(uint128).max,
+      "SafeCast: value doesn't fit in 128 bits"
+    );
+    return uint128(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint120 from uint256, reverting on
+   * overflow (when the input is greater than largest uint120).
+   *
+   * Counterpart to Solidity's `uint120` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 120 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint120(uint256 value) internal pure returns (uint120) {
+    require(
+      value <= type(uint120).max,
+      "SafeCast: value doesn't fit in 120 bits"
+    );
+    return uint120(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint112 from uint256, reverting on
+   * overflow (when the input is greater than largest uint112).
+   *
+   * Counterpart to Solidity's `uint112` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 112 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint112(uint256 value) internal pure returns (uint112) {
+    require(
+      value <= type(uint112).max,
+      "SafeCast: value doesn't fit in 112 bits"
+    );
+    return uint112(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint104 from uint256, reverting on
+   * overflow (when the input is greater than largest uint104).
+   *
+   * Counterpart to Solidity's `uint104` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 104 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint104(uint256 value) internal pure returns (uint104) {
+    require(
+      value <= type(uint104).max,
+      "SafeCast: value doesn't fit in 104 bits"
+    );
+    return uint104(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint96 from uint256, reverting on
+   * overflow (when the input is greater than largest uint96).
+   *
+   * Counterpart to Solidity's `uint96` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 96 bits
+   *
+   * _Available since v4.2._
+   */
+  function toUint96(uint256 value) internal pure returns (uint96) {
+    require(
+      value <= type(uint96).max,
+      "SafeCast: value doesn't fit in 96 bits"
+    );
+    return uint96(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint88 from uint256, reverting on
+   * overflow (when the input is greater than largest uint88).
+   *
+   * Counterpart to Solidity's `uint88` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 88 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint88(uint256 value) internal pure returns (uint88) {
+    require(
+      value <= type(uint88).max,
+      "SafeCast: value doesn't fit in 88 bits"
+    );
+    return uint88(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint80 from uint256, reverting on
+   * overflow (when the input is greater than largest uint80).
+   *
+   * Counterpart to Solidity's `uint80` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 80 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint80(uint256 value) internal pure returns (uint80) {
+    require(
+      value <= type(uint80).max,
+      "SafeCast: value doesn't fit in 80 bits"
+    );
+    return uint80(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint72 from uint256, reverting on
+   * overflow (when the input is greater than largest uint72).
+   *
+   * Counterpart to Solidity's `uint72` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 72 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint72(uint256 value) internal pure returns (uint72) {
+    require(
+      value <= type(uint72).max,
+      "SafeCast: value doesn't fit in 72 bits"
+    );
+    return uint72(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint64 from uint256, reverting on
+   * overflow (when the input is greater than largest uint64).
+   *
+   * Counterpart to Solidity's `uint64` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 64 bits
+   *
+   * _Available since v2.5._
+   */
+  function toUint64(uint256 value) internal pure returns (uint64) {
+    require(
+      value <= type(uint64).max,
+      "SafeCast: value doesn't fit in 64 bits"
+    );
+    return uint64(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint56 from uint256, reverting on
+   * overflow (when the input is greater than largest uint56).
+   *
+   * Counterpart to Solidity's `uint56` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 56 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint56(uint256 value) internal pure returns (uint56) {
+    require(
+      value <= type(uint56).max,
+      "SafeCast: value doesn't fit in 56 bits"
+    );
+    return uint56(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint48 from uint256, reverting on
+   * overflow (when the input is greater than largest uint48).
+   *
+   * Counterpart to Solidity's `uint48` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 48 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint48(uint256 value) internal pure returns (uint48) {
+    require(
+      value <= type(uint48).max,
+      "SafeCast: value doesn't fit in 48 bits"
+    );
+    return uint48(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint40 from uint256, reverting on
+   * overflow (when the input is greater than largest uint40).
+   *
+   * Counterpart to Solidity's `uint40` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 40 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint40(uint256 value) internal pure returns (uint40) {
+    require(
+      value <= type(uint40).max,
+      "SafeCast: value doesn't fit in 40 bits"
+    );
+    return uint40(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint32 from uint256, reverting on
+   * overflow (when the input is greater than largest uint32).
+   *
+   * Counterpart to Solidity's `uint32` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 32 bits
+   *
+   * _Available since v2.5._
+   */
+  function toUint32(uint256 value) internal pure returns (uint32) {
+    require(
+      value <= type(uint32).max,
+      "SafeCast: value doesn't fit in 32 bits"
+    );
+    return uint32(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint24 from uint256, reverting on
+   * overflow (when the input is greater than largest uint24).
+   *
+   * Counterpart to Solidity's `uint24` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 24 bits
+   *
+   * _Available since v4.7._
+   */
+  function toUint24(uint256 value) internal pure returns (uint24) {
+    require(
+      value <= type(uint24).max,
+      "SafeCast: value doesn't fit in 24 bits"
+    );
+    return uint24(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint16 from uint256, reverting on
+   * overflow (when the input is greater than largest uint16).
+   *
+   * Counterpart to Solidity's `uint16` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 16 bits
+   *
+   * _Available since v2.5._
+   */
+  function toUint16(uint256 value) internal pure returns (uint16) {
+    require(
+      value <= type(uint16).max,
+      "SafeCast: value doesn't fit in 16 bits"
+    );
+    return uint16(value);
+  }
+
+  /**
+   * @dev Returns the downcasted uint8 from uint256, reverting on
+   * overflow (when the input is greater than largest uint8).
+   *
+   * Counterpart to Solidity's `uint8` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 8 bits
+   *
+   * _Available since v2.5._
+   */
+  function toUint8(uint256 value) internal pure returns (uint8) {
+    require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
+    return uint8(value);
+  }
+
+  /**
+   * @dev Converts a signed int256 into an unsigned uint256.
+   *
+   * Requirements:
+   *
+   * - input must be greater than or equal to 0.
+   *
+   * _Available since v3.0._
+   */
+  function toUint256(int256 value) internal pure returns (uint256) {
+    require(value >= 0, 'SafeCast: value must be positive');
+    return uint256(value);
+  }
+
+  /**
+   * @dev Returns the downcasted int248 from int256, reverting on
+   * overflow (when the input is less than smallest int248 or
+   * greater than largest int248).
+   *
+   * Counterpart to Solidity's `int248` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 248 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt248(int256 value) internal pure returns (int248 downcasted) {
+    downcasted = int248(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int240 from int256, reverting on
+   * overflow (when the input is less than smallest int240 or
+   * greater than largest int240).
+   *
+   * Counterpart to Solidity's `int240` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 240 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt240(int256 value) internal pure returns (int240 downcasted) {
+    downcasted = int240(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int232 from int256, reverting on
+   * overflow (when the input is less than smallest int232 or
+   * greater than largest int232).
+   *
+   * Counterpart to Solidity's `int232` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 232 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt232(int256 value) internal pure returns (int232 downcasted) {
+    downcasted = int232(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int224 from int256, reverting on
+   * overflow (when the input is less than smallest int224 or
+   * greater than largest int224).
+   *
+   * Counterpart to Solidity's `int224` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 224 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt224(int256 value) internal pure returns (int224 downcasted) {
+    downcasted = int224(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int216 from int256, reverting on
+   * overflow (when the input is less than smallest int216 or
+   * greater than largest int216).
+   *
+   * Counterpart to Solidity's `int216` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 216 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt216(int256 value) internal pure returns (int216 downcasted) {
+    downcasted = int216(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int208 from int256, reverting on
+   * overflow (when the input is less than smallest int208 or
+   * greater than largest int208).
+   *
+   * Counterpart to Solidity's `int208` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 208 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt208(int256 value) internal pure returns (int208 downcasted) {
+    downcasted = int208(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int200 from int256, reverting on
+   * overflow (when the input is less than smallest int200 or
+   * greater than largest int200).
+   *
+   * Counterpart to Solidity's `int200` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 200 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt200(int256 value) internal pure returns (int200 downcasted) {
+    downcasted = int200(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int192 from int256, reverting on
+   * overflow (when the input is less than smallest int192 or
+   * greater than largest int192).
+   *
+   * Counterpart to Solidity's `int192` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 192 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt192(int256 value) internal pure returns (int192 downcasted) {
+    downcasted = int192(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int184 from int256, reverting on
+   * overflow (when the input is less than smallest int184 or
+   * greater than largest int184).
+   *
+   * Counterpart to Solidity's `int184` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 184 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt184(int256 value) internal pure returns (int184 downcasted) {
+    downcasted = int184(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int176 from int256, reverting on
+   * overflow (when the input is less than smallest int176 or
+   * greater than largest int176).
+   *
+   * Counterpart to Solidity's `int176` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 176 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt176(int256 value) internal pure returns (int176 downcasted) {
+    downcasted = int176(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int168 from int256, reverting on
+   * overflow (when the input is less than smallest int168 or
+   * greater than largest int168).
+   *
+   * Counterpart to Solidity's `int168` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 168 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt168(int256 value) internal pure returns (int168 downcasted) {
+    downcasted = int168(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int160 from int256, reverting on
+   * overflow (when the input is less than smallest int160 or
+   * greater than largest int160).
+   *
+   * Counterpart to Solidity's `int160` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 160 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt160(int256 value) internal pure returns (int160 downcasted) {
+    downcasted = int160(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int152 from int256, reverting on
+   * overflow (when the input is less than smallest int152 or
+   * greater than largest int152).
+   *
+   * Counterpart to Solidity's `int152` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 152 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt152(int256 value) internal pure returns (int152 downcasted) {
+    downcasted = int152(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int144 from int256, reverting on
+   * overflow (when the input is less than smallest int144 or
+   * greater than largest int144).
+   *
+   * Counterpart to Solidity's `int144` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 144 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt144(int256 value) internal pure returns (int144 downcasted) {
+    downcasted = int144(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int136 from int256, reverting on
+   * overflow (when the input is less than smallest int136 or
+   * greater than largest int136).
+   *
+   * Counterpart to Solidity's `int136` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 136 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt136(int256 value) internal pure returns (int136 downcasted) {
+    downcasted = int136(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int128 from int256, reverting on
+   * overflow (when the input is less than smallest int128 or
+   * greater than largest int128).
+   *
+   * Counterpart to Solidity's `int128` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 128 bits
+   *
+   * _Available since v3.1._
+   */
+  function toInt128(int256 value) internal pure returns (int128 downcasted) {
+    downcasted = int128(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int120 from int256, reverting on
+   * overflow (when the input is less than smallest int120 or
+   * greater than largest int120).
+   *
+   * Counterpart to Solidity's `int120` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 120 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt120(int256 value) internal pure returns (int120 downcasted) {
+    downcasted = int120(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int112 from int256, reverting on
+   * overflow (when the input is less than smallest int112 or
+   * greater than largest int112).
+   *
+   * Counterpart to Solidity's `int112` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 112 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt112(int256 value) internal pure returns (int112 downcasted) {
+    downcasted = int112(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int104 from int256, reverting on
+   * overflow (when the input is less than smallest int104 or
+   * greater than largest int104).
+   *
+   * Counterpart to Solidity's `int104` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 104 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt104(int256 value) internal pure returns (int104 downcasted) {
+    downcasted = int104(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int96 from int256, reverting on
+   * overflow (when the input is less than smallest int96 or
+   * greater than largest int96).
+   *
+   * Counterpart to Solidity's `int96` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 96 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt96(int256 value) internal pure returns (int96 downcasted) {
+    downcasted = int96(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int88 from int256, reverting on
+   * overflow (when the input is less than smallest int88 or
+   * greater than largest int88).
+   *
+   * Counterpart to Solidity's `int88` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 88 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt88(int256 value) internal pure returns (int88 downcasted) {
+    downcasted = int88(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int80 from int256, reverting on
+   * overflow (when the input is less than smallest int80 or
+   * greater than largest int80).
+   *
+   * Counterpart to Solidity's `int80` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 80 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt80(int256 value) internal pure returns (int80 downcasted) {
+    downcasted = int80(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int72 from int256, reverting on
+   * overflow (when the input is less than smallest int72 or
+   * greater than largest int72).
+   *
+   * Counterpart to Solidity's `int72` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 72 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt72(int256 value) internal pure returns (int72 downcasted) {
+    downcasted = int72(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int64 from int256, reverting on
+   * overflow (when the input is less than smallest int64 or
+   * greater than largest int64).
+   *
+   * Counterpart to Solidity's `int64` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 64 bits
+   *
+   * _Available since v3.1._
+   */
+  function toInt64(int256 value) internal pure returns (int64 downcasted) {
+    downcasted = int64(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int56 from int256, reverting on
+   * overflow (when the input is less than smallest int56 or
+   * greater than largest int56).
+   *
+   * Counterpart to Solidity's `int56` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 56 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt56(int256 value) internal pure returns (int56 downcasted) {
+    downcasted = int56(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int48 from int256, reverting on
+   * overflow (when the input is less than smallest int48 or
+   * greater than largest int48).
+   *
+   * Counterpart to Solidity's `int48` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 48 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt48(int256 value) internal pure returns (int48 downcasted) {
+    downcasted = int48(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int40 from int256, reverting on
+   * overflow (when the input is less than smallest int40 or
+   * greater than largest int40).
+   *
+   * Counterpart to Solidity's `int40` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 40 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt40(int256 value) internal pure returns (int40 downcasted) {
+    downcasted = int40(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int32 from int256, reverting on
+   * overflow (when the input is less than smallest int32 or
+   * greater than largest int32).
+   *
+   * Counterpart to Solidity's `int32` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 32 bits
+   *
+   * _Available since v3.1._
+   */
+  function toInt32(int256 value) internal pure returns (int32 downcasted) {
+    downcasted = int32(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int24 from int256, reverting on
+   * overflow (when the input is less than smallest int24 or
+   * greater than largest int24).
+   *
+   * Counterpart to Solidity's `int24` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 24 bits
+   *
+   * _Available since v4.7._
+   */
+  function toInt24(int256 value) internal pure returns (int24 downcasted) {
+    downcasted = int24(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int16 from int256, reverting on
+   * overflow (when the input is less than smallest int16 or
+   * greater than largest int16).
+   *
+   * Counterpart to Solidity's `int16` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 16 bits
+   *
+   * _Available since v3.1._
+   */
+  function toInt16(int256 value) internal pure returns (int16 downcasted) {
+    downcasted = int16(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
+  }
+
+  /**
+   * @dev Returns the downcasted int8 from int256, reverting on
+   * overflow (when the input is less than smallest int8 or
+   * greater than largest int8).
+   *
+   * Counterpart to Solidity's `int8` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 8 bits
+   *
+   * _Available since v3.1._
+   */
+  function toInt8(int256 value) internal pure returns (int8 downcasted) {
+    downcasted = int8(value);
+    require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
+  }
+
+  /**
+   * @dev Converts an unsigned uint256 into a signed int256.
+   *
+   * Requirements:
+   *
+   * - input must be less than or equal to maxInt256.
+   *
+   * _Available since v3.0._
+   */
+  function toInt256(uint256 value) internal pure returns (int256) {
+    // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
+    require(
+      value <= uint256(type(int256).max),
+      "SafeCast: value doesn't fit in an int256"
+    );
+    return int256(value);
+  }
+}
+
+/**
+ * @title StakedTokenV3
+ * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
+ * @author BGD Labs
+ */
+contract StakedTokenV3 is
+  StakedTokenV2,
+  IStakedTokenV3,
+  RoleManager,
+  IAaveDistributionManager
+{
+  using SafeERC20 for IERC20;
+  using PercentageMath for uint256;
+  using SafeCast for uint256;
+
+  uint256 public constant SLASH_ADMIN_ROLE = 0;
+  uint256 public constant COOLDOWN_ADMIN_ROLE = 1;
+  uint256 public constant CLAIM_HELPER_ROLE = 2;
+  uint216 public constant INITIAL_EXCHANGE_RATE = 1e18;
+  uint256 public constant EXCHANGE_RATE_UNIT = 1e18;
+
+  /// @notice lower bound to prevent spam & avoid exchangeRate issues
+  // as returnFunds can be called permissionless an attacker could spam returnFunds(1) to produce exchangeRate snapshots making voting expensive
+  uint256 public immutable LOWER_BOUND;
+
+  // Reserved storage space to allow for layout changes in the future.
+  uint256[8] private ______gap;
+  /// @notice Seconds between starting cooldown and being able to withdraw
+  uint256 internal _cooldownSeconds;
+  /// @notice The maximum amount of funds that can be slashed at any given time
+  uint256 internal _maxSlashablePercentage;
+  /// @notice Mirror of latest snapshot value for cheaper access
+  uint216 internal _currentExchangeRate;
+  /// @notice Flag determining if there's an ongoing slashing event that needs to be settled
+  bool public inPostSlashingPeriod;
+
+  modifier onlySlashingAdmin() {
+    require(
+      msg.sender == getAdmin(SLASH_ADMIN_ROLE),
+      'CALLER_NOT_SLASHING_ADMIN'
+    );
+    _;
+  }
+
+  modifier onlyCooldownAdmin() {
+    require(
+      msg.sender == getAdmin(COOLDOWN_ADMIN_ROLE),
+      'CALLER_NOT_COOLDOWN_ADMIN'
+    );
+    _;
+  }
+
+  modifier onlyClaimHelper() {
+    require(
+      msg.sender == getAdmin(CLAIM_HELPER_ROLE),
+      'CALLER_NOT_CLAIM_HELPER'
+    );
+    _;
+  }
+
+  constructor(
+    IERC20 stakedToken,
+    IERC20 rewardToken,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration
+  )
+    StakedTokenV2(
+      stakedToken,
+      rewardToken,
+      unstakeWindow,
+      rewardsVault,
+      emissionManager,
+      distributionDuration
+    )
+  {
+    // brick initialize
+    lastInitializedRevision = REVISION();
+    uint256 decimals = IERC20Metadata(address(stakedToken)).decimals();
+    LOWER_BOUND = 10**decimals;
+  }
+
+  /**
+   * @dev returns the revision of the implementation contract
+   * @return The revision
+   */
+  function REVISION() public pure virtual returns (uint256) {
+    return 3;
+  }
+
+  /**
+   * @dev returns the revision of the implementation contract
+   * @return The revision
+   */
+  function getRevision() internal pure virtual override returns (uint256) {
+    return REVISION();
+  }
+
+  /**
+   * @dev Called by the proxy contract
+   */
+  function initialize(
+    address slashingAdmin,
+    address cooldownPauseAdmin,
+    address claimHelper,
+    uint256 maxSlashablePercentage,
+    uint256 cooldownSeconds
+  ) external virtual initializer {
+    _initialize(
+      slashingAdmin,
+      cooldownPauseAdmin,
+      claimHelper,
+      maxSlashablePercentage,
+      cooldownSeconds
+    );
+  }
+
+  function _initialize(
+    address slashingAdmin,
+    address cooldownPauseAdmin,
+    address claimHelper,
+    uint256 maxSlashablePercentage,
+    uint256 cooldownSeconds
+  ) internal {
+    InitAdmin[] memory initAdmins = new InitAdmin[](3);
+    initAdmins[0] = InitAdmin(SLASH_ADMIN_ROLE, slashingAdmin);
+    initAdmins[1] = InitAdmin(COOLDOWN_ADMIN_ROLE, cooldownPauseAdmin);
+    initAdmins[2] = InitAdmin(CLAIM_HELPER_ROLE, claimHelper);
+
+    _initAdmins(initAdmins);
+
+    _setMaxSlashablePercentage(maxSlashablePercentage);
+    _setCooldownSeconds(cooldownSeconds);
+    _updateExchangeRate(INITIAL_EXCHANGE_RATE);
+  }
+
+  /// @inheritdoc IAaveDistributionManager
+  function configureAssets(
+    DistributionTypes.AssetConfigInput[] memory assetsConfigInput
+  ) external override {
+    require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
+
+    for (uint256 i = 0; i < assetsConfigInput.length; i++) {
+      assetsConfigInput[i].totalStaked = totalSupply();
+    }
+
+    _configureAssets(assetsConfigInput);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function previewStake(uint256 assets) public view returns (uint256) {
+    return (assets * _currentExchangeRate) / EXCHANGE_RATE_UNIT;
+  }
+
+  /// @inheritdoc IStakedTokenV2
+  function stake(address to, uint256 amount)
+    external
+    override(IStakedTokenV2, StakedTokenV2)
+  {
+    _stake(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV2
+  function cooldown() external override(IStakedTokenV2, StakedTokenV2) {
+    _cooldown(msg.sender);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function cooldownOnBehalfOf(address from) external override onlyClaimHelper {
+    _cooldown(from);
+  }
+
+  function _cooldown(address from) internal {
+    uint256 amount = balanceOf(from);
+    require(amount != 0, 'INVALID_BALANCE_ON_COOLDOWN');
+    stakersCooldowns[from] = CooldownSnapshot({
+      timestamp: uint40(block.timestamp),
+      amount: uint216(amount)
+    });
+
+    emit Cooldown(from, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV2
+  function redeem(address to, uint256 amount)
+    external
+    override(IStakedTokenV2, StakedTokenV2)
+  {
+    _redeem(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function redeemOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper {
+    _redeem(from, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV2
+  function claimRewards(address to, uint256 amount)
+    external
+    override(IStakedTokenV2, StakedTokenV2)
+  {
+    _claimRewards(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function claimRewardsOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper returns (uint256) {
+    return _claimRewards(from, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function claimRewardsAndRedeem(
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external override {
+    _claimRewards(msg.sender, to, claimAmount);
+    _redeem(msg.sender, to, redeemAmount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function claimRewardsAndRedeemOnBehalf(
+    address from,
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external override onlyClaimHelper {
+    _claimRewards(from, to, claimAmount);
+    _redeem(from, to, redeemAmount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function getExchangeRate() public view override returns (uint216) {
+    return _currentExchangeRate;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function previewRedeem(uint256 shares)
+    public
+    view
+    override
+    returns (uint256)
+  {
+    return (EXCHANGE_RATE_UNIT * shares) / _currentExchangeRate;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function slash(address destination, uint256 amount)
+    external
+    override
+    onlySlashingAdmin
+    returns (uint256)
+  {
+    require(!inPostSlashingPeriod, 'PREVIOUS_SLASHING_NOT_SETTLED');
+    require(amount > 0, 'ZERO_AMOUNT');
+    uint256 currentShares = totalSupply();
+    uint256 balance = previewRedeem(currentShares);
+
+    uint256 maxSlashable = balance.percentMul(_maxSlashablePercentage);
+
+    if (amount > maxSlashable) {
+      amount = maxSlashable;
+    }
+    require(balance - amount >= LOWER_BOUND, 'REMAINING_LT_MINIMUM');
+
+    inPostSlashingPeriod = true;
+    _updateExchangeRate(_getExchangeRate(balance - amount, currentShares));
+
+    STAKED_TOKEN.safeTransfer(destination, amount);
+
+    emit Slashed(destination, amount);
+    return amount;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function returnFunds(uint256 amount) external override {
+    require(amount >= LOWER_BOUND, 'AMOUNT_LT_MINIMUM');
+    uint256 currentShares = totalSupply();
+    require(currentShares >= LOWER_BOUND, 'SHARES_LT_MINIMUM');
+    uint256 assets = previewRedeem(currentShares);
+    _updateExchangeRate(_getExchangeRate(assets + amount, currentShares));
+
+    STAKED_TOKEN.safeTransferFrom(msg.sender, address(this), amount);
+    emit FundsReturned(amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function settleSlashing() external override onlySlashingAdmin {
+    inPostSlashingPeriod = false;
+    emit SlashingSettled();
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function setMaxSlashablePercentage(uint256 percentage)
+    external
+    override
+    onlySlashingAdmin
+  {
+    _setMaxSlashablePercentage(percentage);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function getMaxSlashablePercentage()
+    external
+    view
+    override
+    returns (uint256)
+  {
+    return _maxSlashablePercentage;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function setCooldownSeconds(uint256 cooldownSeconds)
+    external
+    onlyCooldownAdmin
+  {
+    _setCooldownSeconds(cooldownSeconds);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function getCooldownSeconds() external view returns (uint256) {
+    return _cooldownSeconds;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function COOLDOWN_SECONDS() external view returns (uint256) {
+    return _cooldownSeconds;
+  }
+
+  /**
+   * @dev sets the max slashable percentage
+   * @param percentage must be strictly lower 100% as otherwise the exchange rate calculation would result in 0 division
+   */
+  function _setMaxSlashablePercentage(uint256 percentage) internal {
+    require(
+      percentage < PercentageMath.PERCENTAGE_FACTOR,
+      'INVALID_SLASHING_PERCENTAGE'
+    );
+
+    _maxSlashablePercentage = percentage;
+    emit MaxSlashablePercentageChanged(percentage);
+  }
+
+  /**
+   * @dev sets the cooldown seconds
+   * @param cooldownSeconds the new amount of cooldown seconds
+   */
+  function _setCooldownSeconds(uint256 cooldownSeconds) internal {
+    _cooldownSeconds = cooldownSeconds;
+    emit CooldownSecondsChanged(cooldownSeconds);
+  }
+
+  /**
+   * @dev claims the rewards for a specified address to a specified address
+   * @param from The address of the from from which to claim
+   * @param to Address to receive the rewards
+   * @param amount Amount to claim
+   * @return amount claimed
+   */
+  function _claimRewards(
+    address from,
+    address to,
+    uint256 amount
+  ) internal returns (uint256) {
+    require(amount != 0, 'INVALID_ZERO_AMOUNT');
+    uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
+      from,
+      balanceOf(from),
+      false
+    );
+
+    uint256 amountToClaim = (amount > newTotalRewards)
+      ? newTotalRewards
+      : amount;
+    require(amountToClaim != 0, 'INVALID_ZERO_AMOUNT');
+
+    stakerRewardsToClaim[from] = newTotalRewards - amountToClaim;
+    REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
+    emit RewardsClaimed(from, to, amountToClaim);
+    return amountToClaim;
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and stakes.
+   * @param from The address of the from from which to claim
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   * @return amount claimed
+   */
+  function _claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) internal returns (uint256) {
+    require(REWARD_TOKEN == STAKED_TOKEN, 'REWARD_TOKEN_IS_NOT_STAKED_TOKEN');
+
+    uint256 userUpdatedRewards = _updateCurrentUnclaimedRewards(
+      from,
+      balanceOf(from),
+      true
+    );
+    uint256 amountToClaim = (amount > userUpdatedRewards)
+      ? userUpdatedRewards
+      : amount;
+
+    if (amountToClaim != 0) {
+      _claimRewards(from, address(this), amountToClaim);
+      _stake(address(this), to, amountToClaim);
+    }
+
+    return amountToClaim;
+  }
+
+  /**
+   * @dev Allows staking a specified amount of STAKED_TOKEN
+   * @param to The address to receiving the shares
+   * @param amount The amount of assets to be staked
+   */
+  function _stake(
+    address from,
+    address to,
+    uint256 amount
+  ) internal {
+    require(!inPostSlashingPeriod, 'SLASHING_ONGOING');
+    require(amount != 0, 'INVALID_ZERO_AMOUNT');
+
+    uint256 balanceOfTo = balanceOf(to);
+
+    uint256 accruedRewards = _updateUserAssetInternal(
+      to,
+      address(this),
+      balanceOfTo,
+      totalSupply()
+    );
+
+    if (accruedRewards != 0) {
+      stakerRewardsToClaim[to] = stakerRewardsToClaim[to] + accruedRewards;
+      emit RewardsAccrued(to, accruedRewards);
+    }
+
+    uint256 sharesToMint = previewStake(amount);
+
+    STAKED_TOKEN.safeTransferFrom(from, address(this), amount);
+
+    _mint(to, sharesToMint);
+
+    emit Staked(from, to, amount, sharesToMint);
+  }
+
+  /**
+   * @dev Redeems staked tokens, and stop earning rewards
+   * @param from Address to redeem from
+   * @param to Address to redeem to
+   * @param amount Amount to redeem
+   */
+  function _redeem(
+    address from,
+    address to,
+    uint256 amount
+  ) internal {
+    require(amount != 0, 'INVALID_ZERO_AMOUNT');
+
+    CooldownSnapshot memory cooldownSnapshot = stakersCooldowns[from];
+    if (!inPostSlashingPeriod) {
+      require(
+        (block.timestamp > cooldownSnapshot.timestamp + _cooldownSeconds),
+        'INSUFFICIENT_COOLDOWN'
+      );
+      require(
+        (block.timestamp - (cooldownSnapshot.timestamp + _cooldownSeconds) <=
+          UNSTAKE_WINDOW),
+        'UNSTAKE_WINDOW_FINISHED'
+      );
+    }
+
+    uint256 balanceOfFrom = balanceOf(from);
+    uint256 maxRedeemable = inPostSlashingPeriod
+      ? balanceOfFrom
+      : cooldownSnapshot.amount;
+    require(maxRedeemable != 0, 'INVALID_ZERO_MAX_REDEEMABLE');
+
+    uint256 amountToRedeem = (amount > maxRedeemable) ? maxRedeemable : amount;
+
+    _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);
+
+    uint256 underlyingToRedeem = previewRedeem(amountToRedeem);
+
+    _burn(from, amountToRedeem);
+
+    if (cooldownSnapshot.timestamp != 0) {
+      if (cooldownSnapshot.amount - amountToRedeem == 0) {
+        delete stakersCooldowns[from];
+      } else {
+        stakersCooldowns[from].amount =
+          stakersCooldowns[from].amount -
+          amountToRedeem.toUint184();
+      }
+    }
+
+    IERC20(STAKED_TOKEN).safeTransfer(to, underlyingToRedeem);
+
+    emit Redeem(from, to, underlyingToRedeem, amountToRedeem);
+  }
+
+  /**
+   * @dev Updates the exchangeRate and emits events accordingly
+   * @param newExchangeRate the new exchange rate
+   */
+  function _updateExchangeRate(uint216 newExchangeRate) internal virtual {
+    require(newExchangeRate != 0, 'ZERO_EXCHANGE_RATE');
+    _currentExchangeRate = newExchangeRate;
+    emit ExchangeRateChanged(newExchangeRate);
+  }
+
+  /**
+   * @dev calculates the exchange rate based on totalAssets and totalShares
+   * @dev always rounds up to ensure 100% backing of shares by rounding in favor of the contract
+   * @param totalAssets The total amount of assets staked
+   * @param totalShares The total amount of shares
+   * @return exchangeRate as 18 decimal precision uint216
+   */
+  function _getExchangeRate(uint256 totalAssets, uint256 totalShares)
+    internal
+    pure
+    returns (uint216)
+  {
+    return
+      (((totalShares * EXCHANGE_RATE_UNIT) + totalAssets - 1) / totalAssets)
+        .toUint216();
+  }
+
+  function _transfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal override {
+    uint256 balanceOfFrom = balanceOf(from);
+    // Sender
+    _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);
+
+    // Recipient
+    if (from != to) {
+      uint256 balanceOfTo = balanceOf(to);
+      _updateCurrentUnclaimedRewards(to, balanceOfTo, true);
+
+      CooldownSnapshot memory previousSenderCooldown = stakersCooldowns[from];
+      if (previousSenderCooldown.timestamp != 0) {
+        // if cooldown was set and whole balance of sender was transferred - clear cooldown
+        if (balanceOfFrom == amount) {
+          delete stakersCooldowns[from];
+        } else if (balanceOfFrom - amount < previousSenderCooldown.amount) {
+          stakersCooldowns[from].amount = uint184(balanceOfFrom - amount);
+        }
+      }
+    }
+
+    super._transfer(from, to, amount);
+  }
+}
+
+interface IGhoVariableDebtTokenTransferHook {
+  /**
+   * @dev updates the discount when discount token is transferred
+   * @dev Only callable by discount token
+   * @param sender address of sender
+   * @param recipient address of recipient
+   * @param senderDiscountTokenBalance sender discount token balance
+   * @param recipientDiscountTokenBalance recipient discount token balance
+   * @param amount amount of discount token being transferred
+   **/
+  function updateDiscountDistribution(
+    address sender,
+    address recipient,
+    uint256 senderDiscountTokenBalance,
+    uint256 recipientDiscountTokenBalance,
+    uint256 amount
+  ) external;
+}
+
+interface IStakedAaveV3 is IStakedTokenV3 {
+  struct ExchangeRateSnapshot {
+    uint40 blockNumber;
+    uint216 value;
+  }
+
+  event GHODebtTokenChanged(address indexed newDebtToken);
+
+  /**
+   * @dev Sets the GHO debt token (only callable by SHORT_EXECUTOR)
+   * @param newGHODebtToken Address to GHO debt token
+   */
+  function setGHODebtToken(IGhoVariableDebtTokenTransferHook newGHODebtToken)
+    external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and stakes.
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   */
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    returns (uint256);
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and stakes. Only the claim helper contract is allowed to call this function
+   * @param from The address of the from from which to claim
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   */
+  function claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external returns (uint256);
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
+}
+
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
+/**
+ * @title StakedAaveV3
+ * @notice StakedTokenV3 with AAVE token as staked token
+ * @author BGD Labs
+ */
+contract StakedAaveV3 is StakedTokenV3, IStakedAaveV3 {
+  using SafeCast for uint256;
+
+  uint32 internal _exchangeRateSnapshotsCount;
+  /// @notice Snapshots of the exchangeRate for a given block
+  mapping(uint256 => ExchangeRateSnapshot) public _exchangeRateSnapshots;
+
+  /// @notice GHO debt token to be used in the _beforeTokenTransfer hook
+  IGhoVariableDebtTokenTransferHook public ghoDebtToken;
+
+  function REVISION() public pure virtual override returns (uint256) {
+    return 5;
+  }
+
+  constructor(
+    IERC20 stakedToken,
+    IERC20 rewardToken,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration
+  )
+    StakedTokenV3(
+      stakedToken,
+      rewardToken,
+      unstakeWindow,
+      rewardsVault,
+      emissionManager,
+      distributionDuration
+    )
+  {
+    // brick initialize
+    lastInitializedRevision = REVISION();
+  }
+
+  /**
+   * @dev Called by the proxy contract
+   */
+  function initialize(
+    address slashingAdmin,
+    address cooldownPauseAdmin,
+    address claimHelper,
+    uint256 maxSlashablePercentage,
+    uint256 cooldownSeconds
+  ) external override initializer {
+    _initialize(
+      slashingAdmin,
+      cooldownPauseAdmin,
+      claimHelper,
+      maxSlashablePercentage,
+      cooldownSeconds
+    );
+
+    // needed to claimRewardsAndStake works without a custom approval each time
+    STAKED_TOKEN.approve(address(this), type(uint256).max);
+  }
+
+  /// @inheritdoc IStakedAaveV3
+  function setGHODebtToken(IGhoVariableDebtTokenTransferHook newGHODebtToken)
+    external
+  {
+    require(msg.sender == 0xEE56e2B3D491590B5b31738cC34d5232F378a8D5); // Short executor
+    ghoDebtToken = newGHODebtToken;
+    emit GHODebtTokenChanged(address(newGHODebtToken));
+  }
+
+  /// @inheritdoc IStakedAaveV3
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    override
+    returns (uint256)
+  {
+    return _claimRewardsAndStakeOnBehalf(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedAaveV3
+  function claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper returns (uint256) {
+    return _claimRewardsAndStakeOnBehalf(from, to, amount);
+  }
+
+  /// @inheritdoc IStakedAaveV3
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
    * @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn
    * - On _transfer, it writes snapshots for both "from" and "to"
@@ -1982,6 +4327,18 @@ contract StakedTokenV2Rev4 is
     address to,
     uint256 amount
   ) internal override {
+    IGhoVariableDebtTokenTransferHook cachedGhoDebtToken = ghoDebtToken;
+    if (address(cachedGhoDebtToken) != address(0)) {
+      try
+        cachedGhoDebtToken.updateDiscountDistribution(
+          from,
+          to,
+          balanceOf(from),
+          balanceOf(to),
+          amount
+        )
+      {} catch (bytes memory) {}
+    }
     address votingFromDelegatee = _votingDelegates[from];
     address votingToDelegatee = _votingDelegates[to];
 
@@ -2015,101 +4372,68 @@ contract StakedTokenV2Rev4 is
       amount,
       DelegationType.PROPOSITION_POWER
     );
-
-    // caching the aave governance address to avoid multiple state loads
-    ITransferHook aaveGovernance = _aaveGovernance;
-    if (aaveGovernance != ITransferHook(0)) {
-      aaveGovernance.onTransfer(from, to, amount);
-    }
   }
 
-  function _getDelegationDataByType(DelegationType delegationType)
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
+  /// @dev Modified version accounting for exchange rate at block
+  /// @inheritdoc GovernancePowerDelegationERC20
+  function _searchByBlockNumber(
+    mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
+    mapping(address => uint256) storage snapshotsCounts,
+    address user,
+    uint256 blockNumber
+  ) internal view override returns (uint256) {
+    return
+      (super._searchByBlockNumber(
+        snapshots,
+        snapshotsCounts,
+        user,
+        blockNumber
+      ) * EXCHANGE_RATE_UNIT) /
+      _binarySearchExchangeRate(
+        _exchangeRateSnapshots,
+        _exchangeRateSnapshotsCount,
+        blockNumber
       );
+  }
+
+  /**
+   * @dev Updates the exchangeRate and emits events accordingly
+   * @param newExchangeRate the new exchange rate
+   */
+  function _updateExchangeRate(uint216 newExchangeRate) internal override {
+    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = ExchangeRateSnapshot(
+      block.number.toUint40(),
+      newExchangeRate
+    );
+    ++_exchangeRateSnapshotsCount;
+    super._updateExchangeRate(newExchangeRate);
+  }
+
+  function _binarySearchExchangeRate(
+    mapping(uint256 => ExchangeRateSnapshot) storage snapshots,
+    uint256 snapshotsCount,
+    uint256 blockNumber
+  ) internal view returns (uint256) {
+    unchecked {
+      // First check most recent balance
+      if (snapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
+        return snapshots[snapshotsCount - 1].value;
+      }
+
+      uint256 lower = 0;
+      uint256 upper = snapshotsCount - 1;
+      while (upper > lower) {
+        uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
+        ExchangeRateSnapshot memory snapshot = snapshots[center];
+        if (snapshot.blockNumber == blockNumber) {
+          return snapshot.value;
+        } else if (snapshot.blockNumber < blockNumber) {
+          lower = center;
+        } else {
+          upper = center - 1;
+        }
+      }
+      return snapshots[lower].value;
     }
   }
-
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
 }
```
