
create database 106r;
use 106r;

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
);

CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50)
);

INSERT INTO Department (DepartmentID, DepartmentName, Location) VALUES
(1, 'HR', 'Hyderabad'),
(2, 'Finance', 'Bangalore'),
(3, 'IT', 'Hyderabad'),
(4, 'Marketing', 'Chennai');
INSERT INTO Employee (EmployeeID, FirstName, LastName, Department, Salary, HireDate) VALUES
(1, 'John', 'Doe', 'HR', 50000, '2020-01-15'),
(2, 'Jane', 'Smith', 'Finance', 60000, '2018-03-12'),
(3, 'Sam', 'Brown', 'IT', 75000, '2019-05-22'),
(4, 'Lucy', 'Jones', 'HR', 53000, '2021-07-11'),
(5, 'Mike', 'Taylor', 'Finance', 65000, '2017-09-23'),
(6, 'Sara', 'Miller', 'IT', 78000, '2018-06-30');


-- QURIES ON JIONS 
SELECT e.FirstName, e.Salary, d.Location
 FROM Employee e
JOIN Department d
ON e.Department = d.DepartmentName;

ALTER TABLE Employee
ADD DepartmentID INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE Employee
SET DepartmentID = 1
WHERE Department = 'HR';

UPDATE Employee
SET DepartmentID = 2
WHERE Department = 'Finance';

UPDATE Employee
SET DepartmentID = 3
WHERE Department = 'IT';

SET SQL_SAFE_UPDATES = 1;
SELECT EmployeeID, FirstName, Department, DepartmentID
FROM Employee;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (DepartmentID)
REFERENCES Department(DepartmentID);

SELECT
    e.FirstName,
    e.LastName,
    e.Salary,
    d.DepartmentName,
    d.Location
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID;


DESCRIBE Employee;

SELECT e.FirstName, d.DepartmentName
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID;

SELECT e.FirstName, e.Salary, d.DepartmentName
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID;

SELECT e.FirstName, d.Location
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID;

SELECT 
    e.FirstName,
    e.Salary,
    d.DepartmentName,
    d.Location
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID; 

SELECT e.FirstName, e.Salary, d.DepartmentName
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT'; 

SELECT e.FirstName, e.Salary, d.DepartmentName
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 60000; 

SELECT e.FirstName, e.Salary, d.Location
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE d.Location = 'Hyderabad'
AND e.Salary > 50000; 

SELECT e.FirstName, e.LastName, e.Salary
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Finance';  

SELECT e.FirstName, e.Salary, d.DepartmentName
FROM Employee e
INNER JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary BETWEEN 50000 AND 70000; 

SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;  

SELECT 
    d.DepartmentName,
    AVG(e.Salary) AS AverageSalary
FROM Department d
LEFT JOIN Employee e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;