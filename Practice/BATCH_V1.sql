/*
This file is going to simulate a batch process.
Following is the INITIAL load of the priority_roles table, which will be used to determine the priority level of each role in the job_postings_fact table.
 */
CREATE
OR REPLACE TABLE staging.priority_roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(255),
    priority_lvl INT
);

INSERT INTO
    staging.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Engineer', 1),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer', 3);

SELECT
    *
FROM
    staging.priority_roles;

/*
This file is going to simulate a batch process.
Following is the INITIAL load of priority_jobs_snapshot
This query should not be re run, as this is the initial snapshot and will 
be updated through the update of priority_roles table
 */
CREATE
OR REPLACE TABLE main.priority_jobs_snapshot (
    job_id INT PRIMARY KEY,
    job_title_short VARCHAR(255),
    company_name VARCHAR(255),
    job_posted_date TIMESTAMP,
    salary_year_avg DOUBLE,
    priority_lvl INT,
    updated_at TIMESTAMP
);

INSERT INTO
    main.priority_jobs_snapshot (
        job_id,
        job_title_short,
        company_name,
        job_posted_date,
        salary_year_avg,
        priority_lvl,
        updated_at
    )
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

-- Check the data in the priority_jobs_snapshot table
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



/*
This file is going to simulate a batch process.
Context: 
source table is the priority_roles table
target table is the priority_jobs_snapshot table

unmatched incoming records from the source table will be INSERTED into the target table
matched rows will be UPDATED in the target table with the new priority level and updated_at timestamp
unmatched existing records in the target table will be DELETED from the target table
 */

-- Create TEMP table to hold the incoming records from the source table
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

-- UPDATE existing records in the target table with the new priority level and updated_at timestamp
UPDATE main.priority_jobs_snapshot AS tgt
SET 
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id AND
    tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;




-- INSERT new records into the target table
INSERT INTO main.priority_jobs_snapshot (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
FROM
    src_priority_jobs as src
WHERE NOT EXISTS (
    SELECT 1
    FROM main.priority_jobs_snapshot AS tgt
    WHERE tgt.job_id = src.job_id
);



-- DELETE unmatched existing records in the target table
DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM src_priority_jobs AS src
    WHERE src.job_id = tgt.job_id
);

-- Final Check: Select all records from the target table to verify the changes
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
