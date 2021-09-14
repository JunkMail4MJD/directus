# Using Directus - an Open Source CMS with both REST and GraphQL endpoints

Directus is a content management system that supports configurable WYSIWYG editing, any SQL database, users, permissions, workflow and a graphQL API

Just clone the repository and run `docker-compose up -d`

## Using the Utility Scripts

### Prerequisites

* [Install JQ](https://stedolan.github.io/jq/download/) locally
* I use a mac so. `brew install jq`
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

### Scripts

