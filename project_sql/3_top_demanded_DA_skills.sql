/* Find the most highly demanded skills for Data analysts
irrespective of job location and schedule type 

First, how would I solve this?
what we finally need is 
- skills demanded for data analyst jobs
        - find data analyst jobs
        - skills for data analyst job
        - count skills
- group the skills by count in desc order

*/

SELECT
        skills_dim.skills,
        COUNT (skills_job_dim.job_id) AS skill_demand_count
FROM
        job_postings_fact AS jpf
INNER JOIN
        skills_job_dim ON
        skills_job_dim.job_id = jpf.job_id
INNER JOIN
        skills_dim ON
        skills_dim.skill_id = skills_job_dim.skill_id
WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'New York, NY'
GROUP BY
        skills_dim.skills
ORDER BY
        skill_demand_count DESC
LIMIT 5