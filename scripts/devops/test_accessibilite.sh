#!/bin/bash
# Test acces site fournie en parametre avec timeout de 2 minutes
runtime="3 minute"
endtime=$(date -ud "$runtime" +%s)
response=$(curl --write-out '%{http_code}' --silent --output /dev/null $1)
echo "Test accessibilité url '$1' ..."
#$SECONDS
while [ $response -gt 200 ]
do
    if [[ $(date -u +%s) -ge $endtime ]]
    then
        echo "Timeout test accessibilité url '$1' après $SECONDS secondes!"
        exit -1
    fi
    sleep 10
    echo "Resultat temporaire test accessibilité url '$1' depuis $SECONDS secondes:"
    curl -X HEAD -I $1
    response=$(curl --write-out '%{http_code}' --silent --output /dev/null $1)
done
echo "Resultat final test accessibilité url '$1' après $SECONDS secondes:"
curl -X GET -I $1