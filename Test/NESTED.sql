-- ARRAY

WITH skills AS (
        SELECT
            'Python' AS skill
        UNION ALL
        SELECT
            'SQL'
        UNION ALL
        SELECT
            'r'
    ),
    skills_array AS (
        SELECT
            ARRAY_AGG(skill ORDER BY skill) AS skills
        FROM
            skills
    )

    SELECT 
        skills[1]
    FROM skills_array;

-- STRUCT

SELECT { 
    skill: 'Python', 
    type: 'Programming'} 
    AS 
    skill_struct;

WITH skills_struct AS (
        SELECT 
            STRUCT_PACK(
                skill := 'Python',
                type := 'Programming'
            ) AS s
        )
        SELECT 
        -- *
            s.skill,
            s.type
        FROM skills_struct;

-- ARRAY OF STRUCTS

SELECT [
    {skill: 'Py', type: 'programming'},
    {skill: 'SQL', type: 'query_lang'}
    ];

WITH skills_table AS (
        SELECT
            'Python' AS skills, 'programming' AS types
        UNION ALL
        SELECT
            'SQL', 'query_lang'
        UNION ALL
        SELECT
            'r', 'programming'
    ), skills_array_struct AS (
    SELECT 
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) AS array_struct
    FROM skills_table
    ) 
    SELECT 
     array_struct[1],
     array_struct[2].skill,
     array_struct[3].type
    FROM 
    skills_array_struct;
    
-- MAP
WITH skill_map AS (
    SELECT MAP {'skill': 'py', 'type': 'programming'} AS skill_type
    )

    SELECT 
        skill_type['skill'],
        skill_type['type']
    FROM 
        skill_map;

-- JSON
WITH raw_skill_json AS (
    SELECT 
        '{"skill": "python", "type": "programming"}'::JSON AS skill_json
    )
    SELECT
        STRUCT_PACK(
            skill := json_extract_string(skill_json, '$.skill'),
            type := json_extract_string(skill_json, '$.type')
        )
    FROM raw_skill_json;


-- Build a flat skill table for co-workers to access job titles, salary and skills in one table

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- Analyze the median salary per skill

WITH flat_skills AS(
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM 
        job_skills_array
)
SELECT 
    skill, 
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
WHERE salary_year_avg IS NOT NULL
GROUP BY skill
ORDER BY median_salary DESC;