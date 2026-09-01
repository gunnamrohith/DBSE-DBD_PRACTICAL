CREATE DATABASE dbse_practical_2026;
USE dbse_practical_2026;
CREATE TABLE bank_transactions (
    txn_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    branch_name VARCHAR(50),
    transaction_type VARCHAR(20),
    amount DECIMAL(10,2),
    transaction_date DATE
);
DESC bank_transactions;
ALTER TABLE bank_transactions
ADD account_no VARCHAR(20);
DESC bank_transactions;
ALTER TABLE bank_transactions
MODIFY customer_name VARCHAR(100);
DESC bank_transactions;
RENAME TABLE bank_transactions
TO customer_transactions;
RENAME TABLE customer_transactions
TO bank_transactions;
SHOW TABLES;
TRUNCATE TABLE bank_transactions;
SELECT * FROM bank_transactions;
CREATE TABLE bank_backup (
    txn_id INT
);
DROP TABLE bank_backup;
SHOW TABLES;
INSERT INTO bank_transactions
(txn_id, customer_name, branch_name, transaction_type, amount, transaction_date)
VALUES
(101,'ROHITH','Hyderabad','Deposit',5000,'2024-01-05'),
(102,'Sita','Hyderabad','Withdrawal',2000,'2024-01-06'),
(103,'Kiran','Vijayawada','Deposit',12000,'2024-01-08'),
(104,'Anil','Vizag','Deposit',8000,'2024-01-10'),
(105,'Priya','Hyderabad','Withdrawal',3500,'2024-01-11'),
(106,'Ramesh','Vizag','Deposit',15000,'2024-01-12'),
(107,'Keerthi','Vijayawada','Withdrawal',1000,'2024-01-13'),
(108,'Rahul','Hyderabad','Deposit',9000,'2024-01-14'),
(109,'Sneha','Vizag','Withdrawal',4000,'2024-01-15'),
(110,'Madhu','Vijayawada','Deposit',11000,'2024-01-16');
SELECT * FROM bank_transactions;
INSERT INTO bank_transactions
VALUES
(111,'Venu','Vizag','Deposit',7000,'2024-01-18');
SELECT * FROM bank_transactions
WHERE txn_id = 111;
SELECT *
FROM bank_transactions
ORDER BY amount DESC;
