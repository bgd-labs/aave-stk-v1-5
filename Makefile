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
	make download chain=mainnet address=0x7183143a9e223a12a83d1e28c98f7d01a68993e8
	make download chain=mainnet address=0xE2E8Badc5d50f8a6188577B89f50701cDE2D4e19
	forge flatten src/contracts/StakedAaveV3.sol --output src/flattened/StakedAaveV3Flattened.sol
	forge flatten src/contracts/StakedTokenV3.sol --output src/flattened/StakedTokenV3Flattened.sol
	npm run lint:fix
	make git-diff before=src/etherscan/mainnet_0x7183143a9e223a12a83d1e28c98f7d01a68993e8/StakedTokenBptRev2/Contract.sol after=src/flattened/StakedTokenV3Flattened.sol out=StakedTokenBptRev2_code_diff
	make git-diff before=src/etherscan/mainnet_0xE2E8Badc5d50f8a6188577B89f50701cDE2D4e19/StakedTokenV2Rev4/src/contracts/StakedTokenV2Rev4.sol after=src/flattened/StakedAaveV3Flattened.sol out=StakedTokenV2Rev4_code_diff
	forge inspect StakedTokenV2Rev4 storage-layout --pretty > diffs/StakedTokenV2Rev4_layout.md
	forge inspect StakedTokenBptRev2 storage-layout --pretty > diffs/StakedTokenBptRev2_layout.md
	forge inspect StakedAaveV3 storage-layout --pretty > diffs/StakedAaveV3_layout.md
	forge inspect StakedTokenV3 storage-layout --pretty > diffs/StakedTokenV3_layout.md

interface :
	cast interface --name AggregatedStakedAaveV3 -o ./src/interfaces/AggregatedStakedAaveV3.sol ./out/StakedAaveV3.sol/StakedAaveV3.json
	cast interface --name AggregatedStakedTokenV3 -o ./src/interfaces/AggregatedStakedTokenV3.sol ./out/StakedTokenV3.sol/StakedTokenV3.json
