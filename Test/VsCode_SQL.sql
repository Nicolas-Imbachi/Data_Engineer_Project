-- Following queries are connected to a DuckDB database named 'data_jobs' and are used to retrieve metadata about the tables and columns in that database.

-- Keybind to run in active terminal SHIFT + ENTER
-- make sure duckdb is running as act terminal

-- Verification on the ERD
SELECT * FROM information_schema.tables WHERE table_catalog = 'data_jobs';
SELECT * FROM information_schema.columns WHERE table_catalog = 'data_jobs';
SELECT * FROM information_schema.table_constraints WHERE table_catalog = 'data_jobs';
SELECT * FROM information_schema.key_column_usage WHERE table_catalog = 'data_jobs';

-- Verification on the job_postings_fact table
DESCRIBE job_postings_fact;

-- Test JOINs in the job_postings_fact table with other tables
-- Left Join with company_dim table to get company details for each job posting
SELECT 
    jpf.*,
    cd.*
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

-- LEFT JOIN with skills_job_dim and skills_dim tables to get skill details for each job posting regardless of whether the job posting has associated skills or not
SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;

-- INNER JOIN with skills_job_dim and skills_dim tables to get skill details for each job posting only if the job posting has associated skills
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id;
