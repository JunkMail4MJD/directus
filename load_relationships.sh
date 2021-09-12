#!/bin/bash
PROTOCOL="http"
HOST="localhost:8055"
TOKEN="${DIRECTUS_TOKEN}"
COLLECTIONS=("country" "state" "city" "pages")

# POST "/relations"
printf "\n\n*************************************\n"; 
printf "\n\nCreating relations:\n"; 
for COLLECTION in "${COLLECTIONS[@]}"; do 
    printf "\n\n...defining relations for: ${COLLECTION}\n"; 
    FILENAME="${COLLECTION}_relations.json"
    PATH_ELEMENT="/relations"
    URL="${PROTOCOL}://${HOST}${PATH_ELEMENT}"
    while read -r line; do
        record="$line"
        printf "\n\nRecord read from file: ${FILENAME}\n\n"
        curl --location --request POST "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" \
            --header 'Content-Type: application/json' \
            --data-raw "${record}"
    done < "$FILENAME"
done
printf "\n\n...finished defining relations.\n"; 
