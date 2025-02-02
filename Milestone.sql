Create database milestone;
use milestone;

select * from salary_details_csv;

-- 1.Average Salary by Industry and Gender

select Industry,Gender,round(avg(Annual_salary),2) as Avg_Salary from salary_details_csv
group by gender,Industry
order by Avg_salary desc;
/* 
women working in museums recievs less avg salary
while man working as ESL teacher recieves high avg salary
*/

-- 2.Total Salary Compensation by Job Title

Select Job_title, sum(additional_monetary_compensation) as Total_Salary_Compensation
from salary_details_csv
group by Job_Title
order by Total_Salary_Compensation desc;
/*
Regional Operations & Training Manager has high compensation
*/

-- 3.Salary Distribution by Education Level

Select Qualification, round(avg(annual_salary),2) as Avg_Salary,
min(annual_salary) as Min_Salary,
max(annual_salary) as Max_Salary,
abs(min(annual_salary) -max(annual_salary)) as Distribution
from salary_details_csv
group by Qualification
order by distribution desc;
/* College degree has the highest distribution */

-- 4.Number of Employees by Industry and Years of Experience

Select Industry, Professional_experience, count(age_range) as No_of_Employees
from salary_details_csv
group by Professional_Experience,Industry
order by No_of_Employees desc;

/* Computing or tech has the highest number of employees 
People working in Zoos where the minimum*/

-- 5.Median Salary by Age Range and Gender

WITH RankedSalaries AS (
    SELECT 
        Annual_salary,
        age_range,
        gender,
        ROW_NUMBER() OVER (PARTITION BY age_range, gender ORDER BY Annual_salary) AS row_num,
        COUNT(*) OVER (PARTITION BY age_range, gender) AS total_count
    FROM salary_details_csv
)
SELECT age_range, gender,
       CASE 
           WHEN total_count % 2 = 1 THEN
		
               MAX(CASE WHEN row_num = (total_count + 1) / 2 THEN Annual_salary END) 
           ELSE
	
              AVG(CASE WHEN row_num IN (total_count / 2, total_count / 2 + 1) THEN Annual_salary END)
       END AS median_salary
FROM RankedSalaries
GROUP BY age_range, gender
ORDER BY age_range;

/*
Among experienced people man gets high salary when compared to women whereas in younger generations it is viceversa
*/

-- 6.Job Titles with the Highest Salary in Each Country

SELECT country, job_title, MAX(annual_salary) AS Highest_Salary
FROM salary_details_csv
GROUP BY Job_Title
ORDER BY Highest_Salary Desc;

/* investment banking analyst has max and online tutor has min */

-- 7.Average Salary by City and Industry

Select City, Industry, avg(annual_salary) as Avg_salary
from salary_details_csv
group by Industry
order by Avg_salary desc;

/* ESL teachers from Seoul has the highest avg salary and museum in universty affliated has minimum */

-- 8.Percentage of Employees with Additional Monetary Compensation by Gender

Select Gender, 
round(((count(case when Additional_Monetary_Compensation>0 then age_range end)/count(age_range))*100),2) as Percentage_of_Employees
from salary_details_csv
group by gender ;

/* men gets more compensations than others */

-- 9.Total Compensation by Job Title and Years of Experience

select job_title,Professional_experience,
sum(Additional_Monetary_Compensation) as Total_Compensation
from salary_details_csv
group by Professional_experience
order by total_compensation desc;

/* 
1st Line ICT Support Analyst has the highest compensation while Accounts
manager has least
*/

-- 10.Average Salary by Industry, Gender, and Education Level

Select Industry,Gender,Qualification,avg(annual_salary) as Avg_Salary
from salary_details_csv
group by industry,gender,Qualification
order by Avg_salary desc;

/*
A man with college degree receives high avg salary
*/