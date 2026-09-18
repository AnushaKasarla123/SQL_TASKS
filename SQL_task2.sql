
use 106r;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    age INT,
    city VARCHAR(30),
    joining_date DATE,
    manager_id INT
);

INSERT INTO employees VALUES
(101, 'Ramesh', 'HR', 35000, 25, 'Hyderabad', '2022-01-15', NULL),
(102, 'Suresh', 'IT', 60000, 28, 'Bangalore', '2021-03-20', 105),
(103, 'Priya', 'Finance', 55000, 30, 'Chennai', '2020-07-10', 106),
(104, 'Anil', 'IT', 75000, 32, 'Hyderabad', '2019-05-18', 105),
(105, 'Kiran', 'IT', 90000, 35, 'Bangalore', '2018-02-25', NULL),
(106, 'Meena', 'Finance', 85000, 34, 'Chennai', '2017-11-12', NULL),
(107, 'Raj', 'HR', 40000, 26, 'Mumbai', '2023-01-05', 101),
(108, 'Sneha', 'Sales', 50000, 29, 'Hyderabad', '2021-09-15', 109),
(109, 'Arjun', 'Sales', 70000, 31, 'Mumbai', '2019-08-20', NULL),
(110, 'Divya', 'Marketing', 45000, 27, 'Pune', '2022-06-11', 111),
(111, 'Vijay', 'Marketing', 80000, 36, 'Pune', '2016-04-30', NULL),
(112, 'Kavya', 'IT', 65000, 29, 'Chennai', '2022-10-10', 105);


-- 1. Display all records
SELECT * FROM employees;

-- 2. Display emp_name, salary, department
SELECT emp_name, salary, department FROM employees;

-- 3. Salary greater than 50,000
SELECT * FROM employees WHERE salary > 50000;

-- 4. Age less than 30
SELECT * FROM employees WHERE age < 30;

-- 5. Employees in IT department
SELECT * FROM employees WHERE department = 'IT';

-- 6. Employees living in Hyderabad
SELECT * FROM employees WHERE city = 'Hyderabad';

-- 7. Salary between 40,000 and 70,000
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 70000;

-- 8. Employees in IT or Finance
SELECT * FROM employees WHERE department IN ('IT', 'Finance');

-- 9. Employees whose city is not Mumbai
SELECT * FROM employees WHERE city <> 'Mumbai';

-- 10. Salary > 60,000 and age > 30
SELECT * FROM employees WHERE salary > 60000 AND age > 30;

-- 11. Names starting with S
SELECT * FROM employees WHERE emp_name LIKE 'S%';

-- 12. Names ending with a
SELECT * FROM employees WHERE emp_name LIKE '%a';

-- 13. Names containing i
SELECT * FROM employees WHERE emp_name LIKE '%i%';

-- 21. Total number of employees
SELECT COUNT(*) AS total_employees FROM employees;

-- 22. Maximum salary
SELECT MAX(salary) AS maximum_salary FROM employees;

-- 23. Minimum salary
SELECT MIN(salary) AS minimum_salary FROM employees;

-- 24. Average salary
SELECT AVG(salary) AS average_salary FROM employees;

-- 25. Total salary paid
SELECT SUM(salary) AS total_salary FROM employees;

-- 26. Number of employees in each department
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department;

-- 27. Average salary of each department
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department;

-- 28. Maximum salary in each department
SELECT department, MAX(salary) AS maximum_salary FROM employees GROUP BY department;

-- 29. Minimum salary in each department
SELECT department, MIN(salary) AS minimum_salary FROM employees GROUP BY department;

-- 30. Departments having more than 2 employees
SELECT department, COUNT(*) AS employee_count FROM employees GROUP BY department HAVING COUNT(*) > 2;

-- 31. Departments where average salary > 60,000
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department HAVING AVG(salary) > 60000;

-- 32. Departments where maximum salary > 80,000
SELECT department, MAX(salary) AS maximum_salary FROM employees GROUP BY department HAVING MAX(salary) > 80000;

-- 33. Number of employees in each city
SELECT city, COUNT(*) AS employee_count FROM employees GROUP BY city;

-- 34. Average salary for each city
SELECT city, AVG(salary) AS average_salary FROM employees GROUP BY city;

-- 35. Categorize employees by salary
SELECT emp_name, salary, CASE WHEN salary >= 80000 THEN 'High' WHEN salary >= 50000 THEN 'Medium' ELSE 'Low' END AS salary_category FROM employees;

-- 36. Count employees in each salary category
SELECT CASE WHEN salary >= 80000 THEN 'High' WHEN salary >= 50000 THEN 'Medium' ELSE 'Low' END AS salary_category, COUNT(*) AS employee_count FROM employees GROUP BY CASE WHEN salary >= 80000 THEN 'High' WHEN salary >= 50000 THEN 'Medium' ELSE 'Low' END;

-- 37. Categorize employees by age
SELECT emp_name, age, CASE WHEN age >= 35 THEN 'Senior' WHEN age >= 30 THEN 'Experienced' ELSE 'Junior' END AS experience_level FROM employees;

-- 38. Display employee salary status
SELECT emp_name, salary, CASE WHEN salary >= 70000 THEN 'Excellent' WHEN salary >= 50000 THEN 'Good' ELSE 'Needs Improvement' END AS salary_status FROM employees;

-- 14. Salary not equal to 50,000
SELECT * FROM employees WHERE salary <> 50000;

-- 15. Employees without a manager
SELECT * FROM employees WHERE manager_id IS NULL;

-- 16. Employees who have a manager
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- 17. Salary highest to lowest
SELECT * FROM employees ORDER BY salary DESC;

-- 18. Age lowest to highest
SELECT * FROM employees ORDER BY age ASC;

-- 19. Top 5 highest-paid employees
SELECT * FROM employees ORDER BY salary DESC LIMIT 5;

-- 20. Department ascending, salary descending
SELECT * FROM employees ORDER BY department ASC, salary DESC;

-- 39. Department with the highest average salary
SELECT department, AVG(salary) AS average_salary FROM employees GROUP BY department ORDER BY average_salary DESC LIMIT 1;

-- 40. City having the highest number of employees
SELECT city, COUNT(*) AS employee_count FROM employees GROUP BY city ORDER BY employee_count DESC LIMIT 1;