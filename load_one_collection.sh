#!/bin/bash
PROTOCOL="http"
HOST="localhost:8055"
TOKEN="${DIRECTUS_TOKEN}"
COLLECTION="${1}"

# POST "/collections"
printf "\n\n*************************************\n"; 
printf "\n\nCreating collection:\n"; 
printf "\n\n...defining collection for: ${COLLECTION}\n"; 
FILENAME="${COLLECTION}_schema.json"
PATH_ELEMENT="/collections"
URL="${PROTOCOL}://${HOST}${PATH_ELEMENT}"
while read -r line; do
    record="$line"
    printf "\n\nRecord read from file: ${FILENAME}\n\n"

    curl --location --request POST "${URL}" \
        --header "Authorization: Bearer ${TOKEN}" \
        --header 'Content-Type: application/json' \
        --data-raw "${record}"
done < "$FILENAME"
printf "\n\n...finished defining collections.\n"; 

# POST "/relations"
printf "\n\n*************************************\n"; 
printf "\n\nCreating relations:\n"; 
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
printf "\n\n...finished defining relations.\n"; 

# POST "/items/":collection
printf "\n\n*************************************\n"; 
printf "\n\nCreating items:\n"; 
printf "\n\n...creating items for: ${COLLECTION}\n"; 
FILENAME="${COLLECTION}_data.json"
PATH_ELEMENT="/items/${COLLECTION}"
URL="${PROTOCOL}://${HOST}${PATH_ELEMENT}"
while read -r line; do
    record="$line"
    printf "\n\nRecord read from file: ${FILENAME}\n\n"
    curl --location --request POST "${URL}" \
        --header "Authorization: Bearer ${TOKEN}" \
        --header 'Content-Type: application/json' \
        --data-raw "${record}"
done < "$FILENAME"
printf "\n\n...finished loading data.\n"; 
