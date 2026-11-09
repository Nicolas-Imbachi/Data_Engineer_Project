SELECT UNNEST([1,1,1,2,3,3,4]) AS numbersA
UNION ALL
SELECT UNNEST([1,2,3,4,5]) AS numbersB;

SELECT UNNEST([1,1,1,2,3,3,4,4,5,5]) AS numbersA
INTERSECT
SELECT UNNEST([1,2,3,4,5]) AS numbersB;

SELECT UNNEST([1,1,1,2]) AS numbersA
EXCEPT ALL
SELECT UNNEST([1,2,3,4,5]) AS numbersB;


CREATE OR REPLACE TEMP TABLE jobs_2023 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;

CREATE OR REPLACE TEMP TABLE jobs_2024 AS 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2023;
SELECT * FROM jobs_2024;

-- Unique job posting in 2023 or 2024

SELECT 2023, COUNT(*) FROM jobs_2023
UNION
SELECT 2024, COUNT(*) FROM jobs_2024;

-- Unique job posting in 2023 but no in 2024

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

-- Jobs Posting appear in both 2023 and 2024

SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;