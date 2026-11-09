-- Terminal Command
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Create Tables
.read 01_create_tables_dw.sql

-- Load Data
.read 02_load_schema_dw.sql