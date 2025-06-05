
## General Principles
- Naming conventions: Use snake_case with all lowercase letters and underscores (_) to seperate words.
- Language: Use English for all names.                 
- Avoid Reserved Words: Do not use SQL reserved words as object names.  

## Table Naming Conventions

# Bronze Rules
- All table names must start with the source system name, and table names must match their original name without renaming.
- ```<sourcesystem>```: Name of the source system (e.g., ```crm```, ```erp```).
- ```<entity>```: Exact table name from the source system.
- Example: ```crm_customer_info``` -> Customer information from the CRM system.

# Silver Rules
- All table names must start with the source system name, and table names must match their original name without renaming.
- ```<sourcesystem>```: Name of the source system (e.g., ```crm```, ```erp```).
- ```<entity>```: Exact table name from the source system.
- Example: ```crm_customer_info``` -> Customer information from the CRM system.

# Gold Rules
- All names must be meaningful, business-aligned names for tables, starting with the category prefix.
- ```<category>```: Describes the role of the table, such as ```dim``` (dimension) or ```fact``` (fact table).
- ```<entity>```: Desriptive name of the table, aligned with the business domain (e.g., ```customers```, ```products```, ```sales```).
- Example:
    - ```dim_customers``` -> Dimension table for customer data.
    - ```fact_sales``` -> Fact table containing sales transactions.

# Group of Category Patterns
| # Pattern | # Meaning | # Example(s) |
|:---------:|:---------:|:------------:|
|```dim_```  | Dimension Table | ```dim_customer```, ```dim_product``` |
|```fact_``` | Fact Table | ```fact_sales``` |
| ```agg_``` | Aggregated Table | ```agg_customers```, ```agg_sales_monthly``` | 

## Column Naming Conventions

# Surrogate Keys
- All primary keys in dimnesion tables must use the suffix ```_key```.
- ```<table_name>_key```
    - ```<table_name>```: Refers to the name of the table or entity the key belongs to.
    - ```_key```: A suffix indicating that this column is a surrogate key.
    - Example: ```customer_key``` -> Surrogate key in the ```dim_customers``` table.

# Technical Columns
- All technical columns must start with the prefix ```dwh_```, followed by a descriptive name indicating the column's purpose.
- ```dwh_<column_name>```
    - ```dwh```: Prefix exclusively for system-generated metadata.
    - ```<column-name>```: Descriptive name indicating the column's purpose.
    - Example: ```dwh_load_date``` -> System generated column used to store the date when the record was loaded.

## Stored Procedure
- All stored procedures used for loading data must follow the naming pattern:
- ```load_<layer()>```.
    -   ```layer```: Represents the later being loaded, such as ```bronze```, ```silver```, or ```gold```.
    - Example: 
        - ```load_bronze()``` -> Stored procedure for loading data into the Bronze layer.
        - ```load_silver()``` -> Stored procedure for loading data into the Silver layer.
        - ```load_gold()``` -> Stored procedure for loading data into the Gold layer.
