#! /bin/bash
touch tmpBody
CODELIST=(200 201 301 404 500)

for CODE in "${CODELIST[@]}" 
do
	STATUS=$(curl -o tmpBody -s -w "%{http_code}"  https://httpbin.org/status/$CODE)
	echo "Trying URL: https://httpbin.org/status/$CODE"
	if [ "$STATUS" -ge 400 ] 
	then
		echo "Exception: recieved status $STATUS" >&2
	else
		echo "$STATUS: $(cat tmpBody)	$(date +%y.%m.%d-%H:%M:%S)"
	fi
done
rm tmpBody
