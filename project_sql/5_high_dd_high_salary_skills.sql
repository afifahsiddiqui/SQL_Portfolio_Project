-- Find the most high demand and high salary skills for DAs in remote jobs. This info is critical for career development and job security.


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
LIMIT   10

/*
[
  {
    "skill_id": 8,
    "skills": "go",
    "skill_demand_count": "27",
    "average_salary": "115320"
  },
  {
    "skill_id": 234,
    "skills": "confluence",
    "skill_demand_count": "11",
    "average_salary": "114210"
  },
  {
    "skill_id": 97,
    "skills": "hadoop",
    "skill_demand_count": "22",
    "average_salary": "113193"
  },
  {
    "skill_id": 80,
    "skills": "snowflake",
    "skill_demand_count": "37",
    "average_salary": "112948"
  },
  {
    "skill_id": 74,
    "skills": "azure",
    "skill_demand_count": "34",
    "average_salary": "111225"
  },
  {
    "skill_id": 77,
    "skills": "bigquery",
    "skill_demand_count": "13",
    "average_salary": "109654"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "skill_demand_count": "32",
    "average_salary": "108317"
  },
  {
    "skill_id": 4,
    "skills": "java",
    "skill_demand_count": "17",
    "average_salary": "106906"
  },
  {
    "skill_id": 194,
    "skills": "ssis",
    "skill_demand_count": "12",
    "average_salary": "106683"
  },
  {
    "skill_id": 233,
    "skills": "jira",
    "skill_demand_count": "20",
    "average_salary": "104918"
  }
]
*/