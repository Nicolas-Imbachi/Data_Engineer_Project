-- Aggregate
SELECT
    COUNT(*)
FROM
    job_postings_fact;

-- Window Function
SELECT
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;

SELECT
    job_title_short,
    AVG(salary_hour_avg)
FROM
    job_postings_fact
GROUP BY
    job_title_short;

SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY
            job_title_short,
            company_id
    )
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM ()
LIMIT
    10;

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY
            salary_hour_avg DESC
    ) AS rank_salary_hour
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT
    10;

SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY
            job_title_short
        ORDER BY
            job_posted_date
    ) AS running_verage_hourly_by_title
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    job_title_short,
    job_posted_date
LIMIT
    100;

SELECT
    job_id,
    company_id,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG (salary_year_avg) OVER (
        PARTITION BY
            company_id
        ORDER BY
            job_posted_date
    ) AS previous_posting_salary,
    salary_year_avg - LAG (salary_year_avg) OVER (
        PARTITION BY
            company_id
        ORDER BY
            job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT
    60;

SELECT
    job_id,
    company_id,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD (salary_year_avg) OVER (
        PARTITION BY
            company_id
        ORDER BY
            job_posted_date
    ) AS next_posting_salary,
    salary_year_avg - LEAD (salary_year_avg) OVER (
        PARTITION BY
            company_id
        ORDER BY
            job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    company_id,
    job_posted_date
LIMIT
    60;