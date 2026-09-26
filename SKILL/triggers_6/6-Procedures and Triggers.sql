CREATE DATABASE Week6_BankingPractice;
USE Week6_BankingPractice;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12,2) DEFAULT 0,
    Branch VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Bank_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Account_No) REFERENCES Account(Account_No)
);

CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Loan_Type VARCHAR(30),
    Loan_Amount DECIMAL(12,2),
    Interest_Rate DECIMAL(5,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

INSERT INTO Customer
(Customer_ID, Customer_Name, Phone, Email, City)
VALUES
(201, 'Aarav Mehta', '9876501230', 'aarav.mehta@gmail.com', 'Hyderabad'),
(202, 'Diya Sharma', '9876501231', 'diya.sharma@gmail.com', 'Vijayawada'),
(203, 'Rohan Reddy', '9876501232', 'rohan.reddy@gmail.com', 'Bengaluru'),
(204, 'Meera Rao', '9876501233', 'meera.rao@gmail.com', 'Chennai'),
(205, 'Kabir Kumar', '9876501234', 'kabir.kumar@gmail.com', 'Hyderabad');

INSERT INTO Account
(Account_No, Customer_ID, Account_Type, Balance, Branch)
VALUES
(20001, 201, 'Savings', 62000, 'Hyderabad'),
(20002, 202, 'Savings', 81000, 'Vijayawada'),
(20003, 203, 'Current', 135000, 'Bengaluru'),
(20004, 204, 'Savings', 52000, 'Chennai'),
(20005, 205, 'Current', 98000, 'Hyderabad');

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(20001, 'DEPOSIT', 12000),
(20002, 'DEPOSIT', 18000),
(20003, 'WITHDRAW', 22000),
(20004, 'DEPOSIT', 7000),
(20005, 'WITHDRAW', 12000);

INSERT INTO Loan
(Loan_ID, Customer_ID, Loan_Type, Loan_Amount, Interest_Rate)
VALUES
(601, 201, 'Home Loan', 4200000, 7.25),
(602, 202, 'Education Loan', 1250000, 6.75),
(603, 203, 'Car Loan', 950000, 8.40),
(604, 204, 'Personal Loan', 650000, 10.25);

SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Loan;

DELIMITER //

CREATE PROCEDURE GetAllCustomers()
BEGIN
    SELECT * FROM Customer;
END //

DELIMITER ;

CALL GetAllCustomers();

DELIMITER //

CREATE PROCEDURE GetAccountDetails(
    IN p_Account_No INT
)
BEGIN
    SELECT *
    FROM Account
    WHERE Account_No = p_Account_No;
END //

DELIMITER ;

CALL GetAccountDetails(20001);

DELIMITER //

CREATE PROCEDURE GetCustomerAccounts(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_ID,
        C.Customer_Name,
        A.Account_No,
        A.Account_Type,
        A.Balance,
        A.Branch
    FROM Customer C
    JOIN Account A
    ON C.Customer_ID = A.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //

DELIMITER ;

CALL GetCustomerAccounts(201);

DELIMITER //

CREATE PROCEDURE DepositMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    UPDATE Account
    SET Balance = Balance + p_Amount
    WHERE Account_No = p_Account_No;
END //

DELIMITER ;

CALL DepositMoney(20001, 6500);

SELECT * FROM Account WHERE Account_No = 20001;

DELIMITER //

CREATE PROCEDURE WithdrawMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    UPDATE Account
    SET Balance = Balance - p_Amount
    WHERE Account_No = p_Account_No;
END //

DELIMITER ;

CALL WithdrawMoney(20001, 3500);

SELECT * FROM Account WHERE Account_No = 20001;

DELIMITER //

CREATE TRIGGER CheckBalance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.Balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction failed: Insufficient balance';
    END IF;
END //

DELIMITER ;

UPDATE Account
SET Balance = Balance - 100000
WHERE Account_No = 20001;

DELIMITER //

CREATE TRIGGER CheckTransactionAmount
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction amount must be greater than zero';
    END IF;
END //

DELIMITER ;

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(20001, 'DEPOSIT', -2500);

CREATE TABLE Transaction_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Transaction_ID INT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Audit_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER TransactionAudit
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    INSERT INTO Transaction_Audit
    (
        Transaction_ID,
        Account_No,
        Transaction_Type,
        Amount
    )
    VALUES
    (
        NEW.Transaction_ID,
        NEW.Account_No,
        NEW.Transaction_Type,
        NEW.Amount
    );
END //

DELIMITER ;

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(20001, 'DEPOSIT', 3200);

SELECT * FROM Transaction_Audit;

DELIMITER //

CREATE TRIGGER UpdateBalanceAfterTransaction
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Transaction_Type = 'DEPOSIT' THEN
        UPDATE Account
        SET Balance = Balance + NEW.Amount
        WHERE Account_No = NEW.Account_No;
    ELSEIF NEW.Transaction_Type = 'WITHDRAW' THEN
        UPDATE Account
        SET Balance = Balance - NEW.Amount
        WHERE Account_No = NEW.Account_No;
    END IF;
END //

DELIMITER ;

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(20001, 'DEPOSIT', 4500);

SELECT *
FROM Account
WHERE Account_No = 20001;

DELIMITER //

CREATE TRIGGER PreventInsufficientWithdrawal
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    DECLARE CurrentBalance DECIMAL(12,2);

    SELECT Balance
    INTO CurrentBalance
    FROM Account
    WHERE Account_No = NEW.Account_No;

    IF NEW.Transaction_Type = 'WITHDRAW'
       AND NEW.Amount > CurrentBalance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Withdrawal failed: Insufficient balance';
    END IF;
END //

DELIMITER ;

INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(20001, 'WITHDRAW', 900000);

DELIMITER //

CREATE PROCEDURE TransferMoney(
    IN SenderAccount INT,
    IN ReceiverAccount INT,
    IN TransferAmount DECIMAL(12,2)
)
BEGIN
    DECLARE SenderBalance DECIMAL(12,2);

    SELECT Balance
    INTO SenderBalance
    FROM Account
    WHERE Account_No = SenderAccount;

    IF SenderBalance < TransferAmount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer failed: Insufficient balance';
    ELSE
        UPDATE Account
        SET Balance = Balance - TransferAmount
        WHERE Account_No = SenderAccount;

        UPDATE Account
        SET Balance = Balance + TransferAmount
        WHERE Account_No = ReceiverAccount;
    END IF;
END //

DELIMITER ;

CALL TransferMoney(20001, 20002, 4500);

SELECT *
FROM Account
WHERE Account_No IN (20001,20002);

DELIMITER //

CREATE PROCEDURE GetCustomerLoans(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_Name,
        L.Loan_ID,
        L.Loan_Type,
        L.Loan_Amount,
        L.Interest_Rate
    FROM Customer C
    JOIN Loan L
    ON C.Customer_ID = L.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //

DELIMITER ;

CALL GetCustomerLoans(201);

DELIMITER //

CREATE PROCEDURE HighBalanceAccounts(
    IN MinimumBalance DECIMAL(12,2)
)
BEGIN
    SELECT *
    FROM Account
    WHERE Balance >= MinimumBalance
    ORDER BY Balance DESC;
END //

DELIMITER ;

CALL HighBalanceAccounts(60000);

DELIMITER //

CREATE PROCEDURE GetBalance(
    IN p_Account_No INT,
    OUT p_Balance DECIMAL(12,2)
)
BEGIN
    SELECT Balance
    INTO p_Balance
    FROM Account
    WHERE Account_No = p_Account_No;
END //

DELIMITER ;

CALL GetBalance(20001, @CurrentBalance);
SELECT @CurrentBalance;

SHOW TRIGGERS;

SHOW CREATE TRIGGER CheckBalance;

DROP TRIGGER CheckBalance;

SHOW PROCEDURE STATUS
WHERE Db = 'Week6_BankingPractice';

DROP PROCEDURE GetAllCustomers;
