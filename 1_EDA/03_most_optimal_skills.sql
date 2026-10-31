/*
    What are the most optimal skills for data engineers balancing salary and demand?
    - Create a ranking that combines demand and salary to find the most optimal skills for data engineers
    - Remote jobs 
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demanded_count,
    ROUND(LN(COUNT(jpf.salary_year_avg)), 1) AS demand_score,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.salary_year_avg))/1_000_000), 3) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    -- AND jpf.job_country = 'Colombia'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING 
    COUNT(jpf.*) > 1
ORDER BY 
    optimal_score DESC
LIMIT 10;


/*
    Results: 

┌───────────┬───────────────┬────────────────┬──────────────┬───────────────┐
│  skills   │ median_salary │ demanded_count │ demand_score │ optimal_score │
│  varchar  │    double     │     int64      │    double    │    double     │
├───────────┼───────────────┼────────────────┼──────────────┼───────────────┤
│ terraform │      184000.0 │            193 │          5.3 │         0.968 │
│ python    │      135000.0 │           1133 │          7.0 │         0.949 │
│ aws       │      137320.0 │            783 │          6.7 │         0.915 │
│ sql       │      130000.0 │           1128 │          7.0 │         0.914 │
│ airflow   │      150000.0 │            386 │          6.0 │         0.893 │
│ spark     │      140000.0 │            503 │          6.2 │         0.871 │
│ snowflake │      135500.0 │            438 │          6.1 │         0.824 │
│ kafka     │      145000.0 │            292 │          5.7 │         0.823 │
│ azure     │      128000.0 │            475 │          6.2 │         0.789 │
│ java      │      135000.0 │            303 │          5.7 │         0.771 │
└───────────┴───────────────┴────────────────┴──────────────┴───────────────┘
  10 rows                                                         5 columns

  Breakdown of the optimal score calculation:
    optimal_score = (median_salary * demand_score) / 1_000_000
    note: we used ln to scale the demand score to avoid skewing the optimal score too much by high demand counts.

    the optimal score is a combination of the median salary and the demand score, which is calculated as the natural logarithm 
    of the count of job postings for each skill. This allows us to balance both salary and demand in determining the most optimal 
    skills for data engineers.

    The results show that terraform, python, and aws are the top three most optimal skills for data engineers when considering both salary and demand.
    
    note: We remove the country filter to get a more global perspective on the most optimal skills for data engineers, as the demand and salary can vary significantly by country.
*/