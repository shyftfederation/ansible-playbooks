#!/bin/bash
WHERE=$1
if [ "$WHERE" == "" ]; then
	WHERE='wss://stats.shyft.network/primus/'
fi

echo '['
wscat -x '{"emit":["ready"]}' --connect $WHERE | grep enode | jq '.emit[1].nodes' | grep -oP '\"enode://.*?\"'  | sed '$!s/$/,/' 
echo ']'
