/*
    What are the highest-paying skills for data engineers?
    - Calculate through the median salary of the job postings that require each skill
    - Remote jobs 
    - Colombia-based
    - Include frequency of each skill in the results 
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'Colombia'
    AND jpf.job_work_from_home = True
GROUP BY sd.skills
HAVING 
    COUNT(jpf.*) > 10
ORDER BY 
    median_salary DESC
LIMIT 10; 

/*

Results: 

┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ aws        │      153438.0 │           47 │
│ databricks │      135938.0 │           15 │
│ pandas     │      122500.0 │           21 │
│ pyspark    │      122500.0 │           23 │
│ python     │      122500.0 │          138 │
│ numpy      │      122500.0 │           18 │
│ sql server │      116250.0 │           11 │
│ gcp        │      110938.0 │           19 │
│ kafka      │      110000.0 │           15 │
│ sql        │      110000.0 │          142 │
└────────────┴───────────────┴──────────────┘
  10 rows                         3 columns

Breakdown of the top 10 highest-paying skills for Data Engineers in Colombia for remote jobs:

    AWS tops the list with a median salary of $153,438, followed by Databricks at $135,938. 
    Other high-paying skills include Pandas, PySpark, Python, Numpy, SQL Server, GCP, Kafka, and SQL. 
    These skills are not only in demand but also command higher salaries for data engineers working remotely in Colombia.
    
    The frequency of each skill is also included in the results, providing insight into how often these skills are required in job postings. 
    This information can help data engineers prioritize which skills to develop based on both demand and potential salary.

*/