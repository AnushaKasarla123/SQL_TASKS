
use college_management;
CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2)
);
INSERT INTO Employees VALUES
(101, 'Anusha', 25000),
(102, 'Rahul', 30000),
(103, 'Priya', 28000);
SELECT * FROM Employees;
SET SQL_SAFE_UPDATES = 0;
UPDATE Employees
SET Salary = Salary + 5000
WHERE EmpId = 101;

UPDATE Employees
SET Salary = Salary - 2000
WHERE EmpId = 102;

UPDATE Employees
SET Salary = Salary * 1.10
WHERE EmpId = 103;

 UPDATE Employees
SET Salary = Salary / 2
WHERE EmpId = 102;

SELECT * FROM Employees;
 

