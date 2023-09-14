#!/usr/bin/bash
sudo apt isntall jq curl
echo "{" > responses.json
API=$(jq -c '.api' requests.json | sed "s/\"//g")
counter=0
for payload in $(jq -c '.requests[]' requests.json)
do
	response=$(curl $API --silent --request POST --header "Content-Type: application/json" --data $payload)

	counter=$((counter+1))
	echo "\"A-$counter\":{" >> responses.json
	echo "\"JSON RPC payload\":$payload," >> responses.json
	echo "\"Response\":$response" >> responses.json
	echo "}" >> responses.json
	if [ $counter -lt $(jq '.requests | length' requests.json) ]
	then
		echo "," >> responses.json
	fi

	echo -n "JSON RPC payload: " && echo $payload | python3 -m json.tool
	echo -n "Response: " && echo $response | python3 -m json.tool
	echo "----------------------------------------------------------------------------------"
done
echo "}" >> responses.json
