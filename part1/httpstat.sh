#! /bin/bash
TMPFILE=$(mktemp)

set -u

if [ "$1" == "auto" ] 
# Выполнить 5 запросов (по 1 на класс)
then
	CODES2XX=(200 201 202 203 204 205 206 207 208 226)
	RAND2XX=${CODES2XX[$RANDOM % ${#CODES2XX[@]}]}
	CODES4XX=(400 401 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 421 422 423 424 426 428 431 451) 
	RAND4XX=${CODES4XX[$RANDOM % ${#CODES4XX[@]}]}
	CODES5XX=(500 501 502 503 504 505 506 507 508 510 511)
	RAND5XX=${CODES5XX[$RANDOM % ${#CODES5XX[@]}]}
	CODELIST=($((100+$RANDOM % 4)) $RAND2XX $((300+$RANDOM % 9)) $RAND4XX $RAND5XX)
# Выполнить запросы к указанным кодам
else
	read -p "Введите коды: " -a  CODELIST
fi

LINK="https://httpbin.org/status"

for CODE in "${CODELIST[@]}" 
do
	echo "Trying URL: $LINK/$CODE"
	STATUS=$(curl -o $TMPFILE -s -w "%{http_code}"  $LINK/$CODE)
	if [ "$STATUS" -ge 400 ] 
	then
		echo "EXCEPTION: recieved status $STATUS ($(cat $TMPFILE))" >&2
	else
		echo "$STATUS: $(cat $TMPFILE)	$(date +%d.%m.%y-%H:%M:%S)"
	fi
done
rm "$TMPFILE"
