

/* MVP Question 1.
 * 
(a). Find the first name, last name and team name of employees who are members 
of teams.
Hint
*/

SELECT 
    e.first_name, 
    e.last_name, 
    t.name AS team 
FROM employees AS e 
INNER JOIN teams AS t
ON e.team_id = t.id;


/*
(b). Find the first name, last name and team name of employees who are members 
of teams and are enrolled in the pension scheme.
*/

SELECT 
    e.first_name, 
    e.last_name, 
    t.name AS team 
FROM employees AS e 
RIGHT JOIN teams AS t
ON e.team_id = t.id
WHERE e.pension_enrol = TRUE;

/*
(c). Find the first name, last name and team name of employees who are members 
of teams, where their team has a charge cost greater than 80.
Hint
*/

SELECT 
    e.first_name, 
    e.last_name, 
    t.name AS team,
    t.charge_cost
FROM employees AS e 
RIGHT JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS int) > 80;




/* MVP Question 2.
(a). Get a table of all employees details, together with their 
local_account_no and local_sort_code, if they have them.

Hints
local_account_no and local_sort_code are fields in pay_details, and employee 
details are held in employees, so this query requires a JOIN.

What sort of JOIN is needed if we want details of all employees, even if they 
don’t have stored local_account_no and local_sort_code?
*/

SELECT 
    e.*, 
    pd.local_account_no, 
    pd.local_sort_code
FROM employees AS e 
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id;



/* MVP Q2.
(b). Amend your query above to also return the name of the team that each 
employee belongs to.

Hint
*The name of the team is in the teams table, so we will need to do another 
*join.
**/

SELECT 
    e.*, 
    pd.local_account_no, 
    pd.local_sort_code,
    t.name AS team
FROM (employees AS e 
    LEFT JOIN pay_details AS pd
    ON e.pay_detail_id = pd.id)
INNER JOIN teams AS t
ON e.team_id = t.id;


/* MVP Question 3.
(a). Make a table, which has each employee id along with the team that 
employee belongs to.
*/

SELECT 
    e.id,
    t.name AS team
FROM employees AS e 
LEFT JOIN teams AS t
ON e.team_id = t.id;


/* MVP Q.3
(b). Breakdown the number of employees in each of the teams.

Hint
*/

SELECT 
    count(e.id) AS number_of_employees,
    t.name AS team
FROM employees AS e 
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name;


/* MVP Q.3
(c). Order the table above by so that the teams with the least employees come 
first.
*/

SELECT 
    count(e.id) AS number_of_employees,
    t.name AS team
FROM employees AS e 
LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.name
ORDER BY count(e.id) ASC;


/* MVP Question 4.
(a). Create a table with the team id, team name and the count of the number of 
employees in each team.
*/

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    count(e.id) AS number_of_employees
FROM employees AS e 
RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;


/* q.4
(b). The total_day_charge of a team is defined as the charge_cost of the team 
multiplied by the number of employees in the team. Calculate the 
total_day_charge for each team.

Hint
*/

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    t.charge_cost,
    count(e.id) AS number_of_employees,
    (CAST(t.charge_cost AS int)) * count(e.id) AS total_day_charge 
FROM employees AS e 
RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;


/* Q4.
(c). How would you amend your query from above to show only those teams with a 
total_day_charge greater than 5000?
*/

SELECT 
    t.id AS team_id,
    t.name AS team_name,
    t.charge_cost,
    count(e.id) AS number_of_employees,
    (CAST(t.charge_cost AS int)) * count(e.id) AS total_day_charge 
FROM employees AS e 
RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
HAVING ((CAST(t.charge_cost AS int)) * count(e.id)) > 5000;



/* EXTENSION Question 5.
How many of the employees serve on one or more committees?

Hints
All of the details of membership of committees is held in a single table: 
employees_committees, so this doesn’t require a join.

Some employees may serve in multiple committees. Can you find the number of 
distinct employees who serve? [Extra hint - do some research on the DISTINCT() 
function].
*/

SELECT 
    ec.committee_id AS committee,
    count(DISTINCT employee_id) AS number_of_employees
FROM employees_committees AS ec
GROUP BY ec.committee_id;

/* I can see the answer is 22 employees (2 are in 2 committees) but this shows 
5 employees in committees 1,2,3 and 5, and 4 employees in committee 4... but 
some of these employees are on 2 committees, so I've got more to do
*/

-- answer from class -i got it but added too much 

SELECT 
    count(DISTINCT employee_id) AS number_of_employees
FROM employees_committees AS ec;


/* EXTENSION Question 6.
How many of the employees do not serve on a committee?
*/

SELECT
    ec.committee_id,
    count(e.id) AS number_of_employees
FROM employees AS e 
LEFT JOIN employees_committees AS ec 
ON e.id = ec.employee_id
GROUP BY ec.committee_id;

-- ^ 978 do not serve on a committee 

