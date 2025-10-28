/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and
  helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*
Summary: Key high-paying skills for Data Analysts

- Big Data & ML Skills: Expertise in PySpark, Couchbase, DataRobot, Jupyter, Pandas, and NumPy
  drives top salaries due to strong data processing and predictive modeling capabilities.

- Software Development & Deployment: Knowledge of GitLab, Kubernetes, and Airflow
  shows value in automation and efficient data pipeline management.

- Cloud Computing: Familiarity with Elasticsearch, Databricks, and GCP
  boosts earning potential by enabling cloud-based analytics and scalability.
*/
