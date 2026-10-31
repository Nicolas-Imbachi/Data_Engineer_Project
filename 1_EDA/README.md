## Exploratory Data Analysis with SQL: Job Market Analysis

![EDA](Assets\1_1_Project1_EDA.png)

SQL project analysis the data engineer job market using real world job posting data. It demonstrates ability to **write prodcution-quality analytical SQL, design efficient queries and turn business questions into data-driven insights**

## Executive Summary 

I Built analytical queries to answer questions about the job market for a specific job **Data Engineer**.

I Applied aggregations, filtering and sorting to find top skills by demand, salary and overall value. Using LN that allows us to reduce the impact of large differences in the number of occurrences without eliminating the importance of demand.

Finally I delivered actionable insights on SQL and Python dominance in the job market and also cloud trends and salary pattern.

Here are the files to review what I previous describe:

1. [`Top Demanded Skills`](./01_top_demanded_skills) - Demand Analysis with Multi-table Joins
2. [`Top Paying Skills`](./02_top_paying_skills.sql) - Salary Analysis with Multi-table Joins and Aggregation
3. [`Most Optimal Skills`](./03_most_optimal_skills.sql) Overall Analysis Optimize Query

## Problem & Context

Answer the questions regarding the job market:

- **Most demanded Skills**: Which skills are the most demanded for Data Engineers?
- **Highest Paid**: Which skill command the highest salaries? 
- **Best Trade-off**: Which are the optimal skills balancing demand and salary?

This project analyzes a **data warehouse** built in using star schema design, the warehouse structure consists of: 

![Data Warehouse](./Assets/1_2_Data_Warehouse.png)

**Fact Table**: 
- `job_postings_fact` - Central table containing job posting details (job titles, locations, salaries, dates, etc.).

**Dimension Tables**: 
- `company_dim ` - Company information linked to job postings.  
- `skills_dim` - Skills catalog with skill names and types. 

**Bridge Table**:  
- `skills_job_dim ` - Resolves the many-to-many relationship between job postings and skills.  

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.

## Tech Stack

**Query Engine**: DuckDB for fast OLAP-style analytical queries.  
**Language**: SQL (ANSI-style with analytical functions).  
**Data Model**: Star schema with fact + dimension + bridge tables.  
**Development**: VS Code for SQL editing + Terminal for DuckDB CLI.  
**Version Control**: Git/GitHub for versioned SQL scripts.  

## SQL Skills 

### Query Design & Optimization
- **Complex Joins**: Multi-table INNER JOIN operations across job_postings_fact, skills_job_dim, and skills_dim.  
- **Aggregations**: COUNT(), MEDIAN(), ROUND() for statistical analysis.  
- **Filtering**: Boolean logic with WHERE clauses and multiple conditions (job_title_short, job_work_from_home, salary_year_avg IS NOT NULL).  
- **Sorting & Limiting**: ORDER BY with DESC and LIMIT for top-N analysis.

### Data Analysis Techniques
- **Grouping**: GROUP BY for categorical analysis by skill.  
- **Mathematical Functions**: LN() for natural logarithm transformation to normalize demand metrics.  
- **Calculated Metrics**: Derived optimal score combining log-transformed demand with median salary.  
- **HAVING Clause**: Filtering aggregated results (skills with >= n postings).  
- **NULL Handling**: Proper filtering of incomplete records (salary_year_avg IS NOT NULL).  