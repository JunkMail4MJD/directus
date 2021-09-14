#!/bin/bash
set -e

printf "\n\n*************************************\n"; 
printf "\nClearing Directus Cache:\n"; 
printf "\n*************************************\n\n"; 

HOST="${1}"
TOKEN="${2}"

URL="${HOST}/utils/cache/clear"
curl --location --request POST "${URL}" --header "Authorization: Bearer ${TOKEN}"
