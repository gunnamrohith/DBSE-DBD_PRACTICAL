DROP DATABASE IF EXISTS sales_orders_db;

CREATE DATABASE sales_orders_db;

USE sales_orders_db;

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);

INSERT INTO orders VALUES
(81001, 450.75, '2025-01-15', 4101, 6101),
(81002, 3250.50, '2025-02-10', 4102, 6102),
(81003, 125.80, '2025-01-20', 4103, 6103),
(81004, 1875.40, '2025-03-05', 4101, 6101),
(81005, 5200.00, '2025-02-10', 4104, 6102),
(81006, 2750.25, '2025-04-12', 4105, 6104),
(81007, 890.60, '2025-03-05', 4102, 6102),
(81008, 6450.90, '2025-05-18', 4103, 6103),
(81009, 2150.35, '2025-01-20', 4105, 6104),
(81010, 95.50, '2025-06-22', 4106, 6105),
(81011, 3400.75, '2025-04-12', 4102, 6102),
(81012, 1580.20, '2025-07-08', 4107, 6106);

SELECT *
FROM orders
WHERE purch_amt > 2000;

SELECT *
FROM orders
WHERE ord_date = '2025-02-10';

SELECT *
FROM orders
WHERE salesman_id = 6102;

SELECT *
FROM orders
ORDER BY purch_amt DESC;

SELECT *
FROM orders
ORDER BY ord_date;

SELECT SUM(purch_amt) AS total_revenue
FROM orders;

SELECT AVG(purch_amt) AS average_order
FROM orders;

SELECT MAX(purch_amt) AS highest_order
FROM orders;

SELECT MIN(purch_amt) AS lowest_order
FROM orders;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT salesman_id,
       SUM(purch_amt) AS total_sales
FROM orders
GROUP BY salesman_id;

SELECT customer_id,
       SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY customer_id;

SELECT customer_id,
       MAX(purch_amt) AS highest_purchase
FROM orders
GROUP BY customer_id;

SELECT salesman_id,
       SUM(purch_amt) AS total_sales
FROM orders
GROUP BY salesman_id
HAVING SUM(purch_amt) > 5000;

SELECT customer_id,
       SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY customer_id
HAVING SUM(purch_amt) > 3000;

SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT customer_id,
       SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY customer_id
HAVING SUM(purch_amt) > 2000
ORDER BY total_purchase DESC;

SELECT customer_id,
       MAX(purch_amt) AS max_purchase
FROM orders
GROUP BY customer_id
HAVING MAX(purch_amt) BETWEEN 2000 AND 6000;

SELECT salesman_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY salesman_id
HAVING COUNT(*) >= 2;

SELECT ord_date,
       MAX(purch_amt) AS highest_purchase
FROM orders
GROUP BY ord_date
HAVING MAX(purch_amt) > 2000;