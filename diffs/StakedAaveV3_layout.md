| Name                             | Type                                                                                   | Slot | Offset | Bytes | Contract                                    |
|----------------------------------|----------------------------------------------------------------------------------------|------|--------|-------|---------------------------------------------|
| _balances                        | mapping(address => uint256)                                                            | 0    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _allowances                      | mapping(address => mapping(address => uint256))                                        | 1    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _totalSupply                     | uint256                                                                                | 2    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _name                            | string                                                                                 | 3    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _symbol                          | string                                                                                 | 4    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _decimals                        | uint8                                                                                  | 5    | 0      | 1     | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _votingSnapshots                 | mapping(address => mapping(uint256 => struct GovernancePowerDelegationERC20.Snapshot)) | 6    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _votingSnapshotsCounts           | mapping(address => uint256)                                                            | 7    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _aaveGovernance                  | contract ITransferHook                                                                 | 8    | 0      | 20    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| lastInitializedRevision          | uint256                                                                                | 9    | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| ______gap                        | uint256[50]                                                                            | 10   | 0      | 1600  | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| assets                           | mapping(address => struct AaveDistributionManager.AssetData)                           | 60   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| stakerRewardsToClaim             | mapping(address => uint256)                                                            | 61   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| stakersCooldowns                 | mapping(address => struct IStakedTokenV2.CooldownSnapshot)                             | 62   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _votingDelegates                 | mapping(address => address)                                                            | 63   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _propositionPowerSnapshots       | mapping(address => mapping(uint256 => struct GovernancePowerDelegationERC20.Snapshot)) | 64   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _propositionPowerSnapshotsCounts | mapping(address => uint256)                                                            | 65   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _propositionPowerDelegates       | mapping(address => address)                                                            | 66   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| DOMAIN_SEPARATOR                 | bytes32                                                                                | 67   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _nonces                          | mapping(address => uint256)                                                            | 68   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _admins                          | mapping(uint256 => address)                                                            | 69   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _pendingAdmins                   | mapping(uint256 => address)                                                            | 70   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _cooldownSeconds                 | uint256                                                                                | 71   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _maxSlashablePercentage          | uint256                                                                                | 72   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _currentExchangeRate             | uint216                                                                                | 73   | 0      | 27    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| inPostSlashingPeriod             | bool                                                                                   | 73   | 27     | 1     | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _exchangeRateSnapshotsCount      | uint32                                                                                 | 73   | 28     | 4     | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| _exchangeRateSnapshots           | mapping(uint256 => struct IStakedAaveV3.ExchangeRateSnapshot)                          | 74   | 0      | 32    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
| ghoDebtToken                     | contract IGhoVariableDebtTokenTransferHook                                             | 75   | 0      | 20    | src/contracts/StakedAaveV3.sol:StakedAaveV3 |
