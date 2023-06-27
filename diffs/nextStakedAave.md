| Name                                | Type                                                                                   | Slot | Offset | Bytes |
|-------------------------------------|----------------------------------------------------------------------------------------|------|--------|-------|
| _balances                           | mapping(address => struct BaseAaveToken.DelegationAwareBalance)                        | 0    | 0      | 32    |
| _allowances                         | mapping(address => mapping(address => uint256))                                        | 1    | 0      | 32    |
| _totalSupply                        | uint256                                                                                | 2    | 0      | 32    |
| _name                               | string                                                                                 | 3    | 0      | 32    |
| _symbol                             | string                                                                                 | 4    | 0      | 32    |
| ______DEPRECATED_OLD_ERC20_DECIMALS | uint8                                                                                  | 5    | 0      | 1     |
| __________DEPRECATED_GOV_V2_PART    | uint256[3]                                                                             | 6    | 0      | 96    |
| lastInitializedRevision             | uint256                                                                                | 9    | 0      | 32    |
| ______gap                           | uint256[50]                                                                            | 10   | 0      | 1600  |
| assets                              | mapping(address => struct AaveDistributionManager.AssetData)                           | 60   | 0      | 32    |
| stakerRewardsToClaim                | mapping(address => uint256)                                                            | 61   | 0      | 32    |
| stakersCooldowns                    | mapping(address => struct IStakedTokenV2.CooldownSnapshot)                             | 62   | 0      | 32    |
| ______DEPRECATED_FROM_STK_AAVE_V2   | uint256[5]                                                                             | 63   | 0      | 160   |
| _nonces                             | mapping(address => uint256)                                                            | 68   | 0      | 32    |
| _admins                             | mapping(uint256 => address)                                                            | 69   | 0      | 32    |
| _pendingAdmins                      | mapping(uint256 => address)                                                            | 70   | 0      | 32    |
| _votingDelegatee                    | mapping(address => address)                                                            | 71   | 0      | 32    |
| _propositionDelegatee               | mapping(address => address)                                                            | 72   | 0      | 32    |
| ______gap                           | uint256[6]                                                                             | 73   | 0      | 192   |
| _cooldownSeconds                    | uint256                                                                                | 79   | 0      | 32    |
| _maxSlashablePercentage             | uint256                                                                                | 80   | 0      | 32    |
| _currentExchangeRate                | uint216                                                                                | 81   | 0      | 27    |
| inPostSlashingPeriod                | bool                                                                                   | 81   | 27     | 1     |
| ______DEPRECATED_FROM_STK_AAVE_V3   | uint256[1]                                                                             | 82   | 0      | 32    |
| ghoDebtToken                        | contract IGhoVariableDebtTokenTransferHook                                             | 83   | 0      | 20    |
