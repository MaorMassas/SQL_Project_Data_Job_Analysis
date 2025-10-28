# 📊 Data Analyst Job Market — SQL Portfolio Project

> 🎯 **Goal:** Identify which skills, tools, and roles lead to **the highest salaries** and **strongest demand**  
> across the **Data Analyst job market (2023–2024)** — using only **SQL**.

---

## 🧭 Overview
An end-to-end SQL analysis exploring **salary trends**, **skill demand**, and **career optimization**  
for remote Data Analyst positions with defined salaries.

This project demonstrates how to:
- Ask data-driven business questions  
- Build analytical SQL pipelines with joins and CTEs  
- Extract actionable insights for career planning  

---

## 🧱 Table of Contents
1. [Introduction](#introduction)
2. [Background](#background)
3. [Tools I Used](#tools-i-used)
4. [The Analysis](#the-analysis)
   - [Q1: Top-Paying Jobs](#q1--top-paying-jobs)
   - [Q2: Skills for Top-Paying Roles](#q2--skills-for-top-paying-roles)
   - [Q3: Most In-Demand Skills](#q3--most-in-demand-skills)
   - [Q4: Highest Paying Skills](#q4--highest-paying-skills)
   - [Q5: Optimal Skills to Learn](#q5--optimal-skills-to-learn)
5. [What I Learned](#what-i-learned)
6. [Conclusions](#conclusions)

---
## 🧩 Introduction
The role of a **Data Analyst** has evolved — it's no longer just Excel and dashboards.  
Modern analysts combine **SQL, programming, and cloud** to transform raw data into strategic insights.

This project aims to answer:
> 💡 *“Which skills are both in high demand and pay the highest for Data Analysts?”*

Using structured SQL analysis, I explored salary data, company listings, and skill mappings  
to uncover what truly drives **career growth** and **financial reward** in today’s data job market.

---

## 📚 Background
The dataset covers thousands of **Data Analyst** job postings across 2023–2024.  
It contains information such as:

- 🏢 **Company information:** industry, size, and hiring location  
- 💵 **Salary data:** average annual pay (only where explicitly defined)  
- 🧠 **Skills mapping:** connections between job roles and required skills  
- 🌍 **Remote indicators:** allows filtering for “Anywhere” roles  

Each query in this project builds on the previous one — starting with salary exploration  
and ending with actionable career recommendations.

---

## ⚙️ Tools I Used

| 🔧 Tool | 💡 Purpose |
|----------|------------|
| 🐘 **PostgreSQL** | Core engine for all SQL queries and analysis |
| 💻 **VS Code** | Environment for scripting and documentation |
| 📊 **Tableau / Excel** | Optional visualization of results |
| 🧾 **Markdown** | For project documentation (README) |
| ☁️ **GitHub** | Version control and portfolio presentation |

> 🧭 *The focus was to demonstrate data analysis logic entirely in SQL, without external BI tools.*

---
## 🔍 The Analysis

---

### 💰 Q1 — What are the top-paying Data Analyst jobs?

```sql
SELECT
  j.job_id, j.job_title, j.job_location, j.salary_year_avg, c.name AS company_name
FROM job_postings_fact AS j
LEFT JOIN company_dim AS c ON j.company_id = c.company_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.job_location = 'Anywhere'
  AND j.salary_year_avg IS NOT NULL
ORDER BY j.salary_year_avg DESC
LIMIT 10;
```

## 🧠 Summary:

The top remote roles pay between $184K-$650K/year.
Director / Principal titles dominate the top of the list.
All are full-time - no freelance or part-time listings.

### 🧠 Q2 — What skills are required for the top-paying jobs?
```sql
WITH top_paying_jobs AS (
  SELECT job_id, job_title, salary_year_avg, name AS company_name
  FROM job_postings_fact
  LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
  WHERE job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
  ORDER BY salary_year_avg DESC
  LIMIT 10
)
SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
The highest salaries correlate with broad technical fluency —
mixing analytics, BI, and cloud data engineering.

### 📈 Q3 — What are the most in-demand skills for Data Analysts?
```sql
SELECT 
  skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
## 🎯 Interpretation:

SQL remains the most foundational skill for analysts.
Excel still dominates in operational analytics.
BI tools and Python are essential for scalability and automation.

### 💼 Q4 — What are the top skills based on salary?

```sql
SELECT 
  skills,
  ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND salary_year_avg IS NOT NULL
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```
🏆 High-Paying Skill Clusters:
💾 Big Data & ML: PySpark, Couchbase, DataRobot, Pandas, NumPy
⚙️ DevOps & Automation: GitLab, Kubernetes, Airflow
☁️ Cloud Engineering: Elasticsearch, Databricks, GCP
💰 These skills average $110K–$130K+, showing strong overlap with data engineering.

### 🚀 Q5 — What are the most optimal skills to learn (high demand + high salary)?

```sql
SELECT 
  s.skill_id,
  s.skills,
  COUNT(sjd.job_id) AS demand_count,
  ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact AS j
INNER JOIN skills_job_dim AS sjd ON j.job_id = sjd.job_id
INNER JOIN skills_dim AS s ON sjd.skill_id = s.skill_id
WHERE j.job_title_short = 'Data Analyst'
  AND j.salary_year_avg IS NOT NULL
  AND j.job_work_from_home = TRUE
GROUP BY s.skill_id, s.skills
HAVING COUNT(sjd.job_id) > 10
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 25;
```

## 🎯 Takeaway:
To maximize both salary and employability, aim for this stack:
🧩 SQL + Python + BI + Cloud (Snowflake / AWS / Azure)

## 📊 Salary vs Demand — Visualization

## graph TD
A[SQL 🧠] -->|High Demand| B(💵 $97K)
C[Python 🐍] -->|High Demand| D(💵 $101K)
E[Tableau 📊] -->|Medium| F(💵 $99K)
G[Snowflake ❄️] -->|Medium| H(💵 $113K)
I[AWS ☁️] -->|Low| J(💵 $108K)
K[Azure ☁️] -->|Low| L(💵 $111K)

## 📘 Insight:
Cloud tools like Snowflake, Azure, and AWS pay more,
while core tools like SQL and Python secure job stability and hiring potential.

### 🧠 What I Learned

Through this SQL-only exploration, I learned how much data storytelling can come directly from queries —
no need for complex dashboards when your logic is strong.
## Key takeaways:
💡 SQL is more powerful than most think — with CTEs and joins you can extract complex insights without Python or BI.
🔍 Data cleaning and filtering are as critical as analysis — removing nulls or irrelevant roles changes your conclusions entirely.
📊 Context matters — “Top-paying” doesn’t always mean “best fit”; demand and accessibility must be considered together.
🌐 Career insights are data projects too — by analyzing the job market itself, you turn data into real-world decisions.
🧩 Combining SQL with business thinking (why a metric matters, not just how to calculate it) creates portfolio projects that show both technical and analytical maturity.

### 🏁 Conclusions

This project demonstrates how structured SQL analysis can uncover actionable career insights:
🧠 SQL + Python + BI form the modern Data Analyst foundation.
☁️ Cloud & automation skills (Snowflake, Airflow, Azure, AWS) unlock higher salary tiers and growth toward Data Engineering.
📈 Market-driven learning is key — prioritize skills with both high demand and high pay potential.
💬 Translating SQL results into strategy (for career or business) is the hallmark of a true data professional.
🎓 Next step: Turn this analysis into a live dashboard or Power BI report showing salary vs demand trends —
transforming data into a visual narrative for employers and recruiters.
