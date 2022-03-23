
/* 
Question 1.
How many employee records are lacking both a grade and salary?
*/

SELECT 
    count(e.id)
FROM employees AS e 
WHERE grade IS NULL AND salary IS NULL;

--^ there are 2 


/* 
Question 2.
Produce a table with the two following fields (columns):

the department
the employees full name (first and last name)
Order your resulting table alphabetically by department, and then by last name
*/ 

SELECT 
    department, 
    concat(first_name, ' ', last_name) AS full_name
FROM employees
ORDER BY department ASC NULLS LAST, last_name ASC NULLS LAST;


/*
Question 3.
Find the details of the top ten highest paid employees who have a last_name beginning with ‘A’.
*/

SELECT
    last_name,
    salary
FROM employees 
WHERE last_name LIKE 'A%' 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;

-- or are you asking for.... 

SELECT
    *
FROM employees 
WHERE last_name LIKE 'A%' 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;
    
/* 
Question 4.
Obtain a count by department of the employees who started work with the corporation in 2003.
*/

SELECT 
    count(id),
    department
FROM employees 
WHERE start_date >= '2003-01-01' AND start_date <= '2003-12-31'
GROUP BY department;


SELECT 
    count(id),
    department
FROM employees
WHERE EXTRACT(YEAR FROM start_date) = 2003
GROUP BY department;


/*
Question 5.
Obtain a table showing department, fte_hours and the number of employees in 
each department who work each fte_hours pattern. Order the table alphabetically 
by department, and then in ascending order of fte_hours.
Hint
*/

SELECT 
    department,  
    fte_hours,
    count(id) AS num_of_employees
FROM employees 
GROUP BY department, fte_hours
ORDER BY department, fte_hours;



/*
Question 6.
Provide a breakdown of the numbers of employees enrolled, not enrolled, and with 
unknown enrollment status in the corporation pension scheme.
*/

SELECT 
    pension_enrol,
    count(id) AS number_of_employees
FROM employees 
GROUP BY pension_enrol;

-- there are 488 employees enrolled, 470 not enrolled, and 42 with an unknown 
-- enrollment status


/*
Question 7.
Obtain the details for the employee with the highest salary in the ‘Accounting’ 
department who is not enrolled in the pension scheme?
*/

SELECT *
FROM employees 
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

-- it is Jessalin Gobbet with a salary of 99,551


/*
Question 8.
Get a table of country, number of employees in that country, and the average 
salary of employees in that country for any countries in which more than 30 
employees are based. Order the table by average salary descending.

Hints
A HAVING clause is needed to filter using an aggregate function.

You can pass a column alias to ORDER BY.
*/

SELECT 
    country, 
    count(id) AS num_of_employees,
    round(avg(salary), 2) AS avg_salary
FROM employees 
GROUP BY country
HAVING count(id) > 30
ORDER BY avg(salary) DESC NULLS LAST;

-- There are 6 countries 
    

/*
Question 9.
Return a table containing each employees first_name, last_name, full-time 
equivalent hours (fte_hours), salary, and a new column effective_yearly_salary 
which should contain fte_hours multiplied by salary. Return only rows where 
effective_yearly_salary is more than 30000.
*/

SELECT 
    first_name, 
    last_name, 
    fte_hours, 
    salary, 
    (fte_hours * salary) AS effective_yearly_salary
FROM employees
WHERE (fte_hours * salary) > 30000;


    
    
    
/*
Question 10
Find the details of all employees in either Data Team 1 or Data Team 2
Hint
name is a field in table `teams
*/

SELECT 
    *
FROM employees AS e 
INNER JOIN teams AS t 
ON e.team_id = t.id
WHERE t.name = 'Data Team 1' OR t.name = 'Data Team 2';
-- WHERE t.name LIKE 'Data Team%';

-- 195 employees 



/*
Question 11
Find the first name and last name of all employees who lack a local_tax_code.

Hint
local_tax_code is a field in table pay_details, and first_name and last_name are 
fields in table employees
*/

SELECT 
    first_name, 
    last_name, 
    local_tax_code
FROM employees AS e 
LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 
WHERE local_tax_code IS NULL AND first_name IS NOT NULL;

-- 59 employees
-- one of the employees has a NULL for a first_name otherwise it would be 60



/*
Question 12.
The expected_profit of an employee is defined as 
(48 * 35 * charge_cost - salary) * fte_hours, 
where charge_cost depends upon the team to which the employee belongs. 
Get a table showing expected_profit for each employee.

Hints
charge_cost is in teams, while salary and fte_hours are in employees, so a join 
will be necessary

You will need to change the type of charge_cost in order to perform the calculation
*/

SELECT 
    e.first_name, 
    (48 * 35 * CAST(t.charge_cost AS int)- e.salary) * e.fte_hours AS expected_profit
