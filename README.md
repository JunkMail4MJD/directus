# Using Directus - an Open Source CMS with both REST and GraphQL endpoints

Directus is a content management system that supports configurable WYSIWYG editing, any SQL database, users, permissions, workflow and a graphQL API

Just clone the repository and run `docker-compose up -d`

## Prerequisites

* [Install JQ](https://stedolan.github.io/jq/download/) locally
* I use a mac so: `brew install jq`
* jq is used to filter the raw results from the Directus APIs to exclude things that will cause errors when moving data from one environment to another. Examples:
  * Removes row IDs from the Directus internal tables that will be different in a different database. Once omitted Directus will create new ones consistent with that environment's database
  * Removes User IDs (GUIDs) - when tracking the user that created or last updated an item, these GUIDs will be different in different databases
  * Removes the `is_unique` attribute on primary key fields. This causes errors in the Directus UI if a unique constraint is added the primary key column.
  * Adds in the fields array to the collection's schema. If the primary key isn't added when you create the collection then it will default to an auto incrementing number.
  * If you are exporting and restoring to the same database you can add a flag to the bash scripts to leave the user id fields in if you like. The row IDs still won't be needed.

### Authentication
* Follow the [Directus Authentication](https://docs.directus.io/reference/api/system/authentication/) Documentation for getting tokens for the Directus REST API
* Enter your URLS and Tokens in the source_me.sh file
* Source the file by typing `source source_me.sh`


## Using the Utility Scripts

### Clear Cache

* **Description**: This clears the Directus cache. This is useful after changing the content model. 
* **Usage**: `./clear_cache.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN}`

### Delete Collection

* **Description**: This <u>**deletes**</u> a Directus collection.
* **Usage**: `./delete_collection.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN} <COLLECTION_NAME>`

### Download Collection

* **Description**: This downloads a **single** Directus collection to a temp directory. It downloads the full definition of a collection and the first 20,000 items in the collection.
* **Usage**: `./delete_collection.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN} <COLLECTION_NAME>`

### Export User Collections

* **Description**: This downloads **ALL USER generated** Directus collections to the backup directory. It downloads the full definition of each collection and the first 20,000 items in the collection.
* **Usage**: `./export_user_collections.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN}`

### List User Collections

* **Description**: This lists ALL USER generated Directus collections.
* **Usage**: `./list_user_collections.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN}`

### Load Relationships

* **Description**: This loads the relationships for the specified Directus collection from the temp directory.
* **Usage**: `./load_relationships.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN} <COLLECTION_NAME>`

### Restore User Collections 

* **Description**: This uploads **ALL USER generated** Directus collections from the backup directory. It downloads the full definition of each collection and the items in the collection.
* **Usage**: `./restore_collections_backup.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN}`

### Upload Items Only 

* **Description**: This uploads **just the items** for one Directus collection from the temp directory.
* **Usage**: `./upload_items_only.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN} <COLLECTION_NAME>`

### Upload One Collection

* **Description**: This uploads a **single** Directus collection from a temp directory. It uploads the full definition of a collection and items in the collection.
* **Usage**: `./upload_one_collection.sh ${DIRECTUS_LOCALHOST} ${DIRECTUS_LOCALHOST_TOKEN} <COLLECTION_NAME>`
