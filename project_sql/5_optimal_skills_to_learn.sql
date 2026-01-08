/* Find the most high demand and high salary skills for DAs in remote jobs. 
This info is critical for career development and job security.

Get skill demand count and average salary using tables skills_dim, skills_job_dim,
and job_postings_fact. Use inner join to drop values that don't exist in all three tables.
*/


SELECT
        s.skill_id,
        s.skills,
        COUNT (sj.job_id) AS skill_demand_count,
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
        jpf.job_work_from_home = true
GROUP BY
        s.skill_id
HAVING
       COUNT (sj.job_id) > 10
ORDER BY
        average_salary DESC,
        skill_demand_count DESC
LIMIT 10