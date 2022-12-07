certoraRun src/contracts/gho/GhoToken.sol \
    --verify GhoToken:src/certora/specs/ERC20.spec \
    --solc solc8.7 \
    --staging \
    --optimistic_loop \
    --loop_iter 3 \
    --send_only \
    --msg "gho" 