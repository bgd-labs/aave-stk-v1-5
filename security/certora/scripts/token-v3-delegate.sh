if [[ "$1" ]]
then
    RULE="--rule $1"
fi

echo "RULE is ==>" $RULE "<=="

certoraRun --send_only --server production --prover_version master \
           certora/conf/token-v3-delegate.conf $RULE --msg "$1:: $2"




