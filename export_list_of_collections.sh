#!/bin/bash
set -e
HOST="${1}"
TOKEN="${2}"
URL="${HOST}/collections"

mkdir -p temp

printf "\n\n*************************************\n"; 
printf "\n\nGetting list of user collections:\n"; 

curl --location --request GET "${URL}" \
    --header "Authorization: Bearer ${TOKEN}" | \
    jq -r '.data | .[] | select(  (.collection | startswith("directus_") | not )) | .collection' > temp/collection_list.txt

if [ $? -eq 0 ]; then
    printf "\n\nDownloaded list of User collections from: ${URL}\nCollections list:\n\n"
    cat temp/collection_list.txt
    printf "\n\nFinished!\n\n"; 
else
    printf "\n\nFAILED to get the list of user collections:$?\n\n"; 
fi