FROM employees AS e
LEFT JOIN teams AS t
ON e.team_id = t.id 
ORDER BY expected_profit DESC NULLS LAST;
 

/*
Question 13. [Tough]
Find the first_name, last_name and salary of the lowest paid employee in Japan 
who works the least common full-time equivalent hours across the corporation.”

Hint
You will need to use a subquery to calculate the mode
*/

SELECT 
    first_name, 
    last_name, 
    salary 
FROM employees 
WHERE country = 'Japan' AND fte_hours = (
    SELECT 
        fte_hours 
    FROM employees 
    GROUP BY fte_hours 
    ORDER BY COUNT(*) ASC NULLS LAST 
    LIMIT 1
) 
ORDER BY salary ASC NULLS LAST
LIMIT 1;

--alternative 

SELECT 
    first_name,
    last_name,
    salary
FROM employees 
WHERE country = 'Japan' AND 
      fte_hours = (
            SELECT 
            fte_hours 
            FROM employees 
            GROUP BY fte_hours 
            ORDER BY count(fte_hours) ASC 
            LIMIT 1)
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

    



/*
Question 14.
Obtain a table showing any departments in which there are two or more employees 
lacking a stored first name. Order the table in descending order of the number 
of employees lacking a first name, and then in alphabetical order by department.
*/

SELECT 
    department,
    count(id) AS num_of_employees
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING count(id) >= 2
ORDER BY count(id) DESC NULLS FIRST, department ASC;



/*
Question 15. [Bit tougher]
Return a table of those employee first_names shared by more than one employee, 
together with a count of the number of times each first_name occurs. Omit 
employees without a stored first_name from the table. Order the table descending 
by count, and then alphabetically by first_name.
*/

SELECT 
    count(id) AS num_of_employees,
    first_name 
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name 
HAVING count(id) > 1
ORDER BY count(id) DESC, first_name ASC;

--^ there are 52 names shared by 2 or more employees 

/*
Question 16. [Tough]
Find the proportion of employees in each department who are grade 1.
Hints
*/

--ran through in class
-- step 1 

SELECT 
    department,
    sum(CAST(grade = '1' AS int))
FROM employees 
GROUP BY department 

-- step 2 
SELECT 
    department,
    sum(CAST(grade = '1' AS int)) / 
        CAST(count(id) AS REAL) AS prop_grade_1
FROM employees 
GROUP BY department



/*
Extension

Some of these problems may need you to do some online research on SQL statements 
we haven’t seen in the lessons up until now… Don’t worry, we’ll give you 
pointers, and it’s good practice looking up help and answers online, data 
analysts and programmers do this all the time! If you get stuck, it might also 
help to sketch out a rough version of the table you want on paper (the column 
headings and first few rows are usually enough).

Note that some of these questions may be best answered using CTEs or window 
functions: have a look at the optional lesson included in today’s notes!
*/


/*
Question 1. [Tough]
Get a list of the id, first_name, last_name, department, salary and fte_hours 
of employees in the largest department. Add two extra columns showing the ratio 
of each employee’s salary to that department’s average salary, and each 
employee’s fte_hours to that department’s average fte_hours.

[Extension - "really tough!" after - how could you generalise your query to be able to 
handle the fact that two or more departments may be tied in their counts of 
employees. In that case, we probably don’t want to arbitrarily return details 
for employees in just one of these departments].

Hints
Writing a CTE to calculate the name, average salary and average fte_hours of 
the largest department is an efficient way to do this.

Another solution might involve combining a subquery with window functions
CTE solution
*/

-- (from answer sheet) 
-- CTE solution
WITH biggest_dept_details(name, avg_salary, avg_fte_hours) AS (
  SELECT 
     department,
     AVG(salary),
     AVG(fte_hours)
  FROM employees
  GROUP BY department
  ORDER BY COUNT(id) DESC NULLS LAST
  LIMIT 1
)
SELECT
  e.id,
  e.first_name,
  e.last_name,
  e.department,
  e.salary,
  e.fte_hours,
  e.salary / bdd.avg_salary AS salary_over_dept_avg,
  e.fte_hours / bdd.avg_fte_hours AS fte_hours_over_dept_avg
FROM employees AS e INNER JOIN biggest_dept_details AS bdd
ON  e.department = bdd.name

-- Window function solution  (from answer sheet)
SELECT 
    id, 
    first_name, 
    last_name, 
    department,
    salary,
    fte_hours,
    salary / AVG(salary) OVER () AS salary_over_dept_avg,
    fte_hours / AVG(fte_hours) OVER () AS fte_hours_over_dept_avg
FROM employees
WHERE department = (
  SELECT
    department
  FROM employees
  GROUP BY department
  ORDER BY COUNT(id) DESC NULLS LAST
  LIMIT 1
);

