```diff
diff --git a/src/etherscan/mainnet_0x7183143a9e223a12a83d1e28c98f7d01a68993e8/StakedTokenBptRev2/Contract.sol b/src/flattened/StakedAaveV3Flattened.sol
index b49a690..e042fc6 100644
--- a/src/etherscan/mainnet_0x7183143a9e223a12a83d1e28c98f7d01a68993e8/StakedTokenBptRev2/Contract.sol
+++ b/src/flattened/StakedAaveV3Flattened.sol
@@ -1,37 +1,109 @@
-// Sources flattened with hardhat v2.0.8 https://hardhat.org
+// SPDX-License-Identifier: agpl-3.0
+pragma solidity ^0.8.0;
 
-// File @aave/aave-token/contracts/open-zeppelin/Context.sol@v1.0.4
+// most imports are only here to force import order for better (i.e smaller) diff on flattening
 
-// SPDX-License-Identifier: MIT
-pragma solidity ^0.7.5;
-pragma experimental ABIEncoderV2;
+interface IGovernancePowerDelegationToken {
+  enum DelegationType {
+    VOTING_POWER,
+    PROPOSITION_POWER
+  }
 
-// File contracts/lib/Context.sol
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
+// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
 
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
-    return msg.sender;
-  }
+    function _msgSender() internal view virtual returns (address) {
+        return msg.sender;
+    }
 
-  function _msgData() internal view virtual returns (bytes memory) {
-    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
-    return msg.data;
-  }
+    function _msgData() internal view virtual returns (bytes calldata) {
+        return msg.data;
+    }
 }
 
-// File contracts/interfaces/IERC20.sol
-
 /**
  * @dev Interface of the ERC20 standard as defined in the EIP.
  * From https://github.com/OpenZeppelin/openzeppelin-contracts
@@ -63,7 +135,10 @@ interface IERC20 {
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
-  function allowance(address owner, address spender) external view returns (uint256);
+  function allowance(address owner, address spender)
+    external
+    view
+    returns (uint256);
 
   /**
    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
@@ -111,7 +186,289 @@ interface IERC20 {
   event Approval(address indexed owner, address indexed spender, uint256 value);
 }
 
-// File @aave/aave-token/contracts/open-zeppelin/ERC20.sol@v1.0.4
+// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
+
+/**
+ * @dev Collection of functions related to the address type
+ * From https://github.com/OpenZeppelin/openzeppelin-contracts
+ */
+library Address {
+    /**
+     * @dev Returns true if `account` is a contract.
+     *
+     * [IMPORTANT]
+     * ====
+     * It is unsafe to assume that an address for which this function returns
+     * false is an externally-owned account (EOA) and not a contract.
+     *
+     * Among others, `isContract` will return false for the following
+     * types of addresses:
+     *
+     *  - an externally-owned account
+     *  - a contract in construction
+     *  - an address where a contract will be created
+     *  - an address where a contract lived, but was destroyed
+     * ====
+     *
+     * [IMPORTANT]
+     * ====
+     * You shouldn't rely on `isContract` to protect against flash loan attacks!
+     *
+     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
+     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
+     * constructor.
+     * ====
+     */
+    function isContract(address account) internal view returns (bool) {
+        // This method relies on extcodesize/address.code.length, which returns 0
+        // for contracts in construction, since the code is only stored at the end
+        // of the constructor execution.
+
+        return account.code.length > 0;
+    }
+
+    /**
+     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
+     * `recipient`, forwarding all available gas and reverting on errors.
+     *
+     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
+     * of certain opcodes, possibly making contracts go over the 2300 gas limit
+     * imposed by `transfer`, making them unable to receive funds via
+     * `transfer`. {sendValue} removes this limitation.
+     *
+     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
+     *
+     * IMPORTANT: because control is transferred to `recipient`, care must be
+     * taken to not create reentrancy vulnerabilities. Consider using
+     * {ReentrancyGuard} or the
+     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
+     */
+    function sendValue(address payable recipient, uint256 amount) internal {
+        require(
+            address(this).balance >= amount,
+            "Address: insufficient balance"
+        );
+
+        (bool success, ) = recipient.call{ value: amount }("");
+        require(
+            success,
+            "Address: unable to send value, recipient may have reverted"
+        );
+    }
+
+    /**
+     * @dev Performs a Solidity function call using a low level `call`. A
+     * plain `call` is an unsafe replacement for a function call: use this
+     * function instead.
+     *
+     * If `target` reverts with a revert reason, it is bubbled up by this
+     * function (like regular Solidity function calls).
+     *
+     * Returns the raw returned data. To convert to the expected return value,
+     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
+     *
+     * Requirements:
+     *
+     * - `target` must be a contract.
+     * - calling `target` with `data` must not revert.
+     *
+     * _Available since v3.1._
+     */
+    function functionCall(address target, bytes memory data)
+        internal
+        returns (bytes memory)
+    {
+        return functionCall(target, data, "Address: low-level call failed");
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
+     * `errorMessage` as a fallback revert reason when `target` reverts.
+     *
+     * _Available since v3.1._
+     */
+    function functionCall(
+        address target,
+        bytes memory data,
+        string memory errorMessage
+    ) internal returns (bytes memory) {
+        return functionCallWithValue(target, data, 0, errorMessage);
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+     * but also transferring `value` wei to `target`.
+     *
+     * Requirements:
+     *
+     * - the calling contract must have an ETH balance of at least `value`.
+     * - the called Solidity function must be `payable`.
+     *
+     * _Available since v3.1._
+     */
+    function functionCallWithValue(
+        address target,
+        bytes memory data,
+        uint256 value
+    ) internal returns (bytes memory) {
+        return
+            functionCallWithValue(
+                target,
+                data,
+                value,
+                "Address: low-level call with value failed"
+            );
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
+     * with `errorMessage` as a fallback revert reason when `target` reverts.
+     *
+     * _Available since v3.1._
+     */
+    function functionCallWithValue(
+        address target,
+        bytes memory data,
+        uint256 value,
+        string memory errorMessage
+    ) internal returns (bytes memory) {
+        require(
+            address(this).balance >= value,
+            "Address: insufficient balance for call"
+        );
+        require(isContract(target), "Address: call to non-contract");
+
+        (bool success, bytes memory returndata) = target.call{ value: value }(
+            data
+        );
+        return verifyCallResult(success, returndata, errorMessage);
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+     * but performing a static call.
+     *
+     * _Available since v3.3._
+     */
+    function functionStaticCall(address target, bytes memory data)
+        internal
+        view
+        returns (bytes memory)
+    {
+        return
+            functionStaticCall(
+                target,
+                data,
+                "Address: low-level static call failed"
+            );
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+     * but performing a static call.
+     *
+     * _Available since v3.3._
+     */
+    function functionStaticCall(
+        address target,
+        bytes memory data,
+        string memory errorMessage
+    ) internal view returns (bytes memory) {
+        require(isContract(target), "Address: static call to non-contract");
+
+        (bool success, bytes memory returndata) = target.staticcall(data);
+        return verifyCallResult(success, returndata, errorMessage);
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
+     * but performing a delegate call.
+     *
+     * _Available since v3.4._
+     */
+    function functionDelegateCall(address target, bytes memory data)
+        internal
+        returns (bytes memory)
+    {
+        return
+            functionDelegateCall(
+                target,
+                data,
+                "Address: low-level delegate call failed"
+            );
+    }
+
+    /**
+     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
+     * but performing a delegate call.
+     *
+     * _Available since v3.4._
+     */
+    function functionDelegateCall(
+        address target,
+        bytes memory data,
+        string memory errorMessage
+    ) internal returns (bytes memory) {
+        require(isContract(target), "Address: delegate call to non-contract");
+
+        (bool success, bytes memory returndata) = target.delegatecall(data);
+        return verifyCallResult(success, returndata, errorMessage);
+    }
+
+    /**
+     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
+     * revert reason using the provided one.
+     *
+     * _Available since v4.3._
+     */
+    function verifyCallResult(
+        bool success,
+        bytes memory returndata,
+        string memory errorMessage
+    ) internal pure returns (bytes memory) {
+        if (success) {
+            return returndata;
+        } else {
+            // Look for revert reason and bubble it up if present
+            if (returndata.length > 0) {
+                // The easiest way to bubble the revert reason is using memory via assembly
+
+                assembly {
+                    let returndata_size := mload(returndata)
+                    revert(add(32, returndata), returndata_size)
+                }
+            } else {
+                revert(errorMessage);
+            }
+        }
+    }
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
+}
 
 /**
  * @dev Implementation of the {IERC20} interface.
@@ -124,9 +481,10 @@ interface IERC20 {
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
@@ -137,332 +495,396 @@ interface IERC20 {
  * functions have been added to mitigate the well-known issues around setting
  * allowances. See {IERC20-approve}.
  */
-contract ERC20 is Context, IERC20 {
-  using SafeMath for uint256;
-  using Address for address;
-
-  mapping(address => uint256) private _balances;
-
-  mapping(address => mapping(address => uint256)) private _allowances;
-
-  uint256 private _totalSupply;
-
-  string internal _name;
-  string internal _symbol;
-  uint8 private _decimals;
-
-  /**
-   * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
-   * a default value of 18.
-   *
-   * To select a different value for {decimals}, use {_setupDecimals}.
-   *
-   * All three of these values are immutable: they can only be set once during
-   * construction.
-   */
-  constructor(string memory name, string memory symbol) public {
-    _name = name;
-    _symbol = symbol;
-    _decimals = 18;
-  }
-
-  /**
-   * @dev Returns the name of the token.
-   */
-  function name() public view returns (string memory) {
-    return _name;
-  }
-
-  /**
-   * @dev Returns the symbol of the token, usually a shorter version of the
-   * name.
-   */
-  function symbol() public view returns (string memory) {
-    return _symbol;
-  }
-
-  /**
-   * @dev Returns the number of decimals used to get its user representation.
-   * For example, if `decimals` equals `2`, a balance of `505` tokens should
-   * be displayed to a user as `5,05` (`505 / 10 ** 2`).
-   *
-   * Tokens usually opt for a value of 18, imitating the relationship between
-   * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
-   * called.
-   *
-   * NOTE: This information is only used for _display_ purposes: it in
-   * no way affects any of the arithmetic of the contract, including
-   * {IERC20-balanceOf} and {IERC20-transfer}.
-   */
-  function decimals() public view returns (uint8) {
-    return _decimals;
-  }
-
-  /**
-   * @dev See {IERC20-totalSupply}.
-   */
-  function totalSupply() public view override returns (uint256) {
-    return _totalSupply;
-  }
-
-  /**
-   * @dev See {IERC20-balanceOf}.
-   */
-  function balanceOf(address account) public view override returns (uint256) {
-    return _balances[account];
-  }
-
-  /**
-   * @dev See {IERC20-transfer}.
-   *
-   * Requirements:
-   *
-   * - `recipient` cannot be the zero address.
-   * - the caller must have a balance of at least `amount`.
-   */
-  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
-    _transfer(_msgSender(), recipient, amount);
-    return true;
-  }
-
-  /**
-   * @dev See {IERC20-allowance}.
-   */
-  function allowance(address owner, address spender)
-    public
-    view
-    virtual
-    override
-    returns (uint256)
-  {
-    return _allowances[owner][spender];
-  }
-
-  /**
-   * @dev See {IERC20-approve}.
-   *
-   * Requirements:
-   *
-   * - `spender` cannot be the zero address.
-   */
-  function approve(address spender, uint256 amount) public virtual override returns (bool) {
-    _approve(_msgSender(), spender, amount);
-    return true;
-  }
-
-  /**
-   * @dev See {IERC20-transferFrom}.
-   *
-   * Emits an {Approval} event indicating the updated allowance. This is not
-   * required by the EIP. See the note at the beginning of {ERC20};
-   *
-   * Requirements:
-   * - `sender` and `recipient` cannot be the zero address.
-   * - `sender` must have a balance of at least `amount`.
-   * - the caller must have allowance for ``sender``'s tokens of at least
-   * `amount`.
-   */
-  function transferFrom(
-    address sender,
-    address recipient,
-    uint256 amount
-  ) public virtual override returns (bool) {
-    _transfer(sender, recipient, amount);
-    _approve(
-      sender,
-      _msgSender(),
-      _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
-    );
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
-  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
-    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
-  function decreaseAllowance(address spender, uint256 subtractedValue)
-    public
-    virtual
-    returns (bool)
-  {
-    _approve(
-      _msgSender(),
-      spender,
-      _allowances[_msgSender()][spender].sub(
-        subtractedValue,
-        'ERC20: decreased allowance below zero'
-      )
-    );
-    return true;
-  }
-
-  /**
-   * @dev Moves tokens `amount` from `sender` to `recipient`.
-   *
-   * This is internal function is equivalent to {transfer}, and can be used to
-   * e.g. implement automatic token fees, slashing mechanisms, etc.
-   *
-   * Emits a {Transfer} event.
-   *
-   * Requirements:
-   *
-   * - `sender` cannot be the zero address.
-   * - `recipient` cannot be the zero address.
-   * - `sender` must have a balance of at least `amount`.
-   */
-  function _transfer(
-    address sender,
-    address recipient,
-    uint256 amount
-  ) internal virtual {
-    require(sender != address(0), 'ERC20: transfer from the zero address');
-    require(recipient != address(0), 'ERC20: transfer to the zero address');
-
-    _beforeTokenTransfer(sender, recipient, amount);
-
-    _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
-    _balances[recipient] = _balances[recipient].add(amount);
-    emit Transfer(sender, recipient, amount);
-  }
-
-  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
-   * the total supply.
-   *
-   * Emits a {Transfer} event with `from` set to the zero address.
-   *
-   * Requirements
-   *
-   * - `to` cannot be the zero address.
-   */
-  function _mint(address account, uint256 amount) internal virtual {
-    require(account != address(0), 'ERC20: mint to the zero address');
-
-    _beforeTokenTransfer(address(0), account, amount);
-
-    _totalSupply = _totalSupply.add(amount);
-    _balances[account] = _balances[account].add(amount);
-    emit Transfer(address(0), account, amount);
-  }
-
-  /**
-   * @dev Destroys `amount` tokens from `account`, reducing the
-   * total supply.
-   *
-   * Emits a {Transfer} event with `to` set to the zero address.
-   *
-   * Requirements
-   *
-   * - `account` cannot be the zero address.
-   * - `account` must have at least `amount` tokens.
-   */
-  function _burn(address account, uint256 amount) internal virtual {
-    require(account != address(0), 'ERC20: burn from the zero address');
-
-    _beforeTokenTransfer(account, address(0), amount);
-
-    _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
-    _totalSupply = _totalSupply.sub(amount);
-    emit Transfer(account, address(0), amount);
-  }
-
-  /**
-   * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
-   *
-   * This is internal function is equivalent to `approve`, and can be used to
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
-   * @dev Sets {decimals} to a value other than the default one of 18.
-   *
-   * WARNING: This function should only be called from the constructor. Most
-   * applications that interact with token contracts will not expect
-   * {decimals} to ever change, and may work incorrectly if it does.
-   */
-  function _setupDecimals(uint8 decimals_) internal {
-    _decimals = decimals_;
-  }
-
-  /**
-   * @dev Hook that is called before any transfer of tokens. This includes
-   * minting and burning.
-   *
-   * Calling conditions:
-   *
-   * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
-   * will be to transferred to `to`.
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
+contract ERC20 is Context, IERC20, IERC20Metadata {
+    mapping(address => uint256) internal _balances;
+
+    mapping(address => mapping(address => uint256)) private _allowances;
+
+    uint256 internal _totalSupply;
+
+    string private _name;
+    string private _symbol;
+    uint8 private _decimals; // @deprecated
+
+    /**
+     * @dev Sets the values for {name} and {symbol}.
+     *
+     * The default value of {decimals} is 18. To select a different value for
+     * {decimals} you should overload it.
+     *
+     * All two of these values are immutable: they can only be set once during
+     * construction.
+     */
+    constructor(string memory name_, string memory symbol_) {
+        _name = name_;
+        _symbol = symbol_;
+    }
+
+    /**
+     * @dev Returns the name of the token.
+     */
+    function name() public view virtual override returns (string memory) {
+        return _name;
+    }
+
+    /**
+     * @dev Returns the symbol of the token, usually a shorter version of the
+     * name.
+     */
+    function symbol() public view virtual override returns (string memory) {
+        return _symbol;
+    }
+
+    /**
+     * @dev Returns the number of decimals used to get its user representation.
+     * For example, if `decimals` equals `2`, a balance of `505` tokens should
+     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
+     *
+     * Tokens usually opt for a value of 18, imitating the relationship between
+     * Ether and Wei. This is the value {ERC20} uses, unless this function is
+     * overridden;
+     *
+     * NOTE: This information is only used for _display_ purposes: it in
+     * no way affects any of the arithmetic of the contract, including
+     * {IERC20-balanceOf} and {IERC20-transfer}.
+     */
+    function decimals() public view virtual override returns (uint8) {
+        return 18;
+    }
+
+    /**
+     * @dev See {IERC20-totalSupply}.
+     */
+    function totalSupply() public view virtual override returns (uint256) {
+        return _totalSupply;
+    }
+
+    /**
+     * @dev See {IERC20-balanceOf}.
+     */
+    function balanceOf(address account)
+        public
+        view
+        virtual
+        override
+        returns (uint256)
+    {
+        return _balances[account];
+    }
+
+    /**
+     * @dev See {IERC20-transfer}.
+     *
+     * Requirements:
+     *
+     * - `to` cannot be the zero address.
+     * - the caller must have a balance of at least `amount`.
+     */
+    function transfer(address to, uint256 amount)
+        public
+        virtual
+        override
+        returns (bool)
+    {
+        address owner = _msgSender();
+        _transfer(owner, to, amount);
+        return true;
+    }
+
+    /**
+     * @dev See {IERC20-allowance}.
+     */
+    function allowance(address owner, address spender)
+        public
+        view
+        virtual
+        override
+        returns (uint256)
+    {
+        return _allowances[owner][spender];
+    }
+
+    /**
+     * @dev See {IERC20-approve}.
+     *
+     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
+     * `transferFrom`. This is semantically equivalent to an infinite approval.
+     *
+     * Requirements:
+     *
+     * - `spender` cannot be the zero address.
+     */
+    function approve(address spender, uint256 amount)
+        public
+        virtual
+        override
+        returns (bool)
+    {
+        address owner = _msgSender();
+        _approve(owner, spender, amount);
+        return true;
+    }
+
+    /**
+     * @dev See {IERC20-transferFrom}.
+     *
+     * Emits an {Approval} event indicating the updated allowance. This is not
+     * required by the EIP. See the note at the beginning of {ERC20}.
+     *
+     * NOTE: Does not update the allowance if the current allowance
+     * is the maximum `uint256`.
+     *
+     * Requirements:
+     *
+     * - `from` and `to` cannot be the zero address.
+     * - `from` must have a balance of at least `amount`.
+     * - the caller must have allowance for ``from``'s tokens of at least
+     * `amount`.
+     */
+    function transferFrom(
+        address from,
+        address to,
+        uint256 amount
+    ) public virtual override returns (bool) {
+        address spender = _msgSender();
+        _spendAllowance(from, spender, amount);
+        _transfer(from, to, amount);
+        return true;
+    }
+
+    /**
+     * @dev Atomically increases the allowance granted to `spender` by the caller.
+     *
+     * This is an alternative to {approve} that can be used as a mitigation for
+     * problems described in {IERC20-approve}.
+     *
+     * Emits an {Approval} event indicating the updated allowance.
+     *
+     * Requirements:
+     *
+     * - `spender` cannot be the zero address.
+     */
+    function increaseAllowance(address spender, uint256 addedValue)
+        public
+        virtual
+        returns (bool)
+    {
+        address owner = _msgSender();
+        _approve(owner, spender, allowance(owner, spender) + addedValue);
+        return true;
+    }
+
+    /**
+     * @dev Atomically decreases the allowance granted to `spender` by the caller.
+     *
+     * This is an alternative to {approve} that can be used as a mitigation for
+     * problems described in {IERC20-approve}.
+     *
+     * Emits an {Approval} event indicating the updated allowance.
+     *
+     * Requirements:
+     *
+     * - `spender` cannot be the zero address.
+     * - `spender` must have allowance for the caller of at least
+     * `subtractedValue`.
+     */
+    function decreaseAllowance(address spender, uint256 subtractedValue)
+        public
+        virtual
+        returns (bool)
+    {
+        address owner = _msgSender();
+        uint256 currentAllowance = allowance(owner, spender);
+        require(
+            currentAllowance >= subtractedValue,
+            "ERC20: decreased allowance below zero"
+        );
+        unchecked {
+            _approve(owner, spender, currentAllowance - subtractedValue);
+        }
+
+        return true;
+    }
+
+    /**
+     * @dev Moves `amount` of tokens from `from` to `to`.
+     *
+     * This internal function is equivalent to {transfer}, and can be used to
+     * e.g. implement automatic token fees, slashing mechanisms, etc.
+     *
+     * Emits a {Transfer} event.
+     *
+     * Requirements:
+     *
+     * - `from` cannot be the zero address.
+     * - `to` cannot be the zero address.
+     * - `from` must have a balance of at least `amount`.
+     */
+    function _transfer(
+        address from,
+        address to,
+        uint256 amount
+    ) internal virtual {
+        require(from != address(0), "ERC20: transfer from the zero address");
+        require(to != address(0), "ERC20: transfer to the zero address");
+
+        _beforeTokenTransfer(from, to, amount);
+
+        uint256 fromBalance = _balances[from];
+        require(
+            fromBalance >= amount,
+            "ERC20: transfer amount exceeds balance"
+        );
+        unchecked {
+            _balances[from] = fromBalance - amount;
+        }
+        _balances[to] += amount;
+
+        emit Transfer(from, to, amount);
+
+        _afterTokenTransfer(from, to, amount);
+    }
+
+    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
+     * the total supply.
+     *
+     * Emits a {Transfer} event with `from` set to the zero address.
+     *
+     * Requirements:
+     *
+     * - `account` cannot be the zero address.
+     */
+    function _mint(address account, uint256 amount) internal virtual {
+        require(account != address(0), "ERC20: mint to the zero address");
+
+        _beforeTokenTransfer(address(0), account, amount);
+
+        _totalSupply += amount;
+        _balances[account] += amount;
+        emit Transfer(address(0), account, amount);
+
+        _afterTokenTransfer(address(0), account, amount);
+    }
+
+    /**
+     * @dev Destroys `amount` tokens from `account`, reducing the
+     * total supply.
+     *
+     * Emits a {Transfer} event with `to` set to the zero address.
+     *
+     * Requirements:
+     *
+     * - `account` cannot be the zero address.
+     * - `account` must have at least `amount` tokens.
+     */
+    function _burn(address account, uint256 amount) internal virtual {
+        require(account != address(0), "ERC20: burn from the zero address");
+
+        _beforeTokenTransfer(account, address(0), amount);
+
+        uint256 accountBalance = _balances[account];
+        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
+        unchecked {
+            _balances[account] = accountBalance - amount;
+        }
+        _totalSupply -= amount;
+
+        emit Transfer(account, address(0), amount);
+
+        _afterTokenTransfer(account, address(0), amount);
+    }
+
+    /**
+     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
+     *
+     * This internal function is equivalent to `approve`, and can be used to
+     * e.g. set automatic allowances for certain subsystems, etc.
+     *
+     * Emits an {Approval} event.
+     *
+     * Requirements:
+     *
+     * - `owner` cannot be the zero address.
+     * - `spender` cannot be the zero address.
+     */
+    function _approve(
+        address owner,
+        address spender,
+        uint256 amount
+    ) internal virtual {
+        require(owner != address(0), "ERC20: approve from the zero address");
+        require(spender != address(0), "ERC20: approve to the zero address");
+
+        _allowances[owner][spender] = amount;
+        emit Approval(owner, spender, amount);
+    }
+
+    /**
+     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
+     *
+     * Does not update the allowance amount in case of infinite allowance.
+     * Revert if not enough allowance is available.
+     *
+     * Might emit an {Approval} event.
+     */
+    function _spendAllowance(
+        address owner,
+        address spender,
+        uint256 amount
+    ) internal virtual {
+        uint256 currentAllowance = allowance(owner, spender);
+        if (currentAllowance != type(uint256).max) {
+            require(
+                currentAllowance >= amount,
+                "ERC20: insufficient allowance"
+            );
+            unchecked {
+                _approve(owner, spender, currentAllowance - amount);
+            }
+        }
+    }
+
+    /**
+     * @dev Hook that is called before any transfer of tokens. This includes
+     * minting and burning.
+     *
+     * Calling conditions:
+     *
+     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
+     * will be transferred to `to`.
+     * - when `from` is zero, `amount` tokens will be minted for `to`.
+     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
+     * - `from` and `to` are never both zero.
+     *
+     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
+     */
+    function _beforeTokenTransfer(
+        address from,
+        address to,
+        uint256 amount
+    ) internal virtual {}
+
+    /**
+     * @dev Hook that is called after any transfer of tokens. This includes
+     * minting and burning.
+     *
+     * Calling conditions:
+     *
+     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
+     * has been transferred to `to`.
+     * - when `from` is zero, `amount` tokens have been minted for `to`.
+     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
+     * - `from` and `to` are never both zero.
+     *
+     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
+     */
+    function _afterTokenTransfer(
+        address from,
+        address to,
+        uint256 amount
+    ) internal virtual {}
 }
 
-// File contracts/interfaces/IStakedAave.sol
-
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
-// File contracts/interfaces/ITransferHook.sol
-
 interface ITransferHook {
   function onTransfer(
     address from,
@@ -471,254 +893,25 @@ interface ITransferHook {
   ) external;
 }
 
-// File contracts/lib/DistributionTypes.sol
-
 library DistributionTypes {
-  struct AssetConfigInput {
-    uint128 emissionPerSecond;
-    uint256 totalStaked;
-    address underlyingAsset;
-  }
-
-  struct UserStakeInput {
-    address underlyingAsset;
-    uint256 stakedByUser;
-    uint256 totalStaked;
-  }
-}
-
-// File contracts/lib/SafeMath.sol
-
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
+    struct AssetConfigInput {
+        uint128 emissionPerSecond;
+        uint256 totalStaked;
+        address underlyingAsset;
     }
 
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
-
-// File contracts/lib/Address.sol
-
-/**
- * @dev Collection of functions related to the address type
- * From https://github.com/OpenZeppelin/openzeppelin-contracts
- */
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
+    struct UserStakeInput {
+        address underlyingAsset;
+        uint256 stakedByUser;
+        uint256 totalStaked;
     }
-    return (codehash != accountHash && codehash != 0x0);
-  }
-
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
-    require(success, 'Address: unable to send value, recipient may have reverted');
-  }
 }
 
-// File contracts/lib/SafeERC20.sol
+// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
 
 /**
  * @title SafeERC20
- * @dev From https://github.com/OpenZeppelin/openzeppelin-contracts
- * Wrappers around ERC20 operations that throw on failure (when the token
+ * @dev Wrappers around ERC20 operations that throw on failure (when the token
  * contract returns false). Tokens that return no value (and instead revert or
  * throw on failure) are also supported, non-reverting calls are assumed to be
  * successful.
@@ -726,55 +919,120 @@ library Address {
  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
  */
 library SafeERC20 {
-  using SafeMath for uint256;
-  using Address for address;
+    using Address for address;
 
-  function safeTransfer(
-    IERC20 token,
-    address to,
-    uint256 value
-  ) internal {
-    callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
-  }
+    function safeTransfer(
+        IERC20 token,
+        address to,
+        uint256 value
+    ) internal {
+        _callOptionalReturn(
+            token,
+            abi.encodeWithSelector(token.transfer.selector, to, value)
+        );
+    }
+
+    function safeTransferFrom(
+        IERC20 token,
+        address from,
+        address to,
+        uint256 value
+    ) internal {
+        _callOptionalReturn(
+            token,
+            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
+        );
+    }
 
-  function safeTransferFrom(
-    IERC20 token,
-    address from,
-    address to,
-    uint256 value
-  ) internal {
-    callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
-  }
+    /**
+     * @dev Deprecated. This function has issues similar to the ones found in
+     * {IERC20-approve}, and its usage is discouraged.
+     *
+     * Whenever possible, use {safeIncreaseAllowance} and
+     * {safeDecreaseAllowance} instead.
+     */
+    function safeApprove(
+        IERC20 token,
+        address spender,
+        uint256 value
+    ) internal {
+        // safeApprove should only be called when setting an initial allowance,
+        // or when resetting it to zero. To increase and decrease it, use
+        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
+        require(
+            (value == 0) || (token.allowance(address(this), spender) == 0),
+            "SafeERC20: approve from non-zero to non-zero allowance"
+        );
+        _callOptionalReturn(
+            token,
+            abi.encodeWithSelector(token.approve.selector, spender, value)
+        );
+    }
 
-  function safeApprove(
-    IERC20 token,
-    address spender,
-    uint256 value
-  ) internal {
-    require(
-      (value == 0) || (token.allowance(address(this), spender) == 0),
-      'SafeERC20: approve from non-zero to non-zero allowance'
-    );
-    callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
-  }
+    function safeIncreaseAllowance(
+        IERC20 token,
+        address spender,
+        uint256 value
+    ) internal {
+        uint256 newAllowance = token.allowance(address(this), spender) + value;
+        _callOptionalReturn(
+            token,
+            abi.encodeWithSelector(
+                token.approve.selector,
+                spender,
+                newAllowance
+            )
+        );
+    }
 
-  function callOptionalReturn(IERC20 token, bytes memory data) private {
-    require(address(token).isContract(), 'SafeERC20: call to non-contract');
+    function safeDecreaseAllowance(
+        IERC20 token,
+        address spender,
+        uint256 value
+    ) internal {
+        unchecked {
+            uint256 oldAllowance = token.allowance(address(this), spender);
+            require(
+                oldAllowance >= value,
+                "SafeERC20: decreased allowance below zero"
+            );
+            uint256 newAllowance = oldAllowance - value;
+            _callOptionalReturn(
+                token,
+                abi.encodeWithSelector(
+                    token.approve.selector,
+                    spender,
+                    newAllowance
+                )
+            );
+        }
+    }
 
-    // solhint-disable-next-line avoid-low-level-calls
-    (bool success, bytes memory returndata) = address(token).call(data);
-    require(success, 'SafeERC20: low-level call failed');
+    /**
+     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
+     * on the return value: the return value is optional (but if data is returned, it must not be false).
+     * @param token The token targeted by the call.
+     * @param data The call data (encoded using abi.encode or one of its variants).
+     */
+    function _callOptionalReturn(IERC20 token, bytes memory data) private {
+        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
+        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
+        // the target address contains contract code and also asserts for success in the low-level call.
 
-    if (returndata.length > 0) {
-      // Return data is optional
-      // solhint-disable-next-line max-line-length
-      require(abi.decode(returndata, (bool)), 'SafeERC20: ERC20 operation did not succeed');
+        bytes memory returndata = address(token).functionCall(
+            data,
+            "SafeERC20: low-level call failed"
+        );
+        if (returndata.length > 0) {
+            // Return data is optional
+            require(
+                abi.decode(returndata, (bool)),
+                "SafeERC20: ERC20 operation did not succeed"
+            );
+        }
     }
-  }
 }
 
-// File contracts/utils/VersionedInitializable.sol
-
 /**
  * @title VersionedInitializable
  *
@@ -800,7 +1058,10 @@ abstract contract VersionedInitializable {
    */
   modifier initializer() {
     uint256 revision = getRevision();
-    require(revision > lastInitializedRevision, 'Contract instance has already been initialized');
+    require(
+      revision > lastInitializedRevision,
+      'Contract instance has already been initialized'
+    );
 
     lastInitializedRevision = revision;
 
@@ -815,23 +1076,18 @@ abstract contract VersionedInitializable {
   uint256[50] private ______gap;
 }
 
-// File contracts/interfaces/IAaveDistributionManager.sol
-
 interface IAaveDistributionManager {
-  function configureAssets(DistributionTypes.AssetConfigInput[] calldata assetsConfigInput)
-    external;
+  function configureAssets(
+    DistributionTypes.AssetConfigInput[] calldata assetsConfigInput
+  ) external;
 }
 
-// File contracts/stake/AaveDistributionManager.sol
-
 /**
  * @title AaveDistributionManager
  * @notice Accounting contract to manage multiple staking distributions
  * @author Aave
  **/
 contract AaveDistributionManager is IAaveDistributionManager {
-  using SafeMath for uint256;
-
   struct AssetData {
     uint128 emissionPerSecond;
     uint128 lastUpdateTimestamp;
@@ -849,10 +1105,14 @@ contract AaveDistributionManager is IAaveDistributionManager {
 
   event AssetConfigUpdated(address indexed asset, uint256 emission);
   event AssetIndexUpdated(address indexed asset, uint256 index);
-  event UserIndexUpdated(address indexed user, address indexed asset, uint256 index);
+  event UserIndexUpdated(
+    address indexed user,
+    address indexed asset,
+    uint256 index
+  );
 
-  constructor(address emissionManager, uint256 distributionDuration) public {
-    DISTRIBUTION_END = block.timestamp.add(distributionDuration);
+  constructor(address emissionManager, uint256 distributionDuration) {
+    DISTRIBUTION_END = block.timestamp + distributionDuration;
     EMISSION_MANAGER = emissionManager;
   }
 
@@ -860,14 +1120,15 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @dev Configures the distribution of rewards for a list of assets
    * @param assetsConfigInput The list of configurations to apply
    **/
-  function configureAssets(DistributionTypes.AssetConfigInput[] calldata assetsConfigInput)
-    external
-    override
-  {
+  function configureAssets(
+    DistributionTypes.AssetConfigInput[] calldata assetsConfigInput
+  ) external override {
     require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
 
     for (uint256 i = 0; i < assetsConfigInput.length; i++) {
-      AssetData storage assetConfig = assets[assetsConfigInput[i].underlyingAsset];
+      AssetData storage assetConfig = assets[
+        assetsConfigInput[i].underlyingAsset
+      ];
 
       _updateAssetStateInternal(
         assetsConfigInput[i].underlyingAsset,
@@ -903,8 +1164,12 @@ contract AaveDistributionManager is IAaveDistributionManager {
       return oldIndex;
     }
 
-    uint256 newIndex =
-      _getAssetIndex(oldIndex, assetConfig.emissionPerSecond, lastUpdateTimestamp, totalStaked);
+    uint256 newIndex = _getAssetIndex(
+      oldIndex,
+      assetConfig.emissionPerSecond,
+      lastUpdateTimestamp,
+      totalStaked
+    );
 
     if (newIndex != oldIndex) {
       assetConfig.index = newIndex;
@@ -954,21 +1219,21 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param stakes List of structs of the user data related with his stake
    * @return The accrued rewards for the user until the moment
    **/
-  function _claimRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
-    internal
-    returns (uint256)
-  {
+  function _claimRewards(
+    address user,
+    DistributionTypes.UserStakeInput[] memory stakes
+  ) internal returns (uint256) {
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
@@ -980,26 +1245,28 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param stakes List of structs of the user data related with his stake
    * @return The accrued rewards for the user until the moment
    **/
-  function _getUnclaimedRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
-    internal
-    view
-    returns (uint256)
-  {
+  function _getUnclaimedRewards(
+    address user,
+    DistributionTypes.UserStakeInput[] memory stakes
+  ) internal view returns (uint256) {
     uint256 accruedRewards = 0;
 
     for (uint256 i = 0; i < stakes.length; i++) {
       AssetData storage assetConfig = assets[stakes[i].underlyingAsset];
-      uint256 assetIndex =
-        _getAssetIndex(
-          assetConfig.index,
-          assetConfig.emissionPerSecond,
-          assetConfig.lastUpdateTimestamp,
-          stakes[i].totalStaked
-        );
-
-      accruedRewards = accruedRewards.add(
-        _getRewards(stakes[i].stakedByUser, assetIndex, assetConfig.users[user])
+      uint256 assetIndex = _getAssetIndex(
+        assetConfig.index,
+        assetConfig.emissionPerSecond,
+        assetConfig.lastUpdateTimestamp,
+        stakes[i].totalStaked
       );
+
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
@@ -1016,7 +1283,9 @@ contract AaveDistributionManager is IAaveDistributionManager {
     uint256 reserveIndex,
     uint256 userIndex
   ) internal pure returns (uint256) {
-    return principalUserBalance.mul(reserveIndex.sub(userIndex)).div(10**uint256(PRECISION));
+    return
+      (principalUserBalance * (reserveIndex - userIndex)) /
+      (10**uint256(PRECISION));
   }
 
   /**
@@ -1042,13 +1311,13 @@ contract AaveDistributionManager is IAaveDistributionManager {
       return currentIndex;
     }
 
-    uint256 currentTimestamp =
-      block.timestamp > DISTRIBUTION_END ? DISTRIBUTION_END : block.timestamp;
-    uint256 timeDelta = currentTimestamp.sub(lastUpdateTimestamp);
+    uint256 currentTimestamp = block.timestamp > DISTRIBUTION_END
+      ? DISTRIBUTION_END
+      : block.timestamp;
+    uint256 timeDelta = currentTimestamp - lastUpdateTimestamp;
     return
-      emissionPerSecond.mul(timeDelta).mul(10**uint256(PRECISION)).div(totalBalance).add(
-        currentIndex
-      );
+      ((emissionPerSecond * timeDelta * (10**uint256(PRECISION))) /
+        totalBalance) + currentIndex;
   }
 
   /**
@@ -1057,113 +1326,28 @@ contract AaveDistributionManager is IAaveDistributionManager {
    * @param asset The address of the reference asset of the distribution
    * @return The new index
    **/
-  function getUserAssetData(address user, address asset) public view returns (uint256) {
+  function getUserAssetData(address user, address asset)
+    public
+    view
+    returns (uint256)
+  {
     return assets[asset].users[user];
   }
 }
 
-// File contracts/interfaces/IERC20Detailed.sol
-
-/**
- * @dev Interface for ERC20 including metadata
- **/
-interface IERC20Detailed is IERC20 {
-  function name() external view returns (string memory);
-
-  function symbol() external view returns (string memory);
-
-  function decimals() external view returns (uint8);
-}
-
-// File @aave/aave-token/contracts/interfaces/IGovernancePowerDelegationToken.sol@v1.0.4
-
-interface IGovernancePowerDelegationToken {
-  enum DelegationType {VOTING_POWER, PROPOSITION_POWER}
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
-  event DelegatedPowerChanged(address indexed user, uint256 amount, DelegationType delegationType);
-
-  /**
-   * @dev delegates the specific power to a delegatee
-   * @param delegatee the user which delegated power has changed
-   * @param delegationType the type of delegation (VOTING_POWER, PROPOSITION_POWER)
-   **/
-  function delegateByType(address delegatee, DelegationType delegationType) external virtual;
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
-  function totalSupplyAt(uint256 blockNumber) external view virtual returns (uint256);
-}
-
-// File @aave/aave-token/contracts/token/base/GovernancePowerDelegationERC20.sol@v1.0.4
-
 /**
  * @notice implementation of the AAVE token contract
  * @author Aave
  */
 abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDelegationToken {
-  using SafeMath for uint256;
   /// @notice The EIP-712 typehash for the delegation struct used by the contract
-  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
-    keccak256('DelegateByType(address delegatee,uint256 type,uint256 nonce,uint256 expiry)');
+  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH = keccak256(
+    'DelegateByType(address delegatee,uint256 type,uint256 nonce,uint256 expiry)'
+  );
 
-  bytes32 public constant DELEGATE_TYPEHASH =
-    keccak256('Delegate(address delegatee,uint256 nonce,uint256 expiry)');
+  bytes32 public constant DELEGATE_TYPEHASH = keccak256(
+    'Delegate(address delegatee,uint256 nonce,uint256 expiry)'
+  );
 
   /// @dev snapshot of a value on a specific block, used for votes
   struct Snapshot {
@@ -1195,8 +1379,8 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
    **/
   function getDelegateeByType(address delegator, DelegationType delegationType)
     external
-    view
     override
+    view
     returns (address)
   {
     (, , mapping(address => address) storage delegates) = _getDelegationDataByType(delegationType);
@@ -1211,8 +1395,8 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
    **/
   function getPowerCurrent(address user, DelegationType delegationType)
     external
-    view
     override
+    view
     returns (uint256)
   {
     (
@@ -1232,7 +1416,7 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
     address user,
     uint256 blockNumber,
     DelegationType delegationType
-  ) external view override returns (uint256) {
+  ) external override view returns (uint256) {
     (
       mapping(address => mapping(uint256 => Snapshot)) storage snapshots,
       mapping(address => uint256) storage snapshotsCounts,
@@ -1248,7 +1432,7 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
    * In this initial implementation with no AAVE minting, simply returns the current supply
    * A snapshots mapping will need to be added in case a mint function is added to the AAVE token in the future
    **/
-  function totalSupplyAt(uint256 blockNumber) external view override returns (uint256) {
+  function totalSupplyAt(uint256) external override view returns (uint256) {
     return super.totalSupply();
   }
 
@@ -1314,10 +1498,10 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
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
@@ -1333,10 +1517,10 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
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
 
@@ -1352,7 +1536,7 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
     mapping(address => uint256) storage snapshotsCounts,
     address user,
     uint256 blockNumber
-  ) internal view returns (uint256) {
+  ) internal virtual view returns (uint256) {
     require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
 
     uint256 snapshotsCount = snapshotsCounts[user];
@@ -1396,8 +1580,8 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
    **/
   function _getDelegationDataByType(DelegationType delegationType)
     internal
-    view
     virtual
+    view
     returns (
       mapping(address => mapping(uint256 => Snapshot)) storage, //snapshots
       mapping(address => uint256) storage, //snapshots count
@@ -1455,16 +1639,12 @@ abstract contract GovernancePowerDelegationERC20 is ERC20, IGovernancePowerDeleg
   }
 }
 
-// File contracts/lib/GovernancePowerWithSnapshot.sol
-
 /**
  * @title ERC20WithSnapshot
  * @notice ERC20 including snapshots of balances on transfer-related actions
  * @author Aave
  **/
 abstract contract GovernancePowerWithSnapshot is GovernancePowerDelegationERC20 {
-  using SafeMath for uint256;
-
   /**
    * @dev The following storage layout points to the prior StakedToken.sol implementation:
    * _snapshots => _votingSnapshots
@@ -1477,31 +1657,63 @@ abstract contract GovernancePowerWithSnapshot is GovernancePowerDelegationERC20
   /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
   /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
   /// to control all potential reentrancies by calling back the this contract
+  /// @dev DEPRECATED
   ITransferHook public _aaveGovernance;
+}
 
-  function _setAaveGovernance(ITransferHook aaveGovernance) internal virtual {
-    _aaveGovernance = aaveGovernance;
-  }
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
 }
 
-// File contracts/stake/StakedTokenV3.sol
+interface IStakedToken {
+  /**
+   * @dev Allows staking a specified amount of STAKED_TOKEN
+   * @param to The address to receiving the shares
+   * @param amount The amount of assets to be staked
+   **/
+  function stake(address to, uint256 amount) external;
+
+  /**
+   * @dev Redeems shares, and stop earning rewards
+   * @param to Address to redeem to
+   * @param amount Amount of shares to redeem
+   **/
+  function redeem(address to, uint256 amount) external;
+
+  function cooldown() external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` to the address `to`
+   * @param to Address to send the claimed rewards
+   * @param amount Amount to stake
+   **/
+  function claimRewards(address to, uint256 amount) external;
+}
 
 /**
  * @title StakedToken
  * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
  * @author Aave
  **/
