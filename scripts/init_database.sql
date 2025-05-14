/*
===============================
Create Database and Schemas
===============================
Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'DataWarehouse' database if it already exists.
	All data in the database will be permanently deleted. Proceed with caution and ensure
	you have proper backups before running this script.
*/

/*
=============================================================================
This code isn't needed if you specified your db within the docker-compose file
as 'DataWarehouse' database.
=============================================================================

-- Drop the database if it exists
DROP DATABASE IF EXISTS "DataWarehouse";

-- Recreate the database
CREATE DATABASE "DataWarehouse"
WITH
OWNER = postgres
ENCODING = 'UTF8'
LC_COLLATE = 'en_US.utf8'
LC_CTYPE = 'en_US.utf8'
LOCALE_PROVIDER = 'libc'
TABLESPACE = pg_default
CONNECTION LIMIT = -1
IS_TEMPLATE = False;

*/

-- First, let's create the schemas for the layers
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;