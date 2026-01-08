/*
Find the top 10 paying remote jobs for Data Analysts */ 

SELECT
        jpf.job_id,
        jpf.job_title,
        company_dim.name AS company_name,
        jpf.job_location,
        jpf.job_schedule_type,
        jpf.salary_year_avg,
        jpf.job_posted_date
FROM    
        job_postings_fact AS jpf
LEFT JOIN
        company_dim ON
        company_dim.company_id = jpf.company_id
WHERE
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL AND
        job_title_short = 'Data Analyst'
ORDER BY
        salary_year_avg DESC
LIMIT 10