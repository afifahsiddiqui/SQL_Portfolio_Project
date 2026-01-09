# Introduction
The goal of this project is to **demonstrate my practical SQL skills** by working with a real-world relational database. The focus is on writing clear, efficient SQL queries to explore data, perform joins, apply filters, and aggregate results to answer meaningful questions.

Although the dataset is rooted in a data analytics use case, this repository emphasizes SQL query logic and problem-solving rather than deep industry or business analysis.

# Background
Alice (hypothetical) is a mid-career professional aiming to step into higher-paying, senior-level Data Analyst roles. She asked me to help her better understand the job market. Using SQL and job market data from 2023, I help her answer the following questions: 

- What are the 10 highest-paying Data Analyst roles that allow remote work?

- What skills are required for these top-paying roles?

- What are the top 5 most in-demand skills across all Data Analyst jobs in New York?

- What are the top 20 highest-paid skills for Data Analyst positions?

- Which skills should Alice prioritize learning to maximize both demand and compensation for WFH roles?

Here are the queries I used to find the answers:  [project_sql folder](/project_sql/)

# Tools I Used
- **SQL:** Core language used to query and analyze the data
- **PostgreSQL:** Database management system for storing and querying the dataset
- **Visual Studio Code:** Code editor used to write and run SQL queries
- **Git & GitHub:** Version control and project sharing

# Analysis
Each query in this project targets a specific aspect of the Data Analyst job market. Below is an overview of the approach and insights for each question.

### 1. What are the 10 highest-paying Data Analyst jobs in the market that allow remote work?

To answer this question, I used information from two tables:

- *job_postings_fact table* containing job details such as title, salary, and location.

- *company_dim table* containing company names.

Query approach:

- Filtered job postings to include relevant columns.
  
- Joined the company table to associate each role with its company name

- Sorted results by salary in descending order

- Limited the output to the top 10 highest-paying roles

SQL query:

```sql
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
```

Result:

![Top ten paying jobs](D:\Work\Personal Projects\SQL_Portfolio_Project\assets\Top_10_paying_jobs.png)
*Graph visualizing the outcome was created by Perplexity AI using my results.*

**3 key takeaways for Alice:**

- *Big salary range:* Remote data analytics jobs vary a lot in pay. Most top roles cluster around $180K–$250K making this range a more realistic target.

- *SmartAsset is hiring fast:* They have two openings at $186K and $205K. Multiple postings usually mean active growth or team expansion.

- *Senior titles pay more:*
Go for roles like Principal or Director to boost your pay by 30–50%. With your mid-career experience, that's a logical next step.


### 2. What skills are required for these top-paying roles?

For this question, I needed information from all four tables:

- *job_postings_fact table* containing job details such as title, salary, and location.

- *company_dim table* containing the names of all the companies

- *skills_job_dim table* serving as a bridge that links job_id to skill_id

- *skills_dim table* containing the name of all the skills associated with the skill_id

Query approach:

- Converted the previous query into a CTE to isolate the top 10 highest-paying remote Data Analyst roles, keeping only the columns required for analysis.

- Used an INNER JOIN between the CTE and skills_job_dim to retrieve all skills associated with each of the top-paying jobs.

- Used an INNER JOIN between skills_job_dim and skills_dim to map each skill_id to its corresponding skill name. This join type is appropriate because we only want skills that are explicitly linked to the selected jobs.

- Sorted the final results by average annual salary to keep higher-paying roles at the top.

- Limited the initial CTE to the top 10 highest-paying roles to focus the analysis on premium positions only.

SQL query:

``` sql
WITH top_10_data_analyst_jobs AS (
            SELECT
                    jpf.job_id,
                    jpf.job_title,
                    company_dim.name AS company_name,
                    jpf.salary_year_avg
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
)

SELECT 
        top_10.*,
        skills.skills AS skill_name
FROM
         top_10_data_analyst_jobs AS top_10
INNER JOIN 
        skills_job_dim ON
        skills_job_dim.job_id = top_10.job_id 
INNER JOIN 
        skills_dim AS skills ON
        skills.skill_id = skills_job_dim.skill_id
ORDER BY
        top_10.salary_year_avg DESC
```
Result:
![Skills demanded by top paid jobs](assets\skills_demanded_by_top_paying_remote_jobs_DA.png)
*Graph visualizing the outcome was created by Perplexity AI using my results.*

