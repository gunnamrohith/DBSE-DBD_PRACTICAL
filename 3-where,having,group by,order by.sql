CREATE DATABASE OrderManagementPractice;

USE OrderManagementPractice;

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10,2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT
);
INSERT INTO orders VALUES
(81001, 325.75, '2025-01-12', 4101, 6102),
(81002, 1850.40, '2025-02-18', 4102, 6101),
(81003, 72.90, '2025-01-12', 4103, 6103),
(81004, 2750.80, '2025-03-05', 4101, 6101),
(81005, 640.25, '2025-02-18', 4104, 6102),
(81006, 4325.60, '2025-03-05', 4102, 6101),
(81007, 1295.35, '2025-04-11', 4105, 6104),
(81008, 3580.90, '2025-04-11', 4101, 6101),
(81009, 95.50, '2025-05-20', 4103, 6103),
(81010, 2180.45, '2025-05-20', 4106, 6104),
(81011, 875.30, '2025-06-08', 4104, 6102),
(81012, 5120.75, '2025-06-08', 4102, 6101);
SELECT * FROM orders;
SELECT *
FROM orders
WHERE purch_amt > 2000;
SELECT *
FROM orders
WHERE ord_date = '2025-04-11';
SELECT *
FROM orders
WHERE salesman_id = 6101;
SELECT *
FROM orders
ORDER BY purch_amt DESC;
SELECT *
FROM orders
ORDER BY ord_date ASC;
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
HAVING SUM(purch_amt) > 3000;
SELECT customer_id,
       SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY customer_id
HAVING SUM(purch_amt) > 2500;
SELECT customer_id,
       COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
SELECT customer_id,
       SUM(purch_amt) AS total_purchase
FROM orders
GROUP BY customer_id
HAVING SUM(purch_amt) > 1000
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