/*
This file is going to simulate a batch process.
Context: 
source table is the priority_roles table
target table is the priority_jobs_snapshot table

Previous version temp table
*/

CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
    SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    pr.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact AS jpf
    LEFT JOIN data_jobs.company_dim AS cd ON jpf.company_id = cd.company_id
    INNER JOIN staging.priority_roles AS pr ON jpf.job_title_short = pr.role_name;

/*
Merge statement will be used to perform the following operations:
1. Unmatched incoming records from the source table will be INSERTED into the target table
2. Matched rows will be UPDATED in the target table with the new priority level and updated_at timestamp
3. Unmatched existing records in the target table will be DELETED from the target table
 */

MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN 
UPDATE SET
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at

WHEN NOT MATCHED THEN
INSERT (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
VALUES ( 
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Check

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS min_priority_lvl,
    MIN(updated_at) AS min_updated_at
FROM
    main.priority_jobs_snapshot
GROUP BY
    job_title_short
ORDER BY
    job_count DESC;