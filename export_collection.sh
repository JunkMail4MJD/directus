#!/bin/bash
COLLECTION="${1}"
TOKEN="${DIRECTUS_TOKEN}"
curl --location --request GET "http://localhost:8055/collections/${COLLECTION}" \
--header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data' > ${COLLECTION}_collection.json

curl --location --request GET "http://localhost:8055/fields/${COLLECTION}" \
--header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' | \
jq -c 'if .schema.is_primary_key == true then del( .schema.is_unique ) else .  end' > ${COLLECTION}_fields.json

curl --location --request GET "http://localhost:8055/relations/${COLLECTION}" \
--header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' > ${COLLECTION}_relations.json

curl --location --request GET "http://localhost:8055/items/${COLLECTION}" \
--header "Authorization: Bearer ${TOKEN}" | jq -cs '.[] | .data | .[]' > ${COLLECTION}_data.json

cat ${COLLECTION}_collection.json | jq -c --slurpfile fields ${COLLECTION}_fields.json '. + { fields: $fields }' > ${COLLECTION}_schema.json
