CREATE DATABASE joins;
USE joins;

CREATE TABLE class (
    id INT,
    name VARCHAR(30)
);

CREATE TABLE class_info (
    id INT,
    address VARCHAR(30)
);

INSERT INTO class VALUES
(1,'test1'),
(2,'rohith1'),
(3,'test2'),
(4,'rohith2');

INSERT INTO class_info VALUES
(1,'DELHI'),
(2,'MUMBAI'),
(3,'HYDERABAD');


-- CROSS JOIN
SELECT *
FROM class
CROSS JOIN class_info;


-- INNER JOIN
SELECT *
FROM class
INNER JOIN class_info
ON class.id = class_info.id;


-- NATURAL JOIN
SELECT *
FROM class
NATURAL JOIN class_info;


-- LEFT OUTER JOIN

INSERT INTO class VALUES
(5,'test3');

INSERT INTO class_info VALUES
(7,'NOIDA'),
(8,'PANIPAT');

SELECT *
FROM class
LEFT OUTER JOIN class_info
ON class.id = class_info.id;


-- RIGHT OUTER JOIN
SELECT *
FROM class
RIGHT OUTER JOIN class_info
ON class.id = class_info.id;


-- FULL OUTER JOIN
SELECT *
FROM class
FULL OUTER JOIN class_info
ON class.id = class_info.id;