-- Terminal Command
-- Locally
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
-- Motherduck
-- duckdb md:dw_marts -c ".read build_dw_marts.sql"

-- Create Tables
.read 01_create_tables_dw.sql

-- Load Data
.read 02_load_schema_dw.sql

-- Create Flat Mart
.read 03_create_flat_mart.sql

-- Create Skill Demand Mart
.read 04_create_skills_mart.sql

-- Create Priority Mart
.read 05_create_priority_mart.sql

-- Update Priority Mart
.read 06_update_priority_mart.sql