use 106r;
show tables;

DESCRIBE employee;
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE orderitems;
DESCRIBE products;

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Department,
    e.Salary
FROM employee e
WHERE e.Salary > (
    SELECT AVG(e2.Salary)
    FROM employee e2
    WHERE e2.Department = e.Department
);

SELECT
    c.customer_id,
    c.name,
    customer_total.total_spend
FROM customers c
JOIN
(
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM orders o
    JOIN orderitems oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS customer_total
    ON c.customer_id = customer_total.customer_id
ORDER BY customer_total.total_spend DESC
LIMIT 3;

SELECT
    p.product_id,
    p.name,
    p.category,
    p.list_price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM orderitems oi
    WHERE oi.product_id = p.product_id
);


SELECT
    c.customer_id,
    c.name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN orderitems oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.name
HAVING COUNT(DISTINCT p.category) = (
    SELECT COUNT(DISTINCT category)
    FROM products
);

SELECT
    c.customer_id,
    c.name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN orderitems oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.name
HAVING COUNT(DISTINCT p.category) = (
    SELECT COUNT(DISTINCT category)
    FROM products
);

SELECT
    m.sales_month,
    m.total_sales,

    (
        SELECT SUM(o2.total_amount)
        FROM orders o2
        WHERE DATE_FORMAT(o2.order_date, '%Y-%m') =
              DATE_FORMAT(
                  DATE_SUB(
                      STR_TO_DATE(CONCAT(m.sales_month, '-01'), '%Y-%m-%d'),
                      INTERVAL 1 MONTH
                  ),
                  '%Y-%m'
              )
    ) AS previous_month_sales,

    (
        (
            m.total_sales -
            (
                SELECT SUM(o3.total_amount)
                FROM orders o3
                WHERE DATE_FORMAT(o3.order_date, '%Y-%m') =
                      DATE_FORMAT(
                          DATE_SUB(
                              STR_TO_DATE(CONCAT(m.sales_month, '-01'), '%Y-%m-%d'),
                              INTERVAL 1 MONTH
                          ),
                          '%Y-%m'
                      )
            )
        )
        /
        (
            SELECT SUM(o4.total_amount)
            FROM orders o4
            WHERE DATE_FORMAT(o4.order_date, '%Y-%m') =
                  DATE_FORMAT(
                      DATE_SUB(
                          STR_TO_DATE(CONCAT(m.sales_month, '-01'), '%Y-%m-%d'),
                          INTERVAL 1 MONTH
                      ),
                      '%Y-%m'
                  )
        )
    ) * 100 AS growth_percentage

FROM
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(total_amount) AS total_sales
    FROM orders
    WHERE YEAR(order_date) = (
        SELECT MAX(YEAR(order_date))
        FROM orders
    )
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) AS m

ORDER BY m.sales_month;