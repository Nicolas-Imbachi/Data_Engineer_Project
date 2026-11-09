-- Categorize salaries into Low, Medium, and High based on the average hourly salary

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE 
        WHEN salary_hour_avg < 20 THEN 'Low'
        WHEN salary_hour_avg BETWEEN 20 AND 40 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
WHERE salary_hour_avg IS NOT NULL
LIMIT 10;


-- Filter NULL values

SELECT 
    job_title_short,
    salary_hour_avg,
    CASE
        WHEN salary_hour_avg IS NULL THEN 'Missing'
        WHEN salary_hour_avg < 20 THEN 'Low'
        WHEN salary_hour_avg BETWEEN 20 AND 40 THEN 'Medium'
        ELSE 'High'
    END AS salary_category
FROM job_postings_fact
LIMIT 10;

-- Standarize categorical values

SELECT 
    job_title,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
    END AS job_title_category,
    job_title_short,
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;