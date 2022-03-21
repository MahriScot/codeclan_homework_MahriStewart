/* 1 MVP
 */


/* MVP Question 1.
Find all the employees who work in the ‘Human Resources’ department.
*/

SELECT * 
FROM employees 
WHERE department = 'Human Resources';
-- there are 90 employees 


/* 
 MVP Question 2.
Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.
 */

SELECT 
    first_name, 
    last_name, 
    country, 
    department 
FROM employees 
WHERE department = 'Legal';



/* 
 MVP Question 3.
Count the number of employees based in Portugal.
 */

SELECT 
    count(country)
FROM employees 
WHERE country = 'Portugal';

-- 29, I think 


/* 
 MVP Question 4.
Count the number of employees based in either Portugal or Spain.
 */

SELECT 
    count(country)
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';
-- 35 



/* 
 MVP Question 5.
Count the number of pay_details records lacking a local_account_no.
Hint
Run a query first to get some records in the pay_details table, just to see what
 the data looks like
 */

SELECT 
count(id)
FROM pay_details
WHERE local_account_no IS NULL; 
-- 25 


/* 
 MVP Question 6.
Are there any pay_details records lacking both a local_account_no and iban number?
*/

SELECT * 
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL; 
-- No


/* 
 MVP 
Question 7.
Get a table with employees first_name and last_name ordered alphabetically by 
last_name (put any NULLs last).
 */ 

SELECT 
    first_name, 
    last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST; 



/* 
 * MVP Question 8.
Get a table of employees first_name, last_name and country, ordered 
alphabetically first by country and then by last_name (put any NULLs last).
 */

SELECT 
    first_name, 
    last_name, 
    country 
FROM employees 
ORDER BY country ASC NULLS LAST, 
    last_name ASC NULLS LAST; 



/* 
 * MVP Question 9.
Find the details of the top ten highest paid employees in the corporation.
*/

SELECT * 
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;



/* 
 * MVP Question 10.
Find the first_name, last_name and salary of the lowest paid employee in Hungary.
*/

SELECT 
    first_name, 
    last_name, 
    salary,
    country 
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- there's only one anyway but it's Eveline Canton = 20,519 


/* 
 * MVP Question 11.
How many employees have a first_name beginning with ‘F’?
 */

SELECT 
    count(first_name)
FROM employees 
WHERE first_name ~ '^[F].';

-- 30 


/* 
MVP Question 12.
Find all the details of any employees with a ‘yahoo’ email address?
*/

SELECT * 
FROM employees 
WHERE email ~ '.yahoo.';

-- 5 with the email yahoo 

/* 
 * MVP Question 13. Count the number of pension enrolled employees not based 
 * in either France or Germany.
 */

SELECT 
    count(id)
FROM employees 
WHERE (country != 'France' AND country != 'Germany') AND 
    (pension_enrol = TRUE);

-- 475


/* 
 * MVP Question 14.
What is the maximum salary among those employees in the ‘Engineering’ 
department who work 1.0 full-time equivalent hours (fte_hours)?
 */

SELECT 
    max(salary) AS max_salary
FROM employees
WHERE department = 'Engineering' AND 
    fte_hours >= 1;

-- 83,370



/* 
 * MVP Question 15.
Return a table containing each employees first_name, last_name, full-time 
equivalent hours (fte_hours), salary, and a new column effective_yearly_salary 
which should contain fte_hours multiplied by salary.
 */

SELECT 
    first_name, 
    last_name, 
    fte_hours, 
    salary,
    (fte_hours * salary) AS effective_yearly_salary
FROM employees
WHERE fte_hours IS NOT NULL AND salary IS NOT NULL; 



/* 
 * Extension
 * Question 16.
The corporation wants to make name badges for a forthcoming conference. 
Return a column badge_label showing employees’ first_name and last_name joined 
together with their department in the following style: ‘Bob Smith - Legal’. 
Restrict output to only those employees with stored first_name, last_name and 
department.
*/

SELECT 
    first_name, 
    last_name, 
    department,
concat(first_name, ' ', last_name, ' - ', department) AS badge_label   
FROM employees
WHERE first_name IS NOT NULL AND 
    last_name IS NOT NULL AND 
    department IS NOT NULL; 


/* Extension 
 * Question 17.
One of the conference organisers thinks it would be nice to add the year of 
the employees’ start_date to the badge_label to celebrate long-standing 
colleagues, in the following style ‘Bob Smith - Legal (joined 1998)’. 
Further restrict output to only those employees with a stored start_date.

[If you’re really keen - try adding the month as a string: ‘Bob Smith - Legal 
(joined July 1998)’]

Hints
- Do some research on the SQL EXTRACT() function.
- For the extension to the extension (!), the PostgreSQL TO_CHAR() function might help.
- To be honest, date and time handling is one of the areas in which the 
functionality of specific RDBMSs deviates most notably from the ANSI SQL standard.
 */

-- To get the year:
SELECT 
    first_name, 
    last_name, 
    department,
    start_date,
concat(first_name, ' ', last_name, ' - ', department, 
    ' (joined ', (EXTRACT(YEAR FROM start_date)), ')') 
    AS badge_label   
FROM employees
WHERE first_name IS NOT NULL AND 
    last_name IS NOT NULL AND 
    department IS NOT NULL AND 
    start_date IS NOT NULL;


-- to get month and year
SELECT 
    first_name, 
    last_name, 
    department,
    start_date,
concat(first_name, ' ', last_name, ' - ', department, 
    ' (joined ', (TO_CHAR(start_date, 'Month YYYY')), ')') 
    AS badge_label   
FROM employees
WHERE first_name IS NOT NULL AND 
    last_name IS NOT NULL AND 
    department IS NOT NULL AND 
    start_date IS NOT NULL;

-- some of them have a huge space between month and year, but it works otherwise



/*
 * Extension 
 * Question 18.
Return the first_name, last_name and salary of all employees together with a new
column called salary_class with a value 'low' where salary is less than 40,000 
and value 'high' where salary is greater than or equal to 40,000.

Hints
- Investigate how to use a SQL CASE statement to return the required values 
'low' and 'high' based on the value of salary.
- Think carefully how to deal with NULL salaries.
  */

SELECT
    first_name, 
    last_name, 
    salary, 
CASE 
    WHEN salary IS NULL THEN 'NA'
    WHEN salary >= 40000 THEN 'high'
    ELSE 'low'    
    END AS salary_class
FROM employees;

