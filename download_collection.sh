#!/bin/bash
set -e
HOST="${1}"
TOKEN="${2}"
COLLECTION="${3}"

mkdir -p temp

curl --location --request GET "${HOST}/collections/${COLLECTION}" \
    --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data' > temp/${COLLECTION}_collection.json
if [ $? -eq 0 ]; then
    printf "...retrieved collection properties from: ${URL}\n"
else
    printf "\n\nFAILED to get collection properties from: ${URL}\n $?\n\n";
    exit 1
fi

curl --location --request GET "${HOST}/fields/${COLLECTION}" \
    --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | \
    jq -c 'if .schema.is_primary_key == true then del( .schema.is_unique ) else .  end' | jq -c 'del( .meta.id) | .' > temp/${COLLECTION}_fields.json
if [ $? -eq 0 ]; then
    printf "...retrieved the collection's field definitions from: ${URL}\n"
else
    printf "\n\nFAILED to get collection's field definitions from: ${URL}\n $?\n\n";
    exit 1
fi

curl --location --request GET "${HOST}/relations/${COLLECTION}" \
    --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | jq -c 'del( .meta.id) | .' > temp/${COLLECTION}_relations.json
if [ $? -eq 0 ]; then
    printf "...retrieved the collection's relationship definitions from: ${URL}\n"
else
    printf "\n\nFAILED to get collection's relationship definitions from: ${URL}\n $?\n\n";
    exit 1
fi

curl --location --request GET "${HOST}/items/${COLLECTION}" \
    --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | jq -c 'del( .user_created) | del( .user_updated) | del( .created_by) | del( .updated_by ) | .' > temp/${COLLECTION}_data.json
if [ $? -eq 0 ]; then
    printf "...retrieved the collection's data from: ${URL}\n"
else
    printf "\n\nFAILED to get collection's data from: ${URL}\n $?\n\n";
    exit 1
fi

cat temp/${COLLECTION}_collection.json | jq -c --slurpfile fields temp/${COLLECTION}_fields.json '. + { fields: $fields }' > temp/${COLLECTION}_schema.json
if [ $? -eq 0 ]; then
    printf "...created the collection's full schema definition and stored it in: temp/${COLLECTION}_schema.json\n"
else
    printf "\n\nFAILED to create the collection's full schema definition: $?\n\n";
    exit 1
fi
