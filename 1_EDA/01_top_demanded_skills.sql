/*
    What are the most in-demand skills for data engineers?
    - Get top 10 Skills for Data Engineers
    - Remote jobs 
    - Colombia-based
*/

SELECT
    sd.skills,
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
ORDER BY demand_count DESC
LIMIT 10;

/*

Results: 
┌───────────┬──────────────┐
│  skills   │ demand_count │
│  varchar  │    int64     │
├───────────┼──────────────┤
│ sql       │          142 │
│ python    │          138 │
│ aws       │           47 │
│ spark     │           40 │
│ pyspark   │           23 │
│ airflow   │           22 │
│ pandas    │           21 │
│ azure     │           21 │
│ snowflake │           19 │
│ gcp       │           19 │
└───────────┴──────────────┘
  10 rows        2 columns

Breakdown of the top 10 most in-demand skills for Data Engineers in Colombia for remote jobs:

  SQL and Python are the most sought-after skills, followed by cloud platforms like AWS, Spark, 
  and PySpark. Other notable skills include Airflow, Pandas, Azure, Snowflake, and GCP. 
  These skills are essential for data engineers looking to work remotely in Colombia.

  Filtering by Colombia reduces the number of job postings, but it still provides a clear picture 
  of the skills that are in demand for data engineers in the region.

*/


