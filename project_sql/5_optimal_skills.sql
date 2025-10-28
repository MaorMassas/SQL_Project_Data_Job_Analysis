/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles.
- Concentrates on remote positions with specified salaries.
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
  offering strategic insights for career development in data analysis.
*/

WITH skills_demand AS (
    SELECT 
        s.skill_id,
        s.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
    INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst'
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY s.skill_id, s.skills
),
average_salary AS (
    SELECT 
        sjd.skill_id,
        ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact AS j
    INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
    INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst'
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY sjd.skill_id
)
SELECT 
    d.skill_id,
    d.skills,
    d.demand_count, 
    a.avg_salary
FROM skills_demand AS d
INNER JOIN average_salary AS a ON d.skill_id = a.skill_id
WHERE demand_count > 10
ORDER BY 
        avg_salary DESC,
    demand_count DESC
LIMIT 25

-- rewriting this same query more concisely
SELECT 
    s.skill_id,
    s.skills,
    COUNT(sjd.job_id) AS demand_count,
    ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
WHERE   
    j.job_title_short = 'Data Analyst'
    AND j.salary_year_avg IS NOT NULL
    AND j.job_work_from_home = TRUE
GROUP BY 
    s.skill_id, s.skills
HAVING 
    COUNT(sjd.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;

