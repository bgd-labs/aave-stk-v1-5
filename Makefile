# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes
test   :; forge test -vvv

# Utilities
download :; cast etherscan-source --chain ${chain} -d src/etherscan/${chain}_${address} ${address}
git-diff :
	@mkdir -p diffs
	@printf '%s\n%s\n%s\n' "\`\`\`diff" "$$(git diff --no-index --diff-algorithm=patience --ignore-space-at-eol ${before} ${after})" "\`\`\`" > diffs/${out}.md



diff-all :
	make download chain=mainnet address=0xAa9FAa887bce5182C39F68Ac46C43F36723C395b
	make download chain=mainnet address=0x9921c8cea5815364d0f8350e6cbe9042A92448c9
	forge flatten src/contracts/StakedAaveV3.sol --output src/flattened/StakedAaveV3Flattened.sol
	forge flatten src/etherscan/mainnet_0xAa9FAa887bce5182C39F68Ac46C43F36723C395b/StakedAaveV3/src/contracts/StakedAaveV3.sol --output src/flattened/CurrentStakedAaveV3Flattened.sol
	forge flatten src/contracts/StakedTokenV3.sol --output src/flattened/StakedTokenV3Flattened.sol
	forge flatten src/etherscan/mainnet_0x9921c8cea5815364d0f8350e6cbe9042A92448c9/StakedTokenV3/src/contracts/StakedTokenV3.sol --output src/flattened/CurrentStakedTokenV3Flattened.sol
	npm run lint:fix
	make git-diff before=src/flattened/CurrentStakedTokenV3Flattened.sol after=src/flattened/StakedTokenV3Flattened.sol out=StakedTokenDidd
	make git-diff before=src/flattened/CurrentStakedAaveV3Flattened.sol after=src/flattened/StakedAaveV3Flattened.sol out=StakedAaveDiff
	forge inspect src/flattened/CurrentStakedAaveV3Flattened.sol:StakedAaveV3 storage-layout --pretty > diffs/currentStakedAave.md
	sed -i '' -E 's/(.*)\|[^|]*\s*\|/\1|/' diffs/currentStakedAave.md

	forge inspect src/flattened/CurrentStakedTokenV3Flattened.sol:StakedTokenV3 storage-layout --pretty > diffs/currentStakedToken.md
	sed -i '' -E 's/(.*)\|[^|]*\s*\|/\1|/' diffs/currentStakedToken.md
	forge inspect src/flattened/StakedAaveV3Flattened.sol:StakedAaveV3 storage-layout --pretty > diffs/nextStakedAave.md
	sed -i '' -E 's/(.*)\|[^|]*\s*\|/\1|/' diffs/nextStakedAave.md
	forge inspect src/flattened/StakedTokenV3Flattened.sol:StakedTokenV3 storage-layout --pretty > diffs/nextStakedToken.md
	sed -i '' -E 's/(.*)\|[^|]*\s*\|/\1|/' diffs/nextStakedToken.md
	make git-diff before=diffs/currentStakedAave.md after=diffs/nextStakedAave.md out=StakedAave_layoutDiff

interface :
	cast interface --name AggregatedStakedAaveV3 -o ./src/interfaces/AggregatedStakedAaveV3.sol ./out/StakedAaveV3.sol/StakedAaveV3.json
	cast interface --name AggregatedStakedTokenV3 -o ./src/interfaces/AggregatedStakedTokenV3.sol ./out/StakedTokenV3.sol/StakedTokenV3.json



deploy-payloads :;  forge script scripts/DeployPayload.s.sol:DeployPayloads --rpc-url mainnet --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
create-stkabpt-proposal :; forge script scripts/CreateProposal.s.sol:CreateStkABPTShortProposal --rpc-url mainnet --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} -vvvv
create-stkaave-proposal :; forge script scripts/CreateProposal.s.sol:CreateStkAAVELongProposal --rpc-url mainnet --broadcast --legacy --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} -vvvv
