#! /bin/bash
TMPFILE=$(mktemp)
LINK="https://httpstat.us"

unset HTTP_PROXY http_proxy HTTPS_PROXY https_proxy

if [ "$1" == "auto" ] 
then # Выполнить 5 запросов к разным случайным кодам
	ALLCODES=( $(curl -s -A "Mozilla/5.0" $LINK/ | grep -E -o '[1-5][0-9][0-9]' | sort -u) )
	echo "Codes in list: ${#ALLCODES[@]}"
	if [ ${#ALLCODES[@]} -eq 0 ] 
	then
		echo "Swap to the planB"
		ALLCODES=(100 101 102 103 200 201 202 300 301 400 401 402 404 500 501 502)
	fi
	CODELIST=( $(shuf -n 5 -e "${ALLCODES[@]}") )
else # Выполнить запросы к указанным кодам
	read -p "Enter codes: " -a  CODELIST
fi

# А теперь опрашиваем
for CODE in "${CODELIST[@]}" 
do
	FULLPATH="$LINK/$CODE"
	echo "Trying URL: $FULLPATH"
	STATUS=$(curl -A "Mozilla/5.0" -o $TMPFILE -s -w "%{http_code}"  $FULLPATH)
	if [[ "$STATUS" -ge 400 || "$STATUS" -eq 0 ]] 
	then
		echo "EXCEPTION: recieved status $STATUS ($(cat $TMPFILE))" >&2
	else
		echo "$STATUS: $(cat $TMPFILE)	$(date +%d.%m.%y-%H:%M:%S)"
	fi
done
rm "$TMPFILE"
