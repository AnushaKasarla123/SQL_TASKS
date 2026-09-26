create database ecommerce;
use ecommerce;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT NOT NULL
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'PLACED',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE AuditLog (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation_type VARCHAR(20),
    primary_key_value INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    performed_by VARCHAR(100),
    order_id INT NULL,
    product_id INT NULL
);
INSERT INTO Customers (name, email)
VALUES
('Anusha', 'anusha@gmail.com'),
('Rahul', 'rahul@gmail.com');
INSERT INTO Products (product_name, price, stock)
VALUES
('Laptop', 55000.00, 10),
('Mouse', 800.00, 20),
('Keyboard', 1500.00, 15);
SELECT * FROM Products;

DELIMITER //

CREATE TRIGGER before_orderitem_insert
BEFORE INSERT ON OrderItems
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    SELECT stock
    INTO available_stock
    FROM Products
    WHERE product_id = NEW.product_id;

    IF NEW.quantity > available_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient product stock';
    END IF;
END//

DELIMITER ;
DELIMITER //

CREATE TRIGGER after_orderitem_insert
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE Products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER before_orderitem_update
BEFORE UPDATE ON OrderItems
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    IF NEW.product_id = OLD.product_id THEN

        SELECT stock
        INTO available_stock
        FROM Products
        WHERE product_id = NEW.product_id;

        IF (NEW.quantity - OLD.quantity) > available_stock THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for updated quantity';
        END IF;

    ELSE

        SELECT stock
        INTO available_stock
        FROM Products
        WHERE product_id = NEW.product_id;

        IF NEW.quantity > available_stock THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for new product';
        END IF;

    END IF;
END//

DELIMITER ;
DELIMITER //

CREATE TRIGGER after_orders_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog
    (
        table_name,
        operation_type,
        primary_key_value,
        action_time,
        performed_by
    )
    VALUES
    (
        'Orders',
        'INSERT',
        NEW.order_id,
        CURRENT_TIMESTAMP,
        CURRENT_USER()
    );
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_orders_update
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog
    (
        table_name,
        operation_type,
        primary_key_value,
        action_time,
        performed_by
    )
    VALUES
    (
        'Orders',
        'UPDATE',
        NEW.order_id,
        CURRENT_TIMESTAMP,
        CURRENT_USER()
    );
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_orders_delete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog
    (
        table_name,
        operation_type,
        primary_key_value,
        action_time,
        performed_by
    )
    VALUES
    (
        'Orders',
        'DELETE',
        OLD.order_id,
        CURRENT_TIMESTAMP,
        CURRENT_USER()
    );
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_orderitems_audit_insert
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog
    (
        table_name,
        operation_type,
        primary_key_value,
        action_time,
        performed_by,
        order_id,
        product_id
    )
    VALUES
    (
        'OrderItems',
        'INSERT',
        NEW.order_item_id,
        CURRENT_TIMESTAMP,
        CURRENT_USER(),
        NEW.order_id,
        NEW.product_id
    );
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_orderitems_audit_delete
AFTER DELETE ON OrderItems
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog
    (
        table_name,
        operation_type,
        primary_key_value,
        action_time,
        performed_by,
        order_id,
        product_id
    )
    VALUES
    (
        'OrderItems',
        'DELETE',
        OLD.order_item_id,
        CURRENT_TIMESTAMP,
        CURRENT_USER(),
        OLD.order_id,
        OLD.product_id
    );
END//

DELIMITER ;

