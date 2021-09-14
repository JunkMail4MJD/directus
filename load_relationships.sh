#!/bin/bash
set -e
HOST="${1}"
TOKEN="${2}"
COLLECTION="${3}"

URL="${HOST}/collections"

# POST "/relations"
printf "\n\n*************************************\n"; 
printf "\n\nCreating relationships for: ${COLLECTION}\n"; 
FILENAME="temp/${COLLECTION}_relations.json"
URL="${HOST}/relations"
while read -r line; do
    record="$line"
    printf "\n\nRead relationship from file: ${FILENAME}\n\n"
    curl --location --request POST "${URL}" \
        --header "Authorization: Bearer ${TOKEN}" \
        --header 'Content-Type: application/json' \
        --data-raw "${record}"
    if [ $? -eq 0 ]; then
        printf "\n\n...created relationship for ${COLLECTION} at: ${URL}\n"
    else
        printf "\n\nFAILED to create relationship for ${COLLECTION} at: ${URL}\n $?\n\n";
        exit 1
    fi
done < "$FILENAME"

printf "\n\n...finished defining relations.\n"; 