**3 Key Takeaway for Alice:**
- *SQL is non-negotiable:* Every top-10 highest-paying role requires it. Strengthening your SQL skills is essential to stay competitive.

- *Python and Tableau are close seconds:* Python appears in 7/10 roles and Tableau in 6/10, making them powerful, high-value complements to SQL.

- *Niche skills unlock premium roles:* Tools like Snowflake, Pandas, and Azure show up less often but are tied to the highest-paying positions. Building these skills can qualify you for the top end of the salary range.


### 3. What are the top 5 most in-demand skills across all Data Analyst jobs in New York,NY?

For this question, I used three tables:

- *job_postings_fact table* containing job details such as title and location.

- *skills_job_dim table* serving as a bridge that links job_id to skill_id

- *skills_dim table* containing the name of all the skills associated with the skill_id

Query approach:

- Used filters on the job_postings_fact table to isolate only Data Analyst jobs based in New York.

- Used INNER JOIN to combine job_postings_fact table with skills_job_dim to get all skill_ids associated with the filtered jobs.

- Used INNER JOIN to connect skills_dim table with skills_job_dim table to match all the skill names to the skill_ids.

- Applied GROUP BY to aggregate data by skill and COUNT to get demand frequency.

- Ordered the result by frequency in descending order and limited it to show only the top 5 skills.

SQL query:

``` sql
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
```
Result:

| skills   | skill_demand_count |
|----------|-------------------|
| SQL      | 1695              |
| Excel    | 1294              |
| Python   | 988               |
| Tableau  | 968               |
| R        | 565               |

**3 Key Takeaway for Alice:**
- *SQL is the foundation skill:* With the highest demand by a wide margin, SQL is the single most critical skill for data analyst roles in New York. Mastery here is non-negotiable.

- *Excel still matters—at scale:* Despite newer tools, Excel remains the second most in-demand skill, signaling that strong spreadsheet, reporting, and business-facing analysis skills are still highly valued.

- *Programming and visualization differentiate you:* Python and Tableau appear in nearly as many roles as Excel, showing that analysts who can both code (Python/R) and communicate insights visually have a strong competitive edge in the market.

### 4. What are the top 20 highest-paid skills for Data Analyst positions with the option to work from home?

For this question, I used three tables:

- *job_postings_fact table:* Containing job details such as title, salary, and work-from-home status.

- *skills_job_dim table:* linking each job_id to its associated skill_id.

- *skills_dim table:* Carrying the names of all skills associated with each skill_id.

Query approach:

- Filtered the dataset to include only Data Analyst jobs that offer work-from-home and report an annual salary.

- Linked jobs to their associated skills using the bridge table, then matched skill IDs to skill names.

- Aggregated the data to calculate the average salary for each skill.

- Sorted the results from highest to lowest average salary and selected the top 20 skills.

SQL query:

``` sql
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
LIMIT 20

```
Result:

![Top 20 highest paid skills](assets\Top_20_highest_paid_skills_DA.png)

*Graph visualizing the outcome was created by Perplexity AI using my results.
*

**3 Key Takeaway for Alice:**
- *Specialized tools command the highest pay:* Skills like PySpark ($208K), Bitbucket ($189K), and Watson/Couchbase ($160K) are niche but associated with top-paying roles. Learning these can significantly increase earning potential, even if they’re less commonly required.

- *Data libraries open doors:* Pandas, NumPy, Scikit-learn, and Jupyter are highly transferable, letting you access a wide range of data roles and prepare for higher-paying niche skills.

- *DevOps, cloud, and infrastructure skills boost salaries:* GitLab ($154K), Linux ($136K), Kubernetes ($132K), Airflow ($126K), Jenkins ($125K) show that knowledge of version control, cloud infrastructure, and workflow automation can give a competitive edge, especially for advanced analyst or data engineering roles.

### 5. Which skills should Alice prioritize learning to maximize both demand and compensation for WFH roles?

For this answer, I used three tables:

- *job_postings_fact table:* Containing details about each job, including title, salary, and work-from-home status.

- *skills_job_dim table:* Acting as a bridge between jobs and their associated skills.

- *skills_dim table:* Providing the names of all skills linked to their IDs.

Query approach:

- Filtered the job postings to include only Data Analyst roles that report a salary and offer work-from-home.

- Linked jobs to their associated skills via the bridge table and matched skill IDs to skill names.

- Aggregated the data to calculate both how often each skill is requested (demand count) and the average salary for jobs requiring that skill.

- Applied a minimum threshold to focus on skills appearing in more than 10 job postings.

- Sorted the results to prioritize highest-paying skills first, breaking ties by demand, and selected the top 10 skills.

SQL query:

``` sql
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

```
Result:

| skill_id | skills     | skill_demand_count | average_salary |
|----------|------------|--------------------|----------------|
| 8        | go         | 27                 | $115,320       |
| 234      | confluence | 11                 | $114,210       |
| 97       | hadoop     | 22                 | $113,193       |
| 80       | snowflake  | 37                 | $112,948       |
| 74       | azure      | 34                 | $111,225       |
| 77       | bigquery   | 13                 | $109,654       |
| 76       | aws        | 32                 | $108,317       |
| 4        | java       | 17                 | $106,906       |
| 194      | ssis       | 12                 | $106,683       |
| 233      | jira       | 20                 | $104,918       |

**3 Key Takeaway for Alice:**
- *Cloud and data warehouse skills drive both demand and pay:* Tools like Snowflake, Azure, AWS, and BigQuery are in demand for WFH roles and offer solid salaries.

- *Programming and workflow skills add versatility:* Languages like Go and Java, along with ETL tools like SSIS, will expand your eligibility for higher-paying WFH roles.

- *Collaboration and project management tools complement technical skills:* Tools like Confluence and Jira are less technical but highly valued for remote teamwork. Proficiency in these will make you more competitive for Data Analyst roles.

# Conclusions

From this analysis of the Data Analyst job market, here are 3 key takeaways for Alice:

- *SQL is the foundation:* Across all roles, whether high-paying, remote, or in-demand, SQL remains the most critical skill. Mastery of SQL is non-negotiable for career growth in data analytics.

- *Strategic skill-building maximizes impact:* Combining SQL with high-value tools like Python, Tableau, Snowflake, and cloud platforms (AWS, Azure, BigQuery) opens doors to top-paying roles and remote opportunities. Prioritizing these skills provides both high demand and compensation.

- *Senior titles and niche expertise matter:* Roles with senior titles or specialized skills such as PySpark, Hadoop, or ETL tools tend to command the highest salaries. Positioning yourself for these roles by gaining niche expertise can significantly accelerate career growth.

# My Learnings

Working on this project deepened my understanding of practical SQL applications in a real-world context:

- Joins and CTEs: Using INNER JOIN, LEFT JOIN, and Common Table Expressions allowed me to combine multiple tables cleanly and analyze complex datasets efficiently.

- Aggregations and filtering: Grouping, counting, and averaging data helped extract meaningful insights, while WHERE and HAVING clauses ensured precision in targeting the right subset of jobs or skills.

- Data-driven decision-making: SQL is not just about retrieving data. It enables thoughtful analysis to answer strategic questions, such as identifying high-paying roles or prioritizing skill development.

- Visualization synergy: While SQL provided the raw insights, creating visualizations from query results helped translate numbers into actionable and easy-to-understand recommendations.

Overall, this project reinforced that SQL is a powerful tool for both exploration and storytelling in data analysis.