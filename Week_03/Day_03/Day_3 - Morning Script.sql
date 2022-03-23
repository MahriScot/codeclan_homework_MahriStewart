
--HAVING 

SELECT 
    avg(salary) AS avg_salary
FROM employees
WHERE avg_salary < 30000
GROUP BY country;

-- ^ doesn't work as avg_salary doesn't exist early enough, so let's try

SELECT 
    avg(salary) AS avg_salary
FROM employees
WHERE avg(salary) < 30000
GROUP BY country;
--^doesn't work becayse of an aggregate function in WHERE... so instead of 
-- WHERE, let's try having 

SELECT 
    avg(salary) AS avg_salary
FROM employees
GROUP BY country
HAVING avg(salary) < 30000;
^YAY

-- HAVING multiple expressions: 

SELECT 
    avg(salary) AS avg_salary,
    min(salary) AS min_salary
FROM employees
GROUP BY country
HAVING avg(salary) < 30000 AND 
        min(salary) > 22000;