-contract StakedTokenBptRev2 is
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
-  uint256 public constant REVISION = 2;
+  function REVISION() public pure virtual returns (uint256) {
+    return 2;
+  }
 
   IERC20 public immutable STAKED_TOKEN;
   IERC20 public immutable REWARD_TOKEN;
@@ -1521,25 +1733,38 @@ contract StakedTokenBptRev2 is
   /// @dev To see the voting mappings, go to GovernancePowerWithSnapshot.sol
   mapping(address => address) internal _votingDelegates;
 
-  mapping(address => mapping(uint256 => Snapshot)) internal _propositionPowerSnapshots;
+  mapping(address => mapping(uint256 => Snapshot))
+    internal _propositionPowerSnapshots;
   mapping(address => uint256) internal _propositionPowerSnapshotsCounts;
   mapping(address => address) internal _propositionPowerDelegates;
 
   bytes32 public DOMAIN_SEPARATOR;
   bytes public constant EIP712_REVISION = bytes('1');
   bytes32 internal constant EIP712_DOMAIN =
-    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');
+    keccak256(
+      'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
+    );
   bytes32 public constant PERMIT_TYPEHASH =
-    keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
+    keccak256(
+      'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'
+    );
 
   /// @dev owner => next valid nonce to submit with permit()
   mapping(address => uint256) public _nonces;
 
-  event Staked(address indexed from, address indexed onBehalfOf, uint256 amount);
+  event Staked(
+    address indexed from,
+    address indexed onBehalfOf,
+    uint256 amount
+  );
   event Redeem(address indexed from, address indexed to, uint256 amount);
 
   event RewardsAccrued(address user, uint256 amount);
-  event RewardsClaimed(address indexed from, address indexed to, uint256 amount);
+  event RewardsClaimed(
+    address indexed from,
+    address indexed to,
+    uint256 amount
+  );
 
   event Cooldown(address indexed user);
 
@@ -1553,26 +1778,24 @@ contract StakedTokenBptRev2 is
     uint128 distributionDuration,
     string memory name,
     string memory symbol,
-    uint8 decimals,
     address governance
-  ) public ERC20(name, symbol) AaveDistributionManager(emissionManager, distributionDuration) {
+  )
+    public
+    ERC20(name, symbol)
+    AaveDistributionManager(emissionManager, distributionDuration)
+  {
     STAKED_TOKEN = stakedToken;
     REWARD_TOKEN = rewardToken;
     COOLDOWN_SECONDS = cooldownSeconds;
     UNSTAKE_WINDOW = unstakeWindow;
     REWARDS_VAULT = rewardsVault;
     _aaveGovernance = ITransferHook(governance);
-    ERC20._setupDecimals(decimals);
   }
 
   /**
    * @dev Called by the proxy contract
    **/
