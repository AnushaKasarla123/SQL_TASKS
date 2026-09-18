CREATE DATABASE company_db;

USE company_db;

CREATE TABLE employees (id INT PRIMARY KEY, name VARCHAR(100), department VARCHAR(50));

CREATE TABLE salaries (emp_id INT PRIMARY KEY, amount DECIMAL(10,2), effective_date DATE, CONSTRAINT FK_salaries_employees FOREIGN KEY (emp_id) REFERENCES employees(id));

INSERT INTO employees VALUES (101, 'Ramesh', 'HR'), (102, 'Suresh', 'IT'), (103, 'Priya', 'Finance'), (104, 'Anil', 'IT'), (105, 'Kiran', 'Finance'), (106, 'Meena', 'HR');


INSERT INTO salaries VALUES (101, 35000.00, '2024-01-01'), (102, 60000.00, '2024-01-01'), (103, 55000.00, '2024-01-01'), (104, 75000.00, '2024-01-01'), (105, 85000.00, '2024-01-01');

CREATE ROLE hr_manager;

CREATE ROLE finance_analyst;

GRANT SELECT ON employees TO hr_manager;

GRANT SELECT, INSERT, UPDATE ON salaries TO finance_analyst;

GRANT INSERT ON salaries TO finance_analyst;

REVOKE INSERT ON salaries FROM finance_analyst;
START TRANSACTION;

-- Step 1: Insert salary for existing employee
INSERT INTO salaries (emp_id, amount, effective_date)
VALUES (106, 70000.00, '2026-09-18');

-- Step 2: Create savepoint before department update
SAVEPOINT BeforeDepartmentUpdate;

-- Step 3: Update employee department
UPDATE employees
SET department = 'Finance'
WHERE id = 106;

-- Step 4: Intentionally cause an error
-- This fails because emp_id 106 already exists
INSERT INTO salaries (emp_id, amount, effective_date)
VALUES (106, 80000.00, '2026-09-18');

-- Step 5: Roll back only changes after savepoint
ROLLBACK TO SAVEPOINT BeforeDepartmentUpdate;

-- Step 6: Commit remaining changes
COMMIT;