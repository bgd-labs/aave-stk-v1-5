```diff --git a/src/flattened/StakedTokenV2Rev3.sol b/src/flattened/StakedAaveV3Flattened.sol
index 46a5dfd..a435f8f 100644
--- a/src/flattened/StakedTokenV2Rev3.sol
+++ b/src/flattened/StakedAaveV3Flattened.sol
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: agpl-3.0
-pragma solidity 0.7.5;
-pragma experimental ABIEncoderV2;
+pragma solidity ^0.8.0;
+
+// most imports are only here to force import order for better flattening diff
 
 interface IGovernancePowerDelegationToken {
   enum DelegationType {
@@ -88,24 +89,24 @@ interface IGovernancePowerDelegationToken {
     returns (uint256);
 }
 
+// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
+
 /**
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Provides information about the current execution context, including the
+ * @dev Provides information about the current execution context, including the
  * sender of the transaction and its data. While these are generally available
  * via msg.sender and msg.data, they should not be accessed in such a direct
- * manner, since when dealing with GSN meta-transactions the account sending and
+ * manner, since when dealing with meta-transactions the account sending and
  * paying for execution may not be the actual sender (as far as an application
  * is concerned).
  *
  * This contract is only required for intermediate, library-like contracts.
  */
 abstract contract Context {
-  function _msgSender() internal view virtual returns (address payable) {
+  function _msgSender() internal view virtual returns (address) {
     return msg.sender;
   }
 
-  function _msgData() internal view virtual returns (bytes memory) {
-    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
+  function _msgData() internal view virtual returns (bytes calldata) {
     return msg.data;
   }
 }
@@ -192,167 +193,7 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
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
-  }
-
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
-  }
-
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
-
-    return c;
-  }
-
-  /**
-   * @dev Returns the integer division of two unsigned integers. Reverts on
-   * division by zero. The result is rounded towards zero.
-   *
-   * Counterpart to Solidity's `/` operator. Note: this function uses a
-   * `revert` opcode (which leaves remaining gas untouched) while Solidity
-   * uses an invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
-   */
-  function div(uint256 a, uint256 b) internal pure returns (uint256) {
-    return div(a, b, 'SafeMath: division by zero');
-  }
-
-  /**
-   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
-   * division by zero. The result is rounded towards zero.
-   *
-   * Counterpart to Solidity's `/` operator. Note: this function uses a
-   * `revert` opcode (which leaves remaining gas untouched) while Solidity
-   * uses an invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
-   */
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
-
-  /**
-   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
-   * Reverts when dividing by zero.
-   *
-   * Counterpart to Solidity's `%` operator. This function uses a `revert`
-   * opcode (which leaves remaining gas untouched) while Solidity uses an
-   * invalid opcode to revert (consuming all remaining gas).
-   *
-   * Requirements:
-   * - The divisor cannot be zero.
-   */
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
-}
+// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
 
 /**
  * @dev Collection of functions related to the address type
@@ -375,18 +216,22 @@ library Address {
    *  - an address where a contract will be created
    *  - an address where a contract lived, but was destroyed
    * ====
+   *
+   * [IMPORTANT]
+   * ====
+   * You shouldn't rely on `isContract` to protect against flash loan attacks!
+   *
+   * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
+   * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
+   * constructor.
+   * ====
    */
   function isContract(address account) internal view returns (bool) {
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
+    // This method relies on extcodesize/address.code.length, which returns 0
+    // for contracts in construction, since the code is only stored at the end
+    // of the constructor execution.
+
+    return account.code.length > 0;
   }
 
   /**
@@ -408,13 +253,219 @@ library Address {
   function sendValue(address payable recipient, uint256 amount) internal {
     require(address(this).balance >= amount, 'Address: insufficient balance');
 
-    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
     (bool success, ) = recipient.call{value: amount}('');
     require(
       success,
       'Address: unable to send value, recipient may have reverted'
     );
   }
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
+    return functionCall(target, data, 'Address: low-level call failed');
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
+    require(isContract(target), 'Address: call to non-contract');
+
+    (bool success, bytes memory returndata) = target.call{value: value}(data);
+    return verifyCallResult(success, returndata, errorMessage);
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
+    require(isContract(target), 'Address: static call to non-contract');
+
+    (bool success, bytes memory returndata) = target.staticcall(data);
+    return verifyCallResult(success, returndata, errorMessage);
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
+    require(isContract(target), 'Address: delegate call to non-contract');
+
+    (bool success, bytes memory returndata) = target.delegatecall(data);
+    return verifyCallResult(success, returndata, errorMessage);
+  }
+
+  /**
+   * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
+   * revert reason using the provided one.
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
+      // Look for revert reason and bubble it up if present
+      if (returndata.length > 0) {
+        // The easiest way to bubble the revert reason is using memory via assembly
+
+        assembly {
+          let returndata_size := mload(returndata)
+          revert(add(32, returndata), returndata_size)
+        }
+      } else {
+        revert(errorMessage);
+      }
+    }
+  }
+}
+
+// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
+
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
 }
 
 /**
@@ -428,9 +479,10 @@ library Address {
  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
@@ -441,39 +493,35 @@ library Address {
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
+  constructor(string memory name_, string memory symbol_) {
+    _name = name_;
+    _symbol = symbol_;
   }
 
   /**
    * @dev Returns the name of the token.
    */
-  function name() public view returns (string memory) {
+  function name() public view virtual override returns (string memory) {
     return _name;
   }
 
@@ -481,38 +529,44 @@ contract ERC20 is Context, IERC20 {
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
 
@@ -521,16 +575,17 @@ contract ERC20 is Context, IERC20 {
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
 
@@ -550,6 +605,9 @@ contract ERC20 is Context, IERC20 {
   /**
    * @dev See {IERC20-approve}.
    *
+   * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
+   * `transferFrom`. This is semantically equivalent to an infinite approval.
+   *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
@@ -560,7 +618,8 @@ contract ERC20 is Context, IERC20 {
     override
     returns (bool)
   {
-    _approve(_msgSender(), spender, amount);
+    address owner = _msgSender();
+    _approve(owner, spender, amount);
     return true;
   }
 
@@ -568,28 +627,26 @@ contract ERC20 is Context, IERC20 {
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
 
@@ -610,11 +667,8 @@ contract ERC20 is Context, IERC20 {
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
 
@@ -637,47 +691,53 @@ contract ERC20 is Context, IERC20 {
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
+    }
+    _balances[to] += amount;
+
+    emit Transfer(from, to, amount);
+
+    _afterTokenTransfer(from, to, amount);
   }
 
   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
@@ -685,18 +745,20 @@ contract ERC20 is Context, IERC20 {
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
+    _balances[account] += amount;
     emit Transfer(address(0), account, amount);
+
+    _afterTokenTransfer(address(0), account, amount);
   }
 
   /**
@@ -705,7 +767,7 @@ contract ERC20 is Context, IERC20 {
    *
    * Emits a {Transfer} event with `to` set to the zero address.
    *
-   * Requirements
+   * Requirements:
    *
    * - `account` cannot be the zero address.
    * - `account` must have at least `amount` tokens.
@@ -715,18 +777,22 @@ contract ERC20 is Context, IERC20 {
 
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
+    }
+    _totalSupply -= amount;
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
@@ -749,14 +815,25 @@ contract ERC20 is Context, IERC20 {
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
@@ -766,7 +843,7 @@ contract ERC20 is Context, IERC20 {
    * Calling conditions:
    *
    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
-   * will be to transferred to `to`.
+   * will be transferred to `to`.
    * - when `from` is zero, `amount` tokens will be minted for `to`.
    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
    * - `from` and `to` are never both zero.
@@ -778,6 +855,26 @@ contract ERC20 is Context, IERC20 {
     address to,
     uint256 amount
   ) internal virtual {}
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
 
 interface IStakedAave {
@@ -812,10 +909,11 @@ library DistributionTypes {
   }
 }
 
+// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
+
 /**
  * @title SafeERC20
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Wrappers around ERC20 operations that throw on failure (when the token
+ * @dev Wrappers around ERC20 operations that throw on failure (when the token
  * contract returns false). Tokens that return no value (and instead revert or
  * throw on failure) are also supported, non-reverting calls are assumed to be
  * successful.
@@ -823,7 +921,6 @@ library DistributionTypes {
  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
  */
 library SafeERC20 {
-  using SafeMath for uint256;
   using Address for address;
 
   function safeTransfer(
@@ -831,7 +928,7 @@ library SafeERC20 {
     address to,
     uint256 value
   ) internal {
-    callOptionalReturn(
+    _callOptionalReturn(
       token,
       abi.encodeWithSelector(token.transfer.selector, to, value)
     );
@@ -843,37 +940,85 @@ library SafeERC20 {
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
@@ -937,8 +1082,6 @@ interface IAaveDistributionManager {
  * @author Aave
  **/
 contract AaveDistributionManager is IAaveDistributionManager {
-  using SafeMath for uint256;
-
   struct AssetData {
     uint128 emissionPerSecond;
     uint128 lastUpdateTimestamp;
@@ -963,7 +1106,7 @@ contract AaveDistributionManager is IAaveDistributionManager {
   );
 
   constructor(address emissionManager, uint256 distributionDuration) public {
-    DISTRIBUTION_END = block.timestamp.add(distributionDuration);
+    DISTRIBUTION_END = block.timestamp + distributionDuration;
     EMISSION_MANAGER = emissionManager;
   }
 
@@ -1077,14 +1220,14 @@ contract AaveDistributionManager is IAaveDistributionManager {
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
@@ -1111,9 +1254,13 @@ contract AaveDistributionManager is IAaveDistributionManager {
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
@@ -1131,9 +1278,8 @@ contract AaveDistributionManager is IAaveDistributionManager {
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
@@ -1162,13 +1308,10 @@ contract AaveDistributionManager is IAaveDistributionManager {
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
@@ -1194,7 +1337,6 @@ abstract contract GovernancePowerDelegationERC20 is
   ERC20,
   IGovernancePowerDelegationToken
 {
-  using SafeMath for uint256;
   /// @notice The EIP-712 typehash for the delegation struct used by the contract
   bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
     keccak256(
@@ -1374,10 +1516,10 @@ abstract contract GovernancePowerDelegationERC20 is
         snapshotsCounts,
         from,
         uint128(previous),
-        uint128(previous.sub(amount))
+        uint128(previous - amount)
       );
 
-      emit DelegatedPowerChanged(from, previous.sub(amount), delegationType);
+      emit DelegatedPowerChanged(from, previous - amount, delegationType);
     }
     if (to != address(0)) {
       uint256 previous = 0;
@@ -1393,10 +1535,10 @@ abstract contract GovernancePowerDelegationERC20 is
         snapshotsCounts,
         to,
         uint128(previous),
-        uint128(previous.add(amount))
+        uint128(previous + amount)
       );
 
-      emit DelegatedPowerChanged(to, previous.add(amount), delegationType);
+      emit DelegatedPowerChanged(to, previous + amount, delegationType);
     }
   }
 
@@ -1522,8 +1664,6 @@ abstract contract GovernancePowerDelegationERC20 is
 abstract contract GovernancePowerWithSnapshot is
   GovernancePowerDelegationERC20
 {
-  using SafeMath for uint256;
-
   /**
    * @dev The following storage layout points to the prior StakedToken.sol implementation:
    * _snapshots => _votingSnapshots
@@ -1543,22 +1683,170 @@ abstract contract GovernancePowerWithSnapshot is
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
+interface IStakedToken {
+  function stake(address to, uint256 amount) external;
+
+  function redeem(address to, uint256 amount) external;
+
+  function cooldown() external;
+
+  function claimRewards(address to, uint256 amount) external;
+}
+
+interface IStakedTokenV3 is IStakedToken {
+  function exchangeRate() external view returns (uint256);
+
+  function getCooldownPaused() external view returns (bool);
+
+  function setCooldownPause(bool paused) external;
+
+  function slash(address destination, uint256 amount) external;
+
+  function getSlashingExitWindowSeconds() external view returns (uint40);
+
+  function setSlashingExitWindowSeconds(uint40 slashingExitWindowSeconds)
+    external;
+
+  function getCooldownSeconds() external view returns (uint40);
+
+  function setCooldownSeconds(uint40 cooldownSeconds) external;
+
+  function getMaxSlashablePercentage() external view returns (uint256);
+
+  function setMaxSlashablePercentage(uint256 percentage) external;
+
+  function stakeWithPermit(
+    address from,
+    address to,
+    uint256 amount,
+    uint256 deadline,
+    uint8 v,
+    bytes32 r,
+    bytes32 s
+  ) external;
+
+  function claimRewardsOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external returns (uint256);
+
+  function redeemOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external;
+
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    returns (uint256);
+
+  function claimRewardsAndRedeem(
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external;
+
+  function claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external returns (uint256);
+
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
+      value <= (type(uint256).max - HALF_PERCENT) / percentage,
+      'MATH_MULTIPLICATION_OVERFLOW'
+    );
+
+    return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
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
+    uint256 halfPercentage = percentage / 2;
+
+    require(
+      value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR,
+      'MATH_MULTIPLICATION_OVERFLOW'
+    );
+
+    return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
+  }
+}
+
 /**
  * @title StakedToken
  * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
  * @author Aave
  **/
-contract StakedTokenV2Rev3 is
-  IStakedAave,
+contract StakedTokenV2 is
+  IStakedToken,
   GovernancePowerWithSnapshot,
   VersionedInitializable,
   AaveDistributionManager
 {
-  using SafeMath for uint256;
   using SafeERC20 for IERC20;
 
-  /// @dev Start of Storage layout from StakedToken v1
-  uint256 public constant REVISION = 3;
+  function REVISION() public pure virtual returns (uint256) {
+    return 2;
+  }
 
   IERC20 public immutable STAKED_TOKEN;
   IERC20 public immutable REWARD_TOKEN;
@@ -1623,7 +1911,6 @@ contract StakedTokenV2Rev3 is
     uint128 distributionDuration,
     string memory name,
     string memory symbol,
-    uint8 decimals,
     address governance
   )
     public
@@ -1636,13 +1923,12 @@ contract StakedTokenV2Rev3 is
     UNSTAKE_WINDOW = unstakeWindow;
     REWARDS_VAULT = rewardsVault;
     _aaveGovernance = ITransferHook(governance);
-    ERC20._setupDecimals(decimals);
   }
 
   /**
    * @dev Called by the proxy contract
    **/
-  function initialize() external initializer {
+  function initialize() external virtual initializer {
     uint256 chainId;
 
     //solium-disable-next-line
@@ -1659,13 +1945,9 @@ contract StakedTokenV2Rev3 is
         address(this)
       )
     );
-
-    // Update lastUpdateTimestamp of stkAave to reward users since the end of the prior staking period
-    AssetData storage assetData = assets[address(this)];
-    assetData.lastUpdateTimestamp = 1620594720;
   }
 
-  function stake(address onBehalfOf, uint256 amount) external override {
+  function stake(address onBehalfOf, uint256 amount) external virtual override {
     require(amount != 0, 'INVALID_ZERO_AMOUNT');
     uint256 balanceOfUser = balanceOf(onBehalfOf);
 
@@ -1677,9 +1959,9 @@ contract StakedTokenV2Rev3 is
     );
     if (accruedRewards != 0) {
       emit RewardsAccrued(onBehalfOf, accruedRewards);
-      stakerRewardsToClaim[onBehalfOf] = stakerRewardsToClaim[onBehalfOf].add(
-        accruedRewards
-      );
+      stakerRewardsToClaim[onBehalfOf] =
+        stakerRewardsToClaim[onBehalfOf] +
+        accruedRewards;
     }
 
     stakersCooldowns[onBehalfOf] = getNextCooldownTimestamp(
@@ -1700,16 +1982,16 @@ contract StakedTokenV2Rev3 is
    * @param to Address to redeem to
    * @param amount Amount to redeem
    **/
-  function redeem(address to, uint256 amount) external override {
+  function redeem(address to, uint256 amount) external virtual override {
     require(amount != 0, 'INVALID_ZERO_AMOUNT');
     //solium-disable-next-line
     uint256 cooldownStartTimestamp = stakersCooldowns[msg.sender];
     require(
-      block.timestamp > cooldownStartTimestamp.add(COOLDOWN_SECONDS),
+      block.timestamp > cooldownStartTimestamp + COOLDOWN_SECONDS,
       'INSUFFICIENT_COOLDOWN'
     );
     require(
-      block.timestamp.sub(cooldownStartTimestamp.add(COOLDOWN_SECONDS)) <=
+      block.timestamp - (cooldownStartTimestamp + COOLDOWN_SECONDS) <=
         UNSTAKE_WINDOW,
       'UNSTAKE_WINDOW_FINISHED'
     );
@@ -1723,7 +2005,7 @@ contract StakedTokenV2Rev3 is
 
     _burn(msg.sender, amountToRedeem);
 
-    if (balanceOfMessageSender.sub(amountToRedeem) == 0) {
+    if (balanceOfMessageSender - amountToRedeem == 0) {
       stakersCooldowns[msg.sender] = 0;
     }
 
@@ -1749,7 +2031,7 @@ contract StakedTokenV2Rev3 is
    * @param to Address to stake for
    * @param amount Amount to stake
    **/
-  function claimRewards(address to, uint256 amount) external override {
+  function claimRewards(address to, uint256 amount) external virtual override {
     uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
       msg.sender,
       balanceOf(msg.sender),
@@ -1759,10 +2041,7 @@ contract StakedTokenV2Rev3 is
       ? newTotalRewards
       : amount;
 
-    stakerRewardsToClaim[msg.sender] = newTotalRewards.sub(
-      amountToClaim,
-      'INVALID_AMOUNT'
-    );
+    stakerRewardsToClaim[msg.sender] = newTotalRewards - amountToClaim;
 
     REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
 
@@ -1823,7 +2102,7 @@ contract StakedTokenV2Rev3 is
       userBalance,
       totalSupply()
     );
-    uint256 unclaimedRewards = stakerRewardsToClaim[user].add(accruedRewards);
+    uint256 unclaimedRewards = stakerRewardsToClaim[user] + accruedRewards;
 
     if (accruedRewards != 0) {
       if (updateStorage) {
@@ -1854,16 +2133,15 @@ contract StakedTokenV2Rev3 is
     uint256 amountToReceive,
     address toAddress,
     uint256 toBalance
-  ) public view returns (uint256) {
+  ) public view virtual returns (uint256) {
     uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
     if (toCooldownTimestamp == 0) {
       return 0;
     }
 
-    uint256 minimalValidCooldownTimestamp = block
-      .timestamp
-      .sub(COOLDOWN_SECONDS)
-      .sub(UNSTAKE_WINDOW);
+    uint256 minimalValidCooldownTimestamp = block.timestamp -
+      COOLDOWN_SECONDS -
+      UNSTAKE_WINDOW;
 
     if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
       toCooldownTimestamp = 0;
@@ -1876,11 +2154,10 @@ contract StakedTokenV2Rev3 is
       if (fromCooldownTimestamp < toCooldownTimestamp) {
         return toCooldownTimestamp;
       } else {
-        toCooldownTimestamp = (
-          amountToReceive.mul(fromCooldownTimestamp).add(
-            toBalance.mul(toCooldownTimestamp)
-          )
-        ).div(amountToReceive.add(toBalance));
+        toCooldownTimestamp =
+          ((amountToReceive * fromCooldownTimestamp) +
+            (toBalance * toCooldownTimestamp)) /
+          (amountToReceive + toBalance);
       }
     }
     return toCooldownTimestamp;
@@ -1904,17 +2181,16 @@ contract StakedTokenV2Rev3 is
       totalStaked: totalSupply()
     });
     return
-      stakerRewardsToClaim[staker].add(
-        _getUnclaimedRewards(staker, userStakeInputs)
-      );
+      stakerRewardsToClaim[staker] +
+      _getUnclaimedRewards(staker, userStakeInputs);
   }
 
   /**
    * @dev returns the revision of the implementation contract
    * @return The revision
    */
-  function getRevision() internal pure override returns (uint256) {
-    return REVISION;
+  function getRevision() internal pure virtual override returns (uint256) {
+    return REVISION();
   }
 
   /**
@@ -1959,7 +2235,7 @@ contract StakedTokenV2Rev3 is
     );
 
     require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
-    _nonces[owner] = currentValidNonce.add(1);
+    _nonces[owner] = currentValidNonce + 1;
     _approve(owner, spender, value);
   }
 
@@ -2013,7 +2289,7 @@ contract StakedTokenV2Rev3 is
 
     // caching the aave governance address to avoid multiple state loads
     ITransferHook aaveGovernance = _aaveGovernance;
-    if (aaveGovernance != ITransferHook(0)) {
+    if (address(aaveGovernance) != address(0)) {
       aaveGovernance.onTransfer(from, to, amount);
     }
   }
@@ -2108,3 +2384,762 @@ contract StakedTokenV2Rev3 is
     _delegateByType(signatory, delegatee, DelegationType.PROPOSITION_POWER);
   }
 }
+
+/**
+ * @title RoleManager
+ * @notice Generic role manager to manage slashing and cooldown admin in StakedAaveV3.
+ *         It implements a claim admin role pattern to safely migrate between different admin addresses
+ * @author Aave
+ **/
+contract RoleManager {
+  mapping(uint256 => address) private _admins;
+  mapping(uint256 => address) private _pendingAdmins;
+
+  event PendingAdminChanged(address indexed newPendingAdmin, uint256 role);
+  event RoleClaimed(address indexed newAdming, uint256 role);
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
+    emit RoleClaimed(msg.sender, role);
+  }
+
+  function _initAdmins(uint256[] memory roles, address[] memory admins)
+    internal
+  {
+    require(roles.length == admins.length, 'INCONSISTENT_INITIALIZATION');
+
+    for (uint256 i = 0; i < roles.length; i++) {
+      require(
+        _admins[roles[i]] == address(0) && admins[i] != address(0),
+        'ADMIN_CANNOT_BE_INITIALIZED'
+      );
+      _admins[roles[i]] = admins[i];
+      emit RoleClaimed(admins[i], roles[i]);
+    }
+  }
+}
+
+/**
+ * @title StakedToken
+ * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
+ * @author Aave
+ **/
+contract StakedTokenV3 is StakedTokenV2, IStakedTokenV3, RoleManager {
+  using SafeERC20 for IERC20;
+  using PercentageMath for uint256;
+
+  struct Duration {
+    uint40 cooldownSeconds;
+    uint40 slashingExitWindowSeconds;
+  }
+
+  Duration internal duration;
+
+  /// @notice Seconds available to redeem once the cooldown period is fullfilled
+  // uint256 public immutable UNSTAKE_WINDOW;
+
+  uint256 public constant SLASH_ADMIN_ROLE = 0;
+  uint256 public constant COOLDOWN_ADMIN_ROLE = 1;
+  uint256 public constant CLAIM_HELPER_ROLE = 2;
+  uint256 public constant INITIAL_EXCHANGE_RATE = 1e18;
+  uint256 public constant TOKEN_UNIT = 1e18;
+
+  function REVISION() public pure virtual override returns (uint256) {
+    return 3;
+  }
+
+  //maximum percentage of the underlying that can be slashed in a single realization event
+  uint256 internal _maxSlashablePercentage;
+  uint256 internal _lastSlashing = 0;
+  bool _cooldownPaused;
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
+  event Staked(
+    address indexed from,
+    address indexed to,
+    uint256 amount,
+    uint256 sharesMinted
+  );
+  event Redeem(
+    address indexed from,
+    address indexed to,
+    uint256 amount,
+    uint256 underlyingTransferred
+  );
+  event CooldownPauseChanged(bool pause);
+  event MaxSlashablePercentageChanged(uint256 newPercentage);
+  event Slashed(address indexed destination, uint256 amount);
+  event CooldownPauseAdminChanged(address indexed newAdmin);
+  event SlashingAdminChanged(address indexed newAdmin);
+  event SlashingExitWindowDurationChanged(uint256 windowSeconds);
+  event CooldownSecondsChanged(uint256 cooldownSeconds);
+
+  constructor(
+    IERC20 stakedToken,
+    IERC20 rewardToken,
+    uint256 cooldownSeconds,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration,
+    string memory name,
+    string memory symbol,
+    address governance
+  )
+    public
+    StakedTokenV2(
+      stakedToken,
+      rewardToken,
+      cooldownSeconds,
+      unstakeWindow,
+      rewardsVault,
+      emissionManager,
+      distributionDuration,
+      name,
+      symbol,
+      governance
+    )
+  {}
+
+  /**
+   * @dev Inherited from StakedTokenV2, deprecated
+   **/
+  function initialize() external override {
+    revert('DEPRECATED');
+  }
+
+  /**
+   * @dev Called by the proxy contract
+   **/
+  function initialize(
+    address slashingAdmin,
+    address cooldownPauseAdmin,
+    address claimHelper,
+    uint256 maxSlashablePercentage,
+    uint40 cooldownSeconds,
+    uint40 slashingExitWindowSeconds
+  ) external initializer {
+    require(
+      maxSlashablePercentage <= PercentageMath.PERCENTAGE_FACTOR,
+      'INVALID_SLASHING_PERCENTAGE'
+    );
+    uint256 chainId;
+
+    //solium-disable-next-line
+    assembly {
+      chainId := chainid()
+    }
+
+    DOMAIN_SEPARATOR = keccak256(
+      abi.encode(
+        EIP712_DOMAIN,
+        keccak256(bytes(super.name())),
+        keccak256(EIP712_REVISION),
+        chainId,
+        address(this)
+      )
+    );
+
+    address[] memory adminsAddresses = new address[](3);
+    uint256[] memory adminsRoles = new uint256[](3);
+
+    adminsAddresses[0] = slashingAdmin;
+    adminsAddresses[1] = cooldownPauseAdmin;
+    adminsAddresses[2] = claimHelper;
+
+    adminsRoles[0] = SLASH_ADMIN_ROLE;
+    adminsRoles[1] = COOLDOWN_ADMIN_ROLE;
+    adminsRoles[2] = CLAIM_HELPER_ROLE;
+
+    _initAdmins(adminsRoles, adminsAddresses);
+
+    _setMaxSlashablePercentage(maxSlashablePercentage);
+    _setCooldownSeconds(cooldownSeconds);
+    _setSlashingExitWindowSeconds(slashingExitWindowSeconds);
+  }
+
+  /**
+   * @dev Allows a from to stake STAKED_TOKEN
+   * @param to Address of the from that will receive stake token shares
+   * @param amount The amount to be staked
+   **/
+  function stake(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
+  {
+    _stake(msg.sender, to, amount, true);
+  }
+
+  /**
+   * @dev Allows a from to stake STAKED_TOKEN with gasless approvals (permit)
+   * @param to Address of the from that will receive stake token shares
+   * @param amount The amount to be staked
+   * @param deadline The permit execution deadline
+   * @param v The v component of the signed message
+   * @param r The r component of the signed message
+   * @param s The s component of the signed message
+   **/
+  function stakeWithPermit(
+    address from,
+    address to,
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
+    _stake(from, to, amount, true);
+  }
+
+  /**
+   * @dev Redeems staked tokens, and stop earning rewards
+   * @param to Address to redeem to
+   * @param amount Amount to redeem
+   **/
+  function redeem(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
+  {
+    _redeem(msg.sender, to, amount);
+  }
+
+  /**
+   * @dev Redeems staked tokens for a user. Only the claim helper contract is allowed to call this function
+   * @param from Address to redeem from
+   * @param to Address to redeem to
+   * @param amount Amount to redeem
+   **/
+  function redeemOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper {
+    _redeem(from, to, amount);
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
+   * @param to Address to send the claimed rewards
+   * @param amount Amount to stake
+   **/
+  function claimRewards(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
+  {
+    _claimRewards(msg.sender, to, amount);
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to` on behalf of the user. Only the claim helper contract is allowed to call this function
+   * @param from The address of the user from to claim
+   * @param to Address to send the claimed rewards
+   * @param amount Amount to claim
+   **/
+  function claimRewardsOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper returns (uint256) {
+    return _claimRewards(from, to, amount);
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and restakes
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   **/
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    override
+    returns (uint256)
+  {
+    require(REWARD_TOKEN == STAKED_TOKEN, 'REWARD_TOKEN_IS_NOT_STAKED_TOKEN');
+
+    uint256 userUpdatedRewards = _updateCurrentUnclaimedRewards(
+      msg.sender,
+      balanceOf(msg.sender),
+      true
+    );
+    uint256 amountToClaim = (amount > userUpdatedRewards)
+      ? userUpdatedRewards
+      : amount;
+
+    if (amountToClaim != 0) {
+      _stake(address(this), to, amountToClaim, false);
+      _claimRewards(msg.sender, address(this), amountToClaim);
+    }
+
+    return amountToClaim;
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and restakes. Only the claim helper contract is allowed to call this function
+   * @param from The address of the from from which to claim
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   **/
+  function claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper returns (uint256) {
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
+      _stake(address(this), to, amountToClaim, false);
+      _claimRewards(from, address(this), amountToClaim);
+    }
+
+    return (amountToClaim);
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and redeem
+   * @param claimAmount Amount to claim
+   * @param redeemAmount Amount to redeem
+   * @param to Address to claim and unstake to
+   **/
+  function claimRewardsAndRedeem(
+    address to,
+    uint256 claimAmount,
+    uint256 redeemAmount
+  ) external override {
+    _claimRewards(msg.sender, to, claimAmount);
+    _redeem(msg.sender, to, redeemAmount);
+  }
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and redeem. Only the claim helper contract is allowed to call this function
+   * @param from The address of the from
+   * @param to Address to claim and unstake to
+   * @param claimAmount Amount to claim
+   * @param redeemAmount Amount to redeem
+   **/
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
+  /**
+   * @dev Calculates the exchange rate between the amount of STAKED_TOKEN and the the StakeToken total supply.
+   * Slashing will reduce the exchange rate. Supplying STAKED_TOKEN to the stake contract
+   * can replenish the slashed STAKED_TOKEN and bring the exchange rate back to 1
+   **/
+  function exchangeRate() public view override returns (uint256) {
+    uint256 currentSupply = totalSupply();
+
+    if (currentSupply == 0) {
+      return INITIAL_EXCHANGE_RATE; //initial exchange rate is 1:1
+    }
+
+    return (STAKED_TOKEN.balanceOf(address(this)) * TOKEN_UNIT) / currentSupply;
+  }
+
+  /**
+   * @dev Executes a slashing of the underlying of a certain amount, transferring the seized funds
+   * to destination. Decreasing the amount of underlying will automatically adjust the exchange rate
+   * @param destination the address where seized funds will be transferred
+   * @param amount the amount
+   **/
+  function slash(address destination, uint256 amount)
+    external
+    override
+    onlySlashingAdmin
+  {
+    uint256 balance = STAKED_TOKEN.balanceOf(address(this));
+
+    uint256 maxSlashable = balance.percentMul(_maxSlashablePercentage);
+
+    require(amount <= maxSlashable, 'INVALID_SLASHING_AMOUNT');
+
+    STAKED_TOKEN.safeTransfer(destination, amount);
+
+    _lastSlashing = block.timestamp;
+
+    emit Slashed(destination, amount);
+  }
+
+  /**
+   * @dev returns true if the unstake cooldown is paused
+   */
+  function getCooldownPaused() external view override returns (bool) {
+    return _cooldownPaused;
+  }
+
+  /**
+   * @dev sets the state of the cooldown pause
+   * @param paused true if the cooldown needs to be paused, false otherwise
+   */
+  function setCooldownPause(bool paused) external override onlyCooldownAdmin {
+    _cooldownPaused = paused;
+    emit CooldownPauseChanged(paused);
+  }
+
+  /**
+   * @dev sets the admin of the slashing pausing function
+   * @param percentage the new maximum slashable percentage
+   */
+  function setMaxSlashablePercentage(uint256 percentage)
+    external
+    override
+    onlySlashingAdmin
+  {
+    _setMaxSlashablePercentage(percentage);
+  }
+
+  function _setMaxSlashablePercentage(uint256 percentage) internal {
+    require(
+      percentage <= PercentageMath.PERCENTAGE_FACTOR,
+      'INVALID_SLASHING_PERCENTAGE'
+    );
+
+    _maxSlashablePercentage = percentage;
+    emit MaxSlashablePercentageChanged(percentage);
+  }
+
+  /**
+   * @dev returns the current maximum slashable percentage of the stake
+   */
+  function getMaxSlashablePercentage()
+    external
+    view
+    override
+    returns (uint256)
+  {
+    return _maxSlashablePercentage;
+  }
+
+  /**
+   * @dev sets the window size in which users can leave the staking without a cooldown
+   * @param slashingExitWindowSeconds the new maximum slashable percentage
+   */
+  function setSlashingExitWindowSeconds(uint40 slashingExitWindowSeconds)
+    external
+    onlySlashingAdmin
+  {
+    _setSlashingExitWindowSeconds(slashingExitWindowSeconds);
+  }
+
+  function _setSlashingExitWindowSeconds(uint40 slashingExitWindowSeconds)
+    internal
+  {
+    duration.slashingExitWindowSeconds = slashingExitWindowSeconds;
+    emit SlashingExitWindowDurationChanged(slashingExitWindowSeconds);
+  }
+
+  function getSlashingExitWindowSeconds() external view returns (uint40) {
+    return duration.slashingExitWindowSeconds;
+  }
+
+  /**
+   * @dev sets the cooldown duration whch needs to pass before the user can unstake
+   * @param cooldownSeconds the new cooldown duration
+   */
+  function setCooldownSeconds(uint40 cooldownSeconds)
+    external
+    onlyCooldownAdmin
+  {
+    _setCooldownSeconds(cooldownSeconds);
+  }
+
+  function _setCooldownSeconds(uint40 cooldownSeconds) internal {
+    duration.cooldownSeconds = cooldownSeconds;
+    emit CooldownSecondsChanged(cooldownSeconds);
+  }
+
+  function getCooldownSeconds() external view returns (uint40) {
+    return duration.cooldownSeconds;
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
+  function _claimRewards(
+    address from,
+    address to,
+    uint256 amount
+  ) internal returns (uint256) {
+    uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
+      from,
+      balanceOf(from),
+      false
+    );
+
+    uint256 amountToClaim = (amount > newTotalRewards)
+      ? newTotalRewards
+      : amount;
+
+    stakerRewardsToClaim[from] = newTotalRewards - amountToClaim;
+    REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
+    emit RewardsClaimed(from, to, amountToClaim);
+    return (amountToClaim);
+  }
+
+  function _stake(
+    address from,
+    address to,
+    uint256 amount,
+    bool pullFunds
+  ) internal {
+    require(amount != 0, 'INVALID_ZERO_AMOUNT');
+
+    uint256 balanceOfUser = balanceOf(to);
+
+    uint256 accruedRewards = _updateUserAssetInternal(
+      to,
+      address(this),
+      balanceOfUser,
+      totalSupply()
+    );
+
+    if (accruedRewards != 0) {
+      emit RewardsAccrued(to, accruedRewards);
+      stakerRewardsToClaim[to] = stakerRewardsToClaim[to] + accruedRewards;
+    }
+
+    stakersCooldowns[to] = getNextCooldownTimestamp(
+      0,
+      amount,
+      to,
+      balanceOfUser
+    );
+
+    uint256 sharesToMint = (amount * TOKEN_UNIT) / exchangeRate();
+    _mint(to, sharesToMint);
+
+    if (pullFunds) {
+      STAKED_TOKEN.safeTransferFrom(from, address(this), amount);
+    }
+
+    emit Staked(from, to, amount, sharesToMint);
+  }
+
+  /**
+   * @dev Calculates the how is gonna be a new cooldown timestamp depending on the sender/receiver situation
+   *  - If the timestamp of the sender is "better" or the timestamp of the recipient is 0, we take the one of the recipient
+   *  - Weighted average of from/to cooldown timestamps if:
+   *    # The sender doesn't have the cooldown activated (timestamp 0).
+   *    # The sender timestamp is expired
+   *    # The sender has a "worse" timestamp
+   *  - If the receiver's cooldown timestamp expired (too old), the next is 0
+   * @param fromCooldownTimestamp Cooldown timestamp of the sender
+   * @param amountToReceive Amount
+   * @param toAddress Address of the recipient
+   * @param toBalance Current balance of the receiver
+   * @return The new cooldown timestamp
+   **/
+  function getNextCooldownTimestamp(
+    uint256 fromCooldownTimestamp,
+    uint256 amountToReceive,
+    address toAddress,
+    uint256 toBalance
+  ) public view override returns (uint256) {
+    uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
+    if (toCooldownTimestamp == 0) {
+      return 0;
+    }
+
+    uint256 minimalValidCooldownTimestamp = block.timestamp -
+      duration.cooldownSeconds -
+      UNSTAKE_WINDOW;
+
+    if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
+      toCooldownTimestamp = 0;
+    } else {
+      uint256 fromCooldownTimestamp = (minimalValidCooldownTimestamp >
+        fromCooldownTimestamp)
+        ? block.timestamp
+        : fromCooldownTimestamp;
+
+      if (fromCooldownTimestamp < toCooldownTimestamp) {
+        return toCooldownTimestamp;
+      } else {
+        toCooldownTimestamp =
+          ((amountToReceive * fromCooldownTimestamp) +
+            (toBalance * toCooldownTimestamp)) /
+          (amountToReceive + toBalance);
+      }
+    }
+    return toCooldownTimestamp;
+  }
+
+  /**
+   * @dev Redeems staked tokens, and stop earning rewards
+   * @param to Address to redeem to
+   * @param amount Amount to redeem
+   **/
+  function _redeem(
+    address from,
+    address to,
+    uint256 amount
+  ) internal {
+    require(amount != 0, 'INVALID_ZERO_AMOUNT');
+    //solium-disable-next-line
+    uint256 cooldownStartTimestamp = stakersCooldowns[from];
+    bool slashingGracePeriod = block.timestamp <=
+      _lastSlashing + duration.slashingExitWindowSeconds;
+
+    if (!slashingGracePeriod) {
+      require(
+        (block.timestamp > cooldownStartTimestamp + duration.cooldownSeconds),
+        'INSUFFICIENT_COOLDOWN'
+      );
+      require(
+        (block.timestamp -
+          (cooldownStartTimestamp + duration.cooldownSeconds) <=
+          UNSTAKE_WINDOW),
+        'UNSTAKE_WINDOW_FINISHED'
+      );
+    }
+    uint256 balanceOfFrom = balanceOf(from);
+
+    uint256 amountToRedeem = (amount > balanceOfFrom) ? balanceOfFrom : amount;
+
+    _updateCurrentUnclaimedRewards(from, balanceOfFrom, true);
+
+    uint256 underlyingToRedeem = (amountToRedeem * exchangeRate()) / TOKEN_UNIT;
+
+    _burn(from, amountToRedeem);
+
+    if (balanceOfFrom - amountToRedeem == 0) {
+      stakersCooldowns[from] = 0;
+    }
+
+    IERC20(STAKED_TOKEN).safeTransfer(to, underlyingToRedeem);
+
+    emit Redeem(from, to, amountToRedeem, underlyingToRedeem);
+  }
+}
+
+/**
+ * @title StakedAaveV3
+ * @notice StakedTokenV3 with AAVE token as staked token
+ * @author Aave
+ **/
+contract StakedAaveV3 is StakedTokenV3 {
+  string internal constant NAME = 'Staked Aave';
+  string internal constant SYMBOL = 'stkAAVE';
+  uint8 internal constant DECIMALS = 18;
+
+  constructor(
+    IERC20 stakedToken,
+    IERC20 rewardToken,
+    uint256 cooldownSeconds,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration,
+    address governance
+  )
+    public
+    StakedTokenV3(
+      stakedToken,
+      rewardToken,
+      cooldownSeconds,
+      unstakeWindow,
+      rewardsVault,
+      emissionManager,
+      distributionDuration,
+      NAME,
+      SYMBOL,
+      governance
+    )
+  {}
+}
