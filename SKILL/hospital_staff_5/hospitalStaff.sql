DROP DATABASE IF EXISTS hospital_staff_db;

CREATE DATABASE hospital_staff_db;

USE hospital_staff_db;

CREATE TABLE physician (
    employeeid INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(100),
    ssn VARCHAR(20)
);

INSERT INTO physician VALUES
(21,'Aarav Mehta','Resident Doctor','901234561'),
(22,'Diya Sharma','Consultant Physician','901234562'),
(23,'Rohan Kapoor','Senior Surgeon','901234563'),
(24,'Neha Iyer','Chief Physician','901234564'),
(25,'Vikram Rao','Medical Director','901234565'),
(26,'Sneha Patel','Senior Surgeon','901234566'),
(27,'Arjun Nair','Senior Surgeon','901234567'),
(28,'Meera Joshi','Medical Resident','901234568'),
(29,'Kabir Singh','Consultant Psychiatrist','901234569');

CREATE TABLE department (
    departmentid INT PRIMARY KEY,
    name VARCHAR(100),
    head INT
);

INSERT INTO department VALUES
(11,'Emergency Medicine',24),
(12,'Orthopedics',27),
(13,'Mental Health',29);

SELECT d.name AS Department,
       p.name AS Head_Physician
FROM department d
JOIN physician p
ON d.head = p.employeeid;

SELECT *
FROM physician
WHERE position = 'Senior Surgeon';

SELECT *
FROM physician
WHERE name LIKE 'A%';

SELECT COUNT(*) AS Total_Physicians
FROM physician;

SELECT COUNT(DISTINCT position) AS Different_Positions
FROM physician;

SELECT position,
       COUNT(*) AS Total_Employees
FROM physician
GROUP BY position;

SELECT position,
       COUNT(*) AS Total_Employees
FROM physician
GROUP BY position
HAVING COUNT(*) > 1;

SELECT *
FROM physician
ORDER BY name ASC;

SELECT *
FROM physician
ORDER BY employeeid DESC;

SELECT *
FROM physician
WHERE employeeid IN
(
    SELECT head
    FROM department
);

SELECT *
FROM physician
WHERE employeeid NOT IN
(
    SELECT head
    FROM department
);

SELECT position,
       COUNT(*) AS Total_Employees
FROM physician
GROUP BY position
ORDER BY Total_Employees DESC;

SELECT *
FROM physician
WHERE position LIKE '%Senior%';

SELECT p.name
FROM physician p
JOIN department d
ON p.employeeid = d.head
WHERE d.name = 'Orthopedics';

SELECT d.name AS Department,
       p.name AS Head_Physician
FROM department d
JOIN physician p
ON d.head = p.employeeid
ORDER BY d.name;

SELECT *
FROM physician
WHERE position NOT LIKE '%Surgeon%';

SELECT position,
       COUNT(*) AS Total
FROM physician
GROUP BY position
HAVING COUNT(*) >= 2;

SELECT *
FROM department d
WHERE EXISTS
(
    SELECT 1
    FROM physician p
    WHERE p.employeeid = d.head
);

SELECT MAX(employeeid) AS Highest_Employee_ID
FROM physician;

SELECT MIN(employeeid) AS Lowest_Employee_ID
FROM physician;