-- Day 1 SQL Practice
-- Window Functions

-- ROW_NUMBER
SELECT name, department, salary,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;

-- RANK vs DENSE_RANK
SELECT name, department, salary,
RANK()       OVER (ORDER BY salary DESC) AS rnk,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees;

-- LAG and LEAD
SELECT name, hire_date, salary,
LAG(salary, 1)  OVER (ORDER BY hire_date) AS prev_hire_salary,
LEAD(salary, 1) OVER (ORDER BY hire_date) AS next_hire_salary
FROM employees;

-- NTILE
SELECT name, department, salary,
NTILE(3) OVER (ORDER BY salary DESC) AS salary_tier
FROM employees;

-- Top 2 per department
WITH ranked AS (
    SELECT name, department, salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT name, department, salary FROM ranked WHERE rnk <= 2;

-- CTEs
WITH TopEmp AS (
    SELECT name, department, salary,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
SELECT name, department, salary FROM TopEmp WHERE rnk = 1;

-- Above average salary
WITH dept_avg AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees GROUP BY department
),
above_avg AS (
    SELECT e.name, e.department, e.salary, d.avg_salary
    FROM employees e
    JOIN dept_avg d ON e.department = d.department
    WHERE e.salary > d.avg_salary
)
SELECT * FROM above_avg;

-- Anti Join
SELECT e.name, e.department
FROM employees e
LEFT JOIN employees m ON e.employee_id = m.manager_id
WHERE m.employee_id IS NULL;

-- Subquery
SELECT name, salary FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- PIVOT
SELECT
    ROUND(AVG(CASE WHEN department = 'Engineering' THEN salary END), 2) AS Engineering,
    ROUND(AVG(CASE WHEN department = 'Marketing'   THEN salary END), 2) AS Marketing,
    ROUND(AVG(CASE WHEN department = 'HR'          THEN salary END), 2) AS HR
FROM employees;