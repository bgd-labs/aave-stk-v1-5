if [[ "$1" ]]
then
    RULE="--rule $1"
fi

echo "RULE is ==>" $RULE "<=="

certoraRun --send_only \
           certora/conf/token-v3-community.conf $RULE --msg "$1:: $2" 
           

#           --method "slash(address,uint256)" \



