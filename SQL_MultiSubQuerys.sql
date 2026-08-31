
use 106r;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
INSERT INTO Customers (customer_id, name, city, signup_date)
VALUES
(1, 'Anusha', 'Hyderabad', '2024-01-15'),
(2, 'Rahul', 'Hyderabad', '2024-02-20'),
(3, 'Priya', 'Bangalore', '2024-03-10'),
(4, 'Arjun', 'Bangalore', '2024-04-05'),
(5, 'Sneha', 'Chennai', '2024-05-12'),
(6, 'Kiran', 'Mumbai', '2024-06-18'),
(7, 'Meena', 'Mumbai', '2024-07-22'),
(8, 'Vikram', 'Delhi', '2024-08-30');

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, customer_id, order_date, total_amount)
VALUES
(101, 1, '2026-08-25', 2500.00),
(102, 1, '2026-08-10', 1800.00),
(103, 2, '2026-08-20', 1200.00),
(104, 2, '2026-07-15', 800.00),
(105, 3, '2026-08-18', 3500.00),
(106, 3, '2026-08-05', 1500.00),
(107, 4, '2026-08-22', 900.00),
(108, 5, '2026-08-28', 4200.00),
(109, 6, '2026-08-12', 600.00),
(110, 7, '2026-08-02', 2800.00);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    list_price DECIMAL(10,2)
);

INSERT INTO Products (product_id, name, category, list_price)
VALUES
(201, 'Laptop', 'Electronics', 70000.00),
(202, 'Smartphone', 'Electronics', 40000.00),
(203, 'Headphones', 'Electronics', 5000.00),
(204, 'Keyboard', 'Electronics', 3000.00),
(205, 'Office Chair', 'Furniture', 12000.00),
(206, 'Desk', 'Furniture', 15000.00),
(207, 'Notebook', 'Stationery', 500.00),
(208, 'Pen Set', 'Stationery', 300.00),
(209, 'Backpack', 'Accessories', 2500.00),
(210, 'Mouse', 'Electronics', 1500.00);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

INSERT INTO OrderItems
(order_item_id, order_id, product_id, quantity, unit_price)
VALUES
-- Order 101: Electronics + Furniture
(1, 101, 201, 1, 70000.00),
(2, 101, 203, 1, 5000.00),
(3, 101, 205, 1, 12000.00),

-- Order 102: Electronics
(4, 102, 202, 1, 40000.00),
(5, 102, 210, 1, 1500.00),

-- Order 103: Electronics + Stationery
(6, 103, 203, 2, 5000.00),
(7, 103, 207, 3, 500.00),

-- Order 104: Furniture
(8, 104, 206, 1, 15000.00),

-- Order 105: Electronics + Furniture
(9, 105, 201, 1, 70000.00),
(10, 105, 204, 1, 3000.00),
(11, 105, 206, 1, 15000.00),

-- Order 106: Stationery
(12, 106, 207, 5, 500.00),
(13, 106, 208, 5, 300.00),

-- Order 107: Accessories + Stationery
(14, 107, 209, 1, 2500.00),
(15, 107, 208, 2, 300.00),

-- Order 108: Electronics + Furniture
(16, 108, 202, 1, 40000.00),
(17, 108, 203, 1, 5000.00),
(18, 108, 205, 1, 12000.00),

-- Order 109: Electronics
(19, 109, 210, 2, 1500.00),

-- Order 110: Electronics + Accessories
(20, 110, 204, 1, 3000.00),
(21, 110, 209, 1, 2500.00);



SELECT c.customer_id, c.name
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT customer_id,
               SUM(total_amount) AS customer_total
        FROM Orders
        GROUP BY customer_id
    ) AS customer_spending
);




SELECT o.order_id,
       o.customer_id,
       o.total_amount
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL 30 DAY
  AND o.total_amount > ANY (
      SELECT o2.total_amount
      FROM Orders o2
      JOIN Customers c2
          ON o2.customer_id = c2.customer_id
      WHERE c2.city = c.city
);



  

SELECT p.product_id,
       p.name
FROM Products p
WHERE (
    SELECT COUNT(DISTINCT oi2.product_id)
    FROM OrderItems oi1
    JOIN OrderItems oi2
        ON oi1.order_id = oi2.order_id
    WHERE oi1.product_id = p.product_id
      AND oi2.product_id IN (
          SELECT product_id
          FROM Products
          WHERE category = 'Electronics'
      )
) >= ALL (
    SELECT COUNT(DISTINCT oi3.product_id)
    FROM OrderItems oi3
    WHERE oi3.product_id IN (
        SELECT product_id
        FROM Products
        WHERE category = 'Electronics'
    )
    GROUP BY oi3.product_id
);



SELECT c.customer_id,
       c.name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);



SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Products p
JOIN OrderItems oi
    ON p.product_id = oi.product_id
GROUP BY p.category
HAVING SUM(oi.quantity * oi.unit_price) > (
    SELECT AVG(category_sales)
    FROM (
        SELECT p2.category,
               SUM(oi2.quantity * oi2.unit_price) AS category_sales
        FROM Products p2
        JOIN OrderItems oi2
            ON p2.product_id = oi2.product_id
        GROUP BY p2.category
    ) AS category_totals
);


SELECT o.order_id
FROM Orders o
WHERE (
    SELECT COUNT(DISTINCT p.category)
    FROM OrderItems oi
    JOIN Products p
        ON oi.product_id = p.product_id
    WHERE oi.order_id = o.order_id
) >= 2;