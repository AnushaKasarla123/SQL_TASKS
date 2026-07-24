CREATE DATABASE CompanyDB;
USE CompanyDB;
CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    Emp_name VARCHAR(50),
    Emp_role VARCHAR(50),
    Emp_salary DECIMAL(10,2)
);


INSERT INTO Employee
VALUES
(120, 'Anusha', 'Developer', 50000.00),
(121, 'Rahul', 'Tester', 45000.00),
(122, 'Sneha', 'HR', 40000.00),
(123, 'Kiran', 'Support Engineer', 42000.00),
(124, 'Ravi', 'Intern', 25000.00);
Select * from Employee;

UPDATE Employee
SET Emp_role = 'IT Support Specialist'
WHERE Emp_id = 120;
UPDATE Employee
SET Emp_name = 'Hari'
WHERE Emp_id = 124;
UPDATE Employee
SET Emp_salary = 90000.00
WHERE Emp_id = 124;
UPDATE Employee
SET Emp_role = 'Software Engineer'
WHERE Emp_id = 124;
DELETE FROM Employee
WHERE Emp_id = 123;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_name VARCHAR(50),
    order_price DECIMAL(10,2),
    status VARCHAR(50)
);

SELECT * FROM orders;

INSERT INTO orders
VALUES
(130, 'Laptop', 40000.66, 'Delivered');

INSERT INTO orders
VALUES
(131, 'Smart_phone', 90000.00, 'Delivered'),
(132, 'TV', 60000.00, 'Not delivered'),
(133, 'Washing Machine', 70000.00, 'Delivered');

UPDATE orders
SET order_price = 60000.00;

SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET order_name = 'TV'
WHERE order_id = 132;

DELETE FROM orders
WHERE order_id = 133;

DELETE FROM orders;
SELECT * FROM orders;

