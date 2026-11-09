-- Subquery
SELECT
    *
FROM
    (
        SELECT
            *
        FROM
            job_postings_fact
        WHERE
            salary_year_avg IS NOT NULL
            OR salary_hour_avg IS NOT NULL
    )
LIMIT
    10;

-- CTE 
WITH
    valid_salaries AS (
        SELECT
            *
        FROM
            job_postings_fact
        WHERE
            salary_year_avg IS NOT NULL
            OR salary_hour_avg IS NOT NULL
    )
SELECT
    *
FROM
    valid_salaries;

-- Multiple Subqueries 
-- Scenario 1: subquery in SELECT clause
-- Show job salary next to meadin market overall
SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT
            MEDIAN (salary_year_avg)
        FROM
            job_postings_fact
    ) AS market_median_salary
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT
    10;

-- Scenario 2: subquery in FROM clause
-- Stage only jobs that are remote before aggregating to determite median per job
SELECT
    job_title_short,
    MEDIAN (salary_year_avg) AS median_salary,
    (
        SELECT
            MEDIAN (salary_year_avg)
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM
    (
        SELECT
            job_title_short,
            salary_year_avg
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    ) AS remote_jobs
WHERE
    salary_year_avg IS NOT NULL
GROUP BY
    job_title_short
LIMIT
    10;

-- Scenario 3: subquery in HAVING clause
-- keep only job titles whose median salary is above the overall median
SELECT
    job_title_short,
    MEDIAN (salary_year_avg) AS median_salary,
    (
        SELECT
            MEDIAN (salary_year_avg)
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM
    (
        SELECT
            job_title_short,
            salary_year_avg
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    ) AS remote_jobs
WHERE
    salary_year_avg IS NOT NULL
GROUP BY
    job_title_short
HAVING
    MEDIAN (salary_year_avg) > (
        SELECT
            MEDIAN (salary_year_avg)
        FROM
            job_postings_fact
        WHERE
            job_work_from_home = TRUE
    )
LIMIT
    10;

-- Multiple CTE
-- Compare how mucho more or less remote roles pay compared with onsite roles for each job title
-- CTE to calculate median salary for remote roles and work arrangement, then compare the two
WITH
    title_median AS (
        SELECT
            job_title_short,
            job_work_from_home,
            MEDIAN (salary_year_avg)::INT AS median_salary
        FROM
            job_postings_fact
        WHERE
            job_country = 'Colombia'
        GROUP BY
            job_title_short,
            job_work_from_home
    )
SELECT
    title_median.job_title_short,
    title_median.median_salary AS remote_median_salary,
    onsite.median_salary AS onsite_median_salary,
    remote_median_salary - onsite_median_salary AS salary_difference
FROM
    title_median
    INNER JOIN title_median AS onsite ON title_median.job_title_short = onsite.job_title_short
WHERE
    title_median.job_work_from_home = TRUE
    AND onsite.job_work_from_home = FALSE
ORDER BY
    salary_difference DESC;


-- src && tgt = table name, key = column name
SELECT 
    * 
FROM 
    range(3) AS src(key);

SELECT 
    * 
FROM 
    range(2) AS tgt(key);

SELECT 
    * 
FROM 
    range(3) AS src(key)
WHERE EXISTS (
    SELECT 
        1
    FROM 
        range(2) AS tgt(key)
    WHERE 
        src.key = tgt.key
);

SELECT 
    * 
FROM 
    range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 
        1
    FROM 
        range(2) AS tgt(key)
    WHERE 
        src.key = tgt.key
);

-- Identify Job postings that have a no skills associated with them

SELECT 
    *
FROM
    job_postings_fact AS jpf
WHERE NOT EXISTS (
        SELECT 
            1
        FROM
            skills_job_dim as sjd
        WHERE 
            jpf.job_id = sjd.job_id
    )
ORDER BY 
    job_id;