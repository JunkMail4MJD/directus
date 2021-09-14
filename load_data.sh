#!/bin/bash
set -e
HOST="${1}"
TOKEN="${2}"
COLLECTION="${3}"

# POST "/items/":collection
printf "\n\n*************************************\n"; 
printf "\n\nCreating items for: ${COLLECTION}\n"; 
FILENAME="temp/${COLLECTION}_data.json"
URL="${HOST}/items/${COLLECTION}"
while read -r line; do
    record="$line"
    printf "\n\nRead item from file: ${FILENAME}\n\n"
    curl --location --request POST "${URL}" \
        --header "Authorization: Bearer ${TOKEN}" \
        --header 'Content-Type: application/json' \
        --data-raw "${record}"
        if [ $? -eq 0 ]; then
            printf "\n\n...Added record to collection: ${COLLECTION} at: ${URL}\n"
        else
            printf "\n\nFAILED to add record to collection: ${COLLECTION} at: ${URL}\n $?\n\n";
            exit 1
        fi
done < "$FILENAME"
printf "\n\n...finished loading data.\n"; 