/* Extension Q1's extension
 * [Extension - "really tough!" after - how could you generalise your query to be able to 
handle the fact that two or more departments may be tied in their counts of 
employees. In that case, we probably don’t want to arbitrarily return details 
for employees in just one of these departments].
 */

-- CTE solution for ties (from answer sheet)

WITH all_dept_details(name, count, avg_salary, avg_fte_hours) AS (
  SELECT
    department,
    COUNT(id),
    AVG(salary),
    AVG(fte_hours)
  FROM employees
  GROUP BY department
), 
biggest_dept_count(max_count) AS (
  SELECT
    MAX(count)
  FROM all_dept_details
),
biggest_dept_details AS (
  SELECT 
    name,
    avg_salary,
    avg_fte_hours
  FROM all_dept_details INNER JOIN biggest_dept_count
  ON all_dept_details.count = biggest_dept_count.max_count
)
SELECT
  e.id,
  e.first_name,
  e.last_name, 
  e.department,
  e.salary,
  e.fte_hours,
  e.salary / bdd.avg_salary AS salary_over_dept_avg,
  e.fte_hours / bdd.avg_fte_hours AS fte_hours_over_dept_avg
FROM employees AS e INNER JOIN biggest_dept_details AS bdd
ON e.department = bdd.name

-- Window function solution for ties (from answer sheet)

SELECT 
    id, 
    first_name, 
    last_name, 
    department,
    salary,
    fte_hours,
    salary / AVG(salary) OVER (PARTITION BY department) AS salary_over_dept_avg,
    fte_hours / AVG(fte_hours) OVER (PARTITION BY department) AS fte_hours_over_dept_avg
FROM employees
WHERE department IN (
  SELECT
    department
  FROM employees
  GROUP BY department
  HAVING COUNT(id) = (
      SELECT
          MAX(count)
      FROM (
          SELECT
              department,
              COUNT(id)
          FROM employees 
          GROUP BY department
      ) AS temp
  )
);

/*
Question 2.
Have a look again at your table for MVP question 6. It will likely contain a 
blank cell for the row relating to employees with ‘unknown’ pension enrollment 
status. This is ambiguous: it would be better if this cell contained ‘unknown’ 
or something similar. Can you find a way to do this, perhaps using a combination 
of COALESCE() and CAST(), or a CASE statement?

Hints
COALESCE() lets you substitute a chosen value for NULLs in a column, e.g. 
COALESCE(text_column, 'unknown') would substitute 'unknown' for every NULL in 
text_column. The substituted value has to match the data type of the column 
otherwise PostgreSQL will return an error.

CAST() let’s you change the data type of a column, e.g. CAST(boolean_column AS 
VARCHAR) will turn TRUE values in boolean_column into text 'true', FALSE to text
 'false', and will leave NULLs as NULL
*/

-- a coalesce and cast solution (from answer sheet but read through)
SELECT 
  COALESCE(CAST(pension_enrol AS VARCHAR), 'unknown') AS pension_enrolled, 
  COUNT(id) AS num_employees
FROM employees
GROUP BY pension_enrol

-- A CASE solution (from answer sheet but read through):

SELECT 
  CASE 
    WHEN pension_enrol IS NULL THEN 'unknown'
    WHEN pension_enrol IS TRUE THEN 'yes' 
    ELSE 'no'
  END AS pension_enrolled, 
  COUNT(id) AS num_employees
FROM employees
GROUP BY pension_enrol


/*
Question 3. Find the first name, last name, email address and start date of all 
the employees who are members of the ‘Equality and Diversity’ committee. Order
 the member employees by their length of service in the company, longest first.
*/

SELECT 
  e.first_name, 
  e.last_name, 
  e.email, 
  e.start_date
FROM employees AS e 
INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
INNER JOIN committees AS c
ON ec.committee_id = c.id
WHERE c.name = 'Equality and Diversity'
ORDER BY e.start_date ASC NULLS LAST

/*Question 4. [Tough!]
Use a CASE() operator to group employees who are members of committees into 
salary_class of 'low' (salary < 40000) or 'high' (salary >= 40000). A NULL 
salary should lead to 'none' in salary_class. Count the number of committee 
members in each salary_class.

Hints
You likely want to count DISTINCT() employees in each salary_class

You will need to GROUP BY salary_class
*/

--(from answer sheet but read through):
SELECT 
  CASE 
    WHEN e.salary < 40000 THEN 'low'
    WHEN e.salary IS NULL THEN 'none'
    ELSE 'high' 
  END AS salary_class,
  COUNT(DISTINCT(e.id)) AS num_committee_members
FROM employees AS e 
INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
INNER JOIN committees AS c
ON ec.committee_id = c.id
GROUP BY salary_class