-  function initialize(
-    string calldata name,
-    string calldata symbol,
-    uint8 decimals
-  ) external initializer {
+  function initialize() external virtual initializer {
     uint256 chainId;
 
     //solium-disable-next-line
@@ -1583,31 +1806,37 @@ contract StakedTokenBptRev2 is
     DOMAIN_SEPARATOR = keccak256(
       abi.encode(
         EIP712_DOMAIN,
-        keccak256(bytes(super.name())),
+        keccak256(bytes(name())),
         keccak256(EIP712_REVISION),
         chainId,
         address(this)
       )
     );
-    if (REVISION == 1) {
-      _name = name;
-      _symbol = symbol;
-      _setupDecimals(decimals);
-    }
   }
 
-  function stake(address onBehalfOf, uint256 amount) external override {
+  function stake(address onBehalfOf, uint256 amount) external virtual override {
     require(amount != 0, 'INVALID_ZERO_AMOUNT');
     uint256 balanceOfUser = balanceOf(onBehalfOf);
 
-    uint256 accruedRewards =
-      _updateUserAssetInternal(onBehalfOf, address(this), balanceOfUser, totalSupply());
+    uint256 accruedRewards = _updateUserAssetInternal(
+      onBehalfOf,
+      address(this),
+      balanceOfUser,
+      totalSupply()
+    );
     if (accruedRewards != 0) {
       emit RewardsAccrued(onBehalfOf, accruedRewards);
-      stakerRewardsToClaim[onBehalfOf] = stakerRewardsToClaim[onBehalfOf].add(accruedRewards);
+      stakerRewardsToClaim[onBehalfOf] =
+        stakerRewardsToClaim[onBehalfOf] +
+        accruedRewards;
     }
 
-    stakersCooldowns[onBehalfOf] = getNextCooldownTimestamp(0, amount, onBehalfOf, balanceOfUser);
+    stakersCooldowns[onBehalfOf] = getNextCooldownTimestamp(
+      0,
+      amount,
+      onBehalfOf,
+      balanceOfUser
+    );
 
     _mint(onBehalfOf, amount);
     IERC20(STAKED_TOKEN).safeTransferFrom(msg.sender, address(this), amount);
@@ -1620,27 +1849,30 @@ contract StakedTokenBptRev2 is
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
-      block.timestamp.sub(cooldownStartTimestamp.add(COOLDOWN_SECONDS)) <= UNSTAKE_WINDOW,
+      block.timestamp - (cooldownStartTimestamp + COOLDOWN_SECONDS) <=
+        UNSTAKE_WINDOW,
       'UNSTAKE_WINDOW_FINISHED'
     );
     uint256 balanceOfMessageSender = balanceOf(msg.sender);
 
-    uint256 amountToRedeem = (amount > balanceOfMessageSender) ? balanceOfMessageSender : amount;
+    uint256 amountToRedeem = (amount > balanceOfMessageSender)
+      ? balanceOfMessageSender
+      : amount;
 
     _updateCurrentUnclaimedRewards(msg.sender, balanceOfMessageSender, true);
 
     _burn(msg.sender, amountToRedeem);
 
-    if (balanceOfMessageSender.sub(amountToRedeem) == 0) {
+    if (balanceOfMessageSender - amountToRedeem == 0) {
       stakersCooldowns[msg.sender] = 0;
     }
 
@@ -1666,12 +1898,17 @@ contract StakedTokenBptRev2 is
    * @param to Address to stake for
    * @param amount Amount to stake
    **/
-  function claimRewards(address to, uint256 amount) external override {
-    uint256 newTotalRewards =
-      _updateCurrentUnclaimedRewards(msg.sender, balanceOf(msg.sender), false);
-    uint256 amountToClaim = (amount == type(uint256).max) ? newTotalRewards : amount;
+  function claimRewards(address to, uint256 amount) external virtual override {
+    uint256 newTotalRewards = _updateCurrentUnclaimedRewards(
+      msg.sender,
+      balanceOf(msg.sender),
+      false
+    );
+    uint256 amountToClaim = (amount == type(uint256).max)
+      ? newTotalRewards
+      : amount;
 
-    stakerRewardsToClaim[msg.sender] = newTotalRewards.sub(amountToClaim, 'INVALID_AMOUNT');
+    stakerRewardsToClaim[msg.sender] = newTotalRewards - amountToClaim;
 
     REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
 
@@ -1726,9 +1963,13 @@ contract StakedTokenBptRev2 is
     uint256 userBalance,
     bool updateStorage
   ) internal returns (uint256) {
-    uint256 accruedRewards =
-      _updateUserAssetInternal(user, address(this), userBalance, totalSupply());
-    uint256 unclaimedRewards = stakerRewardsToClaim[user].add(accruedRewards);
+    uint256 accruedRewards = _updateUserAssetInternal(
+      user,
+      address(this),
+      userBalance,
+      totalSupply()
+    );
+    uint256 unclaimedRewards = stakerRewardsToClaim[user] + accruedRewards;
 
     if (accruedRewards != 0) {
       if (updateStorage) {
@@ -1759,30 +2000,31 @@ contract StakedTokenBptRev2 is
     uint256 amountToReceive,
     address toAddress,
     uint256 toBalance
-  ) public view returns (uint256) {
+  ) public view virtual returns (uint256) {
     uint256 toCooldownTimestamp = stakersCooldowns[toAddress];
     if (toCooldownTimestamp == 0) {
       return 0;
     }
 
-    uint256 minimalValidCooldownTimestamp =
-      block.timestamp.sub(COOLDOWN_SECONDS).sub(UNSTAKE_WINDOW);
+    uint256 minimalValidCooldownTimestamp = block.timestamp -
+      COOLDOWN_SECONDS -
+      UNSTAKE_WINDOW;
 
     if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
       toCooldownTimestamp = 0;
     } else {
-      uint256 fromCooldownTimestamp =
-        (minimalValidCooldownTimestamp > fromCooldownTimestamp)
-          ? block.timestamp
-          : fromCooldownTimestamp;
+      uint256 nextCooldownTimestamp = (minimalValidCooldownTimestamp >
+        fromCooldownTimestamp)
+        ? block.timestamp
+        : fromCooldownTimestamp;
 
-      if (fromCooldownTimestamp < toCooldownTimestamp) {
+      if (nextCooldownTimestamp < toCooldownTimestamp) {
         return toCooldownTimestamp;
       } else {
-        toCooldownTimestamp = (
-          amountToReceive.mul(fromCooldownTimestamp).add(toBalance.mul(toCooldownTimestamp))
-        )
-          .div(amountToReceive.add(toBalance));
+        toCooldownTimestamp =
+          ((amountToReceive * nextCooldownTimestamp) +
+            (toBalance * toCooldownTimestamp)) /
+          (amountToReceive + toBalance);
       }
     }
     return toCooldownTimestamp;
@@ -1793,23 +2035,29 @@ contract StakedTokenBptRev2 is
    * @param staker The staker address
    * @return The rewards
    */
-  function getTotalRewardsBalance(address staker) external view returns (uint256) {
-    DistributionTypes.UserStakeInput[] memory userStakeInputs =
-      new DistributionTypes.UserStakeInput[](1);
+  function getTotalRewardsBalance(address staker)
+    external
+    view
+    returns (uint256)
+  {
+    DistributionTypes.UserStakeInput[]
+      memory userStakeInputs = new DistributionTypes.UserStakeInput[](1);
     userStakeInputs[0] = DistributionTypes.UserStakeInput({
       underlyingAsset: address(this),
       stakedByUser: balanceOf(staker),
       totalStaked: totalSupply()
     });
-    return stakerRewardsToClaim[staker].add(_getUnclaimedRewards(staker, userStakeInputs));
+    return
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
@@ -1836,17 +2084,25 @@ contract StakedTokenBptRev2 is
     //solium-disable-next-line
     require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
     uint256 currentValidNonce = _nonces[owner];
-    bytes32 digest =
-      keccak256(
-        abi.encodePacked(
-          '\x19\x01',
-          DOMAIN_SEPARATOR,
-          keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
+    bytes32 digest = keccak256(
+      abi.encodePacked(
+        '\x19\x01',
+        DOMAIN_SEPARATOR,
+        keccak256(
+          abi.encode(
+            PERMIT_TYPEHASH,
+            owner,
+            spender,
+            value,
+            currentValidNonce,
+            deadline
+          )
         )
-      );
+      )
+    );
 
     require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
-    _nonces[owner] = currentValidNonce.add(1);
+    _nonces[owner] = currentValidNonce + 1;
     _approve(owner, spender, value);
   }
 
@@ -1863,7 +2119,7 @@ contract StakedTokenBptRev2 is
     address from,
     address to,
     uint256 amount
-  ) internal override {
+  ) internal virtual override {
     address votingFromDelegatee = _votingDelegates[from];
     address votingToDelegatee = _votingDelegates[to];
 
@@ -1900,7 +2156,7 @@ contract StakedTokenBptRev2 is
 
     // caching the aave governance address to avoid multiple state loads
     ITransferHook aaveGovernance = _aaveGovernance;
-    if (aaveGovernance != ITransferHook(0)) {
+    if (address(aaveGovernance) != address(0)) {
       aaveGovernance.onTransfer(from, to, amount);
     }
   }
@@ -1945,11 +2201,18 @@ contract StakedTokenBptRev2 is
     bytes32 r,
     bytes32 s
   ) public {
-    bytes32 structHash =
-      keccak256(
-        abi.encode(DELEGATE_BY_TYPE_TYPEHASH, delegatee, uint256(delegationType), nonce, expiry)
-      );
-    bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash));
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
     address signatory = ecrecover(digest, v, r, s);
     require(signatory != address(0), 'INVALID_SIGNATURE');
     require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
@@ -1974,8 +2237,12 @@ contract StakedTokenBptRev2 is
     bytes32 r,
     bytes32 s
   ) public {
-    bytes32 structHash = keccak256(abi.encode(DELEGATE_TYPEHASH, delegatee, nonce, expiry));
-    bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash));
+    bytes32 structHash = keccak256(
+      abi.encode(DELEGATE_TYPEHASH, delegatee, nonce, expiry)
+    );
+    bytes32 digest = keccak256(
+      abi.encodePacked('\x19\x01', DOMAIN_SEPARATOR, structHash)
+    );
     address signatory = ecrecover(digest, v, r, s);
     require(signatory != address(0), 'INVALID_SIGNATURE');
     require(nonce == _nonces[signatory]++, 'INVALID_NONCE');
@@ -1984,3 +2251,1060 @@ contract StakedTokenBptRev2 is
     _delegateByType(signatory, delegatee, DelegationType.PROPOSITION_POWER);
   }
 }
+
+interface IStakedTokenV3 is IStakedToken {
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
+  event ExchangeRateChanged(uint128 exchangeRate);
+  event FundsReturned(uint256 amount);
+  event SlashingSettled();
+
+  /**
+   * @dev Returns the current exchange rate
+   * @return exchangeRate as 18 decimal precision uint128
+   **/
+  function getExchangeRate() external view returns (uint128);
+
+  /**
+   * @dev Executes a slashing of the underlying of a certain amount, transferring the seized funds
+   * to destination. Decreasing the amount of underlying will automatically adjust the exchange rate.
+   * A call to `slash` will start a slashing event which has to be settled via `settleSlashing`.
+   * As long as the slashing event is ongoing, stake and slash are deactivated.
+   * @param destination the address where seized funds will be transferred
+   * @param amount the amount to be slashed
+   * If the amount bigger than maximum allowed, the maximum will be slashed instead.
+   * @return amount the amount slashed
+   **/
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
+   * @dev Pulls STAKE_TOKEN and distributes them amonst current stakers by altering the exchange rate.
+   * This method is permissionless and intendet to be used after a slashing event to return potential excess funds.
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
+   * @return shares the number of shares that would be received
+   */
+  function previewStake(uint256 assets) external view returns (uint256);
+
+  /**
+   * @dev Allows staking a certain amount of STAKED_TOKEN with gasless approvals (permit)
+   * @param to The address to receiving the shares
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
+  ) external;
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
+  ) external returns (uint256);
+
+  /**
+   * @dev returns the exact amount of assets that would be redeemed for the provided number of shares
+   * @param shares the number of shares to redeem
+   * @return assets the number of assets that would be redeemed
+   */
+  function previewRedeem(uint256 shares) external view returns (uint256);
+
+  /**
+   * @dev Redeems shares for a user. Only the claim helper contract is allowed to call this function
+   * @param from Address to redeem from
+   * @param to Address to redeem to
+   * @param amount Amount of shares to redeem
+   **/
+  function redeemOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external;
+
+  /**
+   * @dev Claims an `amount` of `REWARD_TOKEN` and restakes
+   * @param to Address to stake to
+   * @param amount Amount to claim
+   **/
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    returns (uint256);
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
+  ) external;
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
+  ) external returns (uint256);
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
+    uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
+    uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;
+
+    /**
+     * @dev Executes a percentage multiplication
+     * @param value The value of which the percentage needs to be calculated
+     * @param percentage The percentage of the value to be calculated
+     * @return The percentage of value
+     **/
+    function percentMul(uint256 value, uint256 percentage)
+        internal
+        pure
+        returns (uint256)
+    {
+        if (value == 0 || percentage == 0) {
+            return 0;
+        }
+
+        require(
+            value <= (type(uint256).max) / percentage,
+            "MATH_MULTIPLICATION_OVERFLOW"
+        );
+
+        return (value * percentage) / PERCENTAGE_FACTOR;
+    }
+
+    /**
+     * @dev Executes a percentage division
+     * @param value The value of which the percentage needs to be calculated
+     * @param percentage The percentage of the value to be calculated
+     * @return The value divided the percentage
+     **/
+    function percentDiv(uint256 value, uint256 percentage)
+        internal
+        pure
+        returns (uint256)
+    {
+        require(percentage != 0, "MATH_DIVISION_BY_ZERO");
+
+        require(
+            value <= type(uint256).max / PERCENTAGE_FACTOR,
+            "MATH_MULTIPLICATION_OVERFLOW"
+        );
+
+        return (value * PERCENTAGE_FACTOR) / percentage;
+    }
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
+/**
+ * @title StakedToken
+ * @notice Contract to stake Aave token, tokenize the position and get rewards, inheriting from a distribution manager contract
+ * @author Aave
+ **/
+contract StakedTokenV3 is StakedTokenV2, IStakedTokenV3, RoleManager {
+  using SafeERC20 for IERC20;
+  using PercentageMath for uint256;
+
+  /// @notice Seconds available to redeem once the cooldown period is fullfilled
+  uint256 public constant SLASH_ADMIN_ROLE = 0;
+  uint256 public constant COOLDOWN_ADMIN_ROLE = 1;
+  uint256 public constant CLAIM_HELPER_ROLE = 2;
+  uint128 public constant INITIAL_EXCHANGE_RATE = 1e18;
+  uint256 public constant TOKEN_UNIT = 1e18;
+
+  // slashing states
+  uint256 internal _cooldownSeconds;
+  uint256 internal _maxSlashablePercentage;
+  bool public isPendingSlashing;
+  mapping(uint256 => Snapshot) public _exchangeRateSnapshots;
+  uint256 internal _exchangeRateSnapshotsCount;
+  uint128 internal _currentExchangeRate;
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
+    uint256 cooldownSeconds,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration,
+    string memory name,
+    string memory symbol,
+    address governance
+  )
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
+  function REVISION() public pure virtual override returns (uint256) {
+    return 4;
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
+   * @dev Inherited from StakedTokenV2, deprecated
+   * Overwrite `initialize` from `StakedTokenV2` so it can no longer be used to initialize
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
+    uint256 cooldownSeconds
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
+
+    // needed to claimRewardsAndStake works without a custom approval each time
+    STAKED_TOKEN.approve(address(this), type(uint256).max);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function previewStake(uint256 assets) public view returns (uint256) {
+    return (assets * _currentExchangeRate) / TOKEN_UNIT;
+  }
+
+  /// @inheritdoc IStakedToken
+  function stake(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
+  {
+    _stake(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
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
+    _stake(from, to, amount);
+  }
+
+  /// @inheritdoc IStakedToken
+  function redeem(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
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
+  /// @inheritdoc IStakedToken
+  function claimRewards(address to, uint256 amount)
+    external
+    override(IStakedToken, StakedTokenV2)
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
+  function claimRewardsAndStake(address to, uint256 amount)
+    external
+    override
+    returns (uint256)
+  {
+    return _claimRewardsAndStakeOnBehalf(msg.sender, to, amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function claimRewardsAndStakeOnBehalf(
+    address from,
+    address to,
+    uint256 amount
+  ) external override onlyClaimHelper returns (uint256) {
+    return _claimRewardsAndStakeOnBehalf(from, to, amount);
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
+  function getExchangeRate() public view override returns (uint128) {
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
+    return (TOKEN_UNIT * shares) / _currentExchangeRate;
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function slash(address destination, uint256 amount)
+    external
+    override
+    onlySlashingAdmin
+    returns (uint256)
+  {
+    require(!isPendingSlashing, 'PREVIOUS_SLASHING_NOT_SETTLED');
+    uint256 currentShares = totalSupply();
+    uint256 balance = previewRedeem(currentShares);
+
+    uint256 maxSlashable = balance.percentMul(_maxSlashablePercentage);
+
+    if (amount > maxSlashable) {
+      amount = maxSlashable;
+    }
+
+    isPendingSlashing = true;
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
+    uint256 currentShares = totalSupply();
+    uint256 assets = previewRedeem(currentShares);
+    _updateExchangeRate(_getExchangeRate(assets + amount, currentShares));
+
+    STAKED_TOKEN.safeTransferFrom(msg.sender, address(this), amount);
+    emit FundsReturned(amount);
+  }
+
+  /// @inheritdoc IStakedTokenV3
+  function settleSlashing() external override {
+    isPendingSlashing = false;
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
+  function _setCooldownSeconds(uint256 cooldownSeconds) internal {
+    _cooldownSeconds = cooldownSeconds;
+    emit CooldownSecondsChanged(cooldownSeconds);
+  }
+
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
+
+    stakerRewardsToClaim[from] = newTotalRewards - amountToClaim;
+    REWARD_TOKEN.safeTransferFrom(REWARDS_VAULT, to, amountToClaim);
+    emit RewardsClaimed(from, to, amountToClaim);
+    return amountToClaim;
+  }
+
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
+  function _stake(
+    address from,
+    address to,
+    uint256 amount
+  ) internal {
+    require(isPendingSlashing != true, 'SLASHING_ONGOING');
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
+    uint256 sharesToMint = previewStake(amount);
+    _mint(to, sharesToMint);
+
+    STAKED_TOKEN.safeTransferFrom(from, address(this), amount);
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
+      _cooldownSeconds -
+      UNSTAKE_WINDOW;
+
+    if (minimalValidCooldownTimestamp > toCooldownTimestamp) {
+      toCooldownTimestamp = 0;
+    } else {
+      uint256 adjustedFromCooldownTimestamp = (minimalValidCooldownTimestamp >
+        fromCooldownTimestamp)
+        ? block.timestamp
+        : fromCooldownTimestamp;
+
+      if (adjustedFromCooldownTimestamp < toCooldownTimestamp) {
+        return toCooldownTimestamp;
+      } else {
+        toCooldownTimestamp =
+          ((amountToReceive * adjustedFromCooldownTimestamp) +
+            (toBalance * toCooldownTimestamp)) /
+          (amountToReceive + toBalance);
+      }
+    }
+    return toCooldownTimestamp;
+  }
+
+  /**
+   * @dev Redeems staked tokens, and stop earning rewards
+   * @param from Address to redeem from
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
+
+    if (!isPendingSlashing) {
+      require(
+        (block.timestamp > cooldownStartTimestamp + _cooldownSeconds),
+        'INSUFFICIENT_COOLDOWN'
+      );
+      require(
+        (block.timestamp - (cooldownStartTimestamp + _cooldownSeconds) <=
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
+    uint256 underlyingToRedeem = (amountToRedeem * TOKEN_UNIT) /
+      _currentExchangeRate;
+
+    _burn(from, amountToRedeem);
+
+    if (balanceOfFrom - amountToRedeem == 0) {
+      stakersCooldowns[from] = 0;
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
+  function _updateExchangeRate(uint128 newExchangeRate) internal {
+    _exchangeRateSnapshots[_exchangeRateSnapshotsCount] = Snapshot(
+      uint128(block.number),
+      newExchangeRate
+    );
+    _exchangeRateSnapshotsCount += 1;
+    _currentExchangeRate = newExchangeRate;
+    emit ExchangeRateChanged(newExchangeRate);
+  }
+
+  /**
+   * @dev calculates the exchange rate based on totalAssets and totalShares
+   * @dev always rounds up to ensure 100% backing of shares by rounding in favor of the contract
+   * @param totalAssets The total amount of assets staked
+   * @param totalShares The total amount of shares
+   * @return exchangeRate as 18 decimal precision uint128
+   */
+  function _getExchangeRate(uint256 totalAssets, uint256 totalShares)
+    internal
+    pure
+    returns (uint128)
+  {
+    return uint128(((totalShares * TOKEN_UNIT) + TOKEN_UNIT) / totalAssets);
+  }
+
+  /**
+   * @dev searches a snapshot by block number. Uses binary search.
+   * @param blockNumber the block number being searched
+   * @return exchangeRate at block number
+   */
+  function _searchExchangeRateByBlockNumber(uint256 blockNumber)
+    internal
+    view
+    returns (uint256)
+  {
+    require(blockNumber <= block.number, 'INVALID_BLOCK_NUMBER');
+    uint256 snapshotsCount = _exchangeRateSnapshotsCount;
+
+    if (snapshotsCount == 0) {
+      return INITIAL_EXCHANGE_RATE;
+    }
+
+    // First check most recent balance
+    if (_exchangeRateSnapshots[snapshotsCount - 1].blockNumber <= blockNumber) {
+      return _exchangeRateSnapshots[snapshotsCount - 1].value;
+    }
+
+    uint256 lower = 0;
+    uint256 upper = snapshotsCount - 1;
+    while (upper > lower) {
+      uint256 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
+      Snapshot memory snapshot = _exchangeRateSnapshots[center];
+      if (snapshot.blockNumber == blockNumber) {
+        return snapshot.value;
+      } else if (snapshot.blockNumber < blockNumber) {
+        lower = center;
+      } else {
+        upper = center - 1;
+      }
+    }
+    return _exchangeRateSnapshots[lower].value;
+  }
+
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
+      ) * TOKEN_UNIT) / _searchExchangeRateByBlockNumber(blockNumber);
+  }
+}
+
+interface IGhoVariableDebtToken {
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
+  // GHO
+  IGhoVariableDebtToken public immutable GHO_DEBT_TOKEN;
+
+  constructor(
+    IERC20 stakedToken,
+    IERC20 rewardToken,
+    uint256 cooldownSeconds,
+    uint256 unstakeWindow,
+    address rewardsVault,
+    address emissionManager,
+    uint128 distributionDuration,
+    address governance,
+    address ghoDebtToken
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
+  {
+    GHO_DEBT_TOKEN = IGhoVariableDebtToken(ghoDebtToken);
+  }
+
+  /// @dev Modified version including GHO hook
+  /// @inheritdoc StakedTokenV2
+  function _beforeTokenTransfer(
+    address from,
+    address to,
+    uint256 amount
+  ) internal override {
+    if (Address.isContract(address(GHO_DEBT_TOKEN))) {
+      GHO_DEBT_TOKEN.updateDiscountDistribution(
+        from,
+        to,
+        balanceOf(from),
+        balanceOf(to),
+        amount
+      );
+    }
+
+    address votingFromDelegatee = _votingDelegates[from];
+    address votingToDelegatee = _votingDelegates[to];
+
+    if (votingFromDelegatee == address(0)) {
+      votingFromDelegatee = from;
+    }
+    if (votingToDelegatee == address(0)) {
+      votingToDelegatee = to;
+    }
+
+    _moveDelegatesByType(
+      votingFromDelegatee,
+      votingToDelegatee,
+      amount,
+      DelegationType.VOTING_POWER
+    );
+
+    address propPowerFromDelegatee = _propositionPowerDelegates[from];
+    address propPowerToDelegatee = _propositionPowerDelegates[to];
+
+    if (propPowerFromDelegatee == address(0)) {
+      propPowerFromDelegatee = from;
+    }
+    if (propPowerToDelegatee == address(0)) {
+      propPowerToDelegatee = to;
+    }
+
+    _moveDelegatesByType(
+      propPowerFromDelegatee,
+      propPowerToDelegatee,
+      amount,
+      DelegationType.PROPOSITION_POWER
+    );
+
+    // caching the aave governance address to avoid multiple state loads
+    ITransferHook aaveGovernance = _aaveGovernance;
+    if (address(aaveGovernance) != address(0)) {
+      aaveGovernance.onTransfer(from, to, amount);
+    }
+  }
+}
```
