

certoraRun certora/conf/propertiesWithSummarization.conf --send_only --rule allSharesAreBacked

certoraRun certora/conf/invariants.conf --send_only --rule cooldownDataCorrectness --rule cooldownAmountNotGreaterThanBalance --rule lowerBoundNotZero --rule balanceOfZero --rule totalSupplyGreaterThanUserBalance --rule PersonalIndexLessOrEqualGlobalIndex

certoraRun certora/conf/allProps.conf --send_only \
           --rule integrityOfStaking \
           --rule previewStakeEquivalentStake \
           --rule noStakingPostSlashingPeriod \
           --rule cooldownCorrectness \
           --rule integrityOfRedeem \
           --rule noRedeemOutOfUnstakeWindow \
           --rule integrityOfSlashing \
           --rule noSlashingMoreThanMax \
           --rule noEntryUntilSlashingSettled \
           --rule slashingIncreaseExchangeRate \
           --rule slashAndReturnFundsOfZeroDoesntChangeExchangeRate \
           --rule integrityOfReturnFunds \
           --rule returnFundsDecreaseExchangeRate \
           --rule rewardsGetterEquivalentClaim \
           --rule rewardsMonotonicallyIncrease \
           --rule rewardsIncreaseForNonClaimFunctions \
           --rule totalSupplyDoesNotDropToZero \
           --rule exchangeRateNeverZero \
           --rule airdropNotMutualized \
           --rule indexesMonotonicallyIncrease

certoraRun certora/conf/token-v3-delegate.conf --send_only

certoraRun certora/conf/token-v3-general.conf --send_only --rule delegateCorrectness
certoraRun certora/conf/token-v3-general.conf --send_only --rule sumOfVBalancesCorrectness
certoraRun certora/conf/token-v3-general.conf --send_only --rule sumOfPBalancesCorrectness
certoraRun certora/conf/token-v3-general.conf --send_only --rule transferDoesntChangeDelegationMode

certoraRun certora/conf/token-v3-erc20.conf --send_only

certoraRun certora/conf/token-v3-community.conf --send_only



