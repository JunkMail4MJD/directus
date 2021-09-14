#!/bin/bash
set -e
HOST="${1}"
TOKEN="${2}"
COLLECTION="${3}"

printf "\n\n*************************************\n"; 
printf "\nDeleting Directus Collection: ${COLLECTION} on host: ${HOST}\n"; 
printf "\n*************************************\n\n"; 

URL="${HOST}/collections/${COLLECTION}"
curl --location --request DELETE "${URL}" --header "Authorization: Bearer ${TOKEN}"

