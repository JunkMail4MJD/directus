#!/bin/bash
TOKEN="${DIRECTUS_TOKEN}"
PROTOCOL="http"
HOST="localhost:8055"
PATH_ELEMENT="/collections"
URL="${PROTOCOL}://${HOST}${PATH_ELEMENT}"

mkdir -p backup/

printf "\n\n*************************************\n"; 
printf "\n\nGetting list of user collections:\n"; 

curl --location --request GET "${URL}" \
--header "Authorization: Bearer ${TOKEN}" | \
jq -r '.data | .[] | select(  (.collection | startswith("directus_") | not )) | .collection' > collection_list.txt

if [ $? -eq 0 ]; then
    echo OK
    echo ${URL}
    while read -r line; do
        RECORD="$line"
        printf "\nRead line from file: ${RECORD}\n"
    done < collection_list.txt
    printf "\n\nFinished!\n\n"; 
else
    printf "\n\nFAILED to get the list of user collections:$?\n\n"; 
fi
