#!/bin/bash
set -e
mkdir -p backup/

printf "\n\n*************************************\n"; 
printf "\n\nGetting list of user collections:\n"; 

HOST="${1}"
TOKEN="${2}"
URL="${HOST}/collections"
curl -k --location --request GET "${URL}" \
    --header "Authorization: Bearer ${TOKEN}" | \
    jq -r '.data | .[] | select(  (.collection | startswith("directus_") | not )) | .collection' > backup/collection_list.txt

if [ $? -eq 0 ]; then
    printf "...retrieved list of collections from: ${URL}\n"
    while read -r line; do
        COLLECTION="$line"
        printf "\n\n*************************************\n"; 
        printf "Fetching collection: ${COLLECTION}\n"

        URL="${HOST}/collections/${COLLECTION}"
        curl --location --request GET "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data' > backup/${COLLECTION}_collection.json
        if [ $? -eq 0 ]; then
            printf "...retrieved collection properties from: ${URL}\n"
        else
            printf "\n\nFAILED to get collection properties from: ${URL}\n $?\n\n";
            exit 1
        fi

        URL="${HOST}/fields/${COLLECTION}"
        curl --location --request GET "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | \
            jq -c 'if .schema.is_primary_key == true then del( .schema.is_unique ) else .  end' | jq -c 'del( .meta.id) | .' > backup/${COLLECTION}_fields.json
        if [ $? -eq 0 ]; then
            printf "...retrieved the collection's field definitions from: ${URL}\n"
        else
            printf "\n\nFAILED to get collection's field definitions from: ${URL}\n $?\n\n";
            exit 1
        fi

        URL="${HOST}/relations/${COLLECTION}"
        curl --location --request GET "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | jq -c 'del( .meta.id) | .' > backup/${COLLECTION}_relations.json
        if [ $? -eq 0 ]; then
            printf "...retrieved the collection's relationship definitions from: ${URL}\n"
        else
            printf "\n\nFAILED to get collection's relationship definitions from: ${URL}\n $?\n\n";
            exit 1
        fi

        URL="${HOST}/items/${COLLECTION}?limit=20000"
        curl --location --request GET "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | jq -c 'del( .user_created) | del( .user_updated) | del( .created_by) | del( .updated_by ) | .' > backup/${COLLECTION}_data.json
        if [ $? -eq 0 ]; then
            printf "...retrieved the collection's data from: ${URL}\n"
        else
            printf "\n\nFAILED to get collection's data from: ${URL}\n $?\n\n";
            exit 1
        fi

        cat backup/${COLLECTION}_collection.json | \
            jq -c --slurpfile fields backup/${COLLECTION}_fields.json '. + { fields: $fields }' >  backup/${COLLECTION}_schema.json
        if [ $? -eq 0 ]; then
            printf "...created the collection's full schema definition and stored it in: backup/${COLLECTION}_schema.json\n"
        else
            printf "\n\nFAILED to create the collection's full schema definition: $?\n\n";
            exit 1
        fi
    done < backup/collection_list.txt

    URL="${HOST}/utils/cache/clear"
    curl --location --request POST "${URL}" --header "Authorization: Bearer ${TOKEN}"
    printf "\n\nFinished!\n\n"; 
else
    printf "\n\nFAILED to get the list of user collections:$?\n\n"; 
fi
