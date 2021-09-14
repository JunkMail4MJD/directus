#!/bin/bash
set -e

printf "\n\n*************************************\n"; 
printf "\n\nGetting list of user collections:\n"; 

HOST="${1}"
TOKEN="${2}"
URL="${HOST}/collections"

# POST "/collections"
printf "\n\n*************************************\n"; 
printf "Restoring user collections to: ${HOST}\n"
while read -r line; do
    COLLECTION="$line"
    printf "Read line from config file: ${COLLECTION}\n"

    FILENAME="backup/${COLLECTION}_schema.json"
    URL="${HOST}/collections"
    while read -r line; do
        record="$line"
        printf "\n\nSchema read from file: ${FILENAME}\n\n"

        curl --location --request POST "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" \
            --header 'Content-Type: application/json' \
            --data-raw "${record}"

        if [ $? -eq 0 ]; then
            printf "\n\n...created user collection: ${COLLECTION} at: ${URL}\n"
        else
            printf "\n\nFAILED to create user collection: ${COLLECTION} at: ${URL}\n $?\n\n";
            exit 1
        fi
    done < "$FILENAME"
done < backup/collection_list.txt
printf "\n\nFinished creating collection schemas!\n\n"; 

# POST "/relations"
printf "\n\n*************************************\n"; 
printf "Restoring collection relationships to: ${HOST}\n"
while read -r line; do
    COLLECTION="$line"
    printf "Read line from config file: ${COLLECTION}\n"

    FILENAME="backup/${COLLECTION}_relations.json"
    URL="${HOST}/relations"
    while read -r line; do
        record="$line"
        printf "\n\nRead relationship from file: ${FILENAME}\n\n"

        curl --location --request POST "${URL}" \
            --header "Authorization: Bearer ${TOKEN}" \
            --header 'Content-Type: application/json' \
            --data-raw "${record}"

        if [ $? -eq 0 ]; then
            printf "\n\n...created collection relationships for ${COLLECTION} at: ${URL}\n"
        else
            printf "\n\nFAILED to create collection relationships for ${COLLECTION} at: ${URL}\n $?\n\n";
            exit 1
        fi
    done < "$FILENAME"
done < backup/collection_list.txt
printf "\n\nFinished creating collection relationships!\n\n"; 

# POST "/items/":collection
printf "\n\n*************************************\n"; 
printf "Restoring collection data to: ${HOST}\n"
while read -r line; do
    COLLECTION="$line"
    printf "Read line from config file: ${COLLECTION}\n"

    FILENAME="backup/${COLLECTION}_data.json"
    URL="${HOST}/items/${COLLECTION}"
    while read -r line; do
        record="$line"
        printf "\n\nRead record from file: ${FILENAME}\n\n"

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
done < backup/collection_list.txt
printf "\n\nFinished restoring data!\n\n"; 
printf "\n\n*************************************\n"; 

URL="${HOST}/utils/cache/clear"
curl --location --request POST "${URL}" --header "Authorization: Bearer ${TOKEN}"

printf "\n\nFinished !!!!!\n\n"; 
printf "\n\n*************************************\n"; 
