-- Find the most highly demanded skills for Data analysts irrespective of job location and schedule type

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

/*

Results:

[
  {
    "skills": "sql",
    "skill_demand_count": "1695"
  },
  {
    "skills": "excel",
    "skill_demand_count": "1294"
  },
  {
    "skills": "python",
    "skill_demand_count": "988"
  },
  {
    "skills": "tableau",
    "skill_demand_count": "968"
  },
  {
    "skills": "r",
    "skill_demand_count": "565"
  }
]

*/