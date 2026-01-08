/* Find the most high paying skills for a Data Analyst 
- Average salary per skill (only for skills demanded by Data 
Analyst jobs)
- find salary paid by a job requiring a particular skill
- one job can require multiple skills, so the number we're getting at
is per skill is only a proxy but that's the most we can do right now. There may be
an important correlation.
- use job id, skill id, skill name, salary year average
*/

SELECT
        skills,
        ROUND (AVG (jpf.salary_year_avg),0) AS average_salary
FROM
        job_postings_fact AS jpf
INNER JOIN
        skills_job_dim AS sj ON
        sj.job_id = jpf.job_id
INNER JOIN
        skills_dim AS s ON
        s.skill_id = sj.skill_id
WHERE
        jpf.job_title_short = 'Data Analyst' AND
        jpf.salary_year_avg IS NOT NULL AND
        jpf.job_work_from_home = True
GROUP BY 
        skills
ORDER BY
        average_salary DESC
LIMIT 30

/*
Skill-based pay insight:
1. Big Data tools (like PySpark, Databricks) pay most as companies need analysts who handle massive datasets.
2. Dev tools (Bitbucket, GitLab, Jenkins) sit at number 2 because analysts increasingly work with engineering teams.
3. Python libraries (Pandas, Jupyter, NumPy) pay around $145k-$153k. Everyone uses Python, so knowing its data packages boosts pay.
4. Cloud skills (GCP, PostgreSQL) beat old databases like DB2 by $10k+—modern companies run on cloud.
*/