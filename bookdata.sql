CREATE DATABASE bookflow_dbweek2;
USE bookflow_db;
CREATE TABLE Books2 (
 book_id INT PRIMARY KEY,
 title VARCHAR(100) NOT NULL,
 isbn VARCHAR(20) UNIQUE,
 published_year INT CHECK (published_year < 2027)
);
INSERT INTO Books2 (book_id, title, isbn, published_year) VALUES
(1, 'The Great Gatsby', '9780743273565', 1925),
(2, 'To Kill a Mockingbird', '9780061120084', 1960),
(3, '1984', '9780451524935', 1949);
SELECT * FROM Books2;
CREATE TABLE Members (
 member_id INT PRIMARY KEY,
 full_name VARCHAR(100),
 email VARCHAR(100) UNIQUE
);
INSERT INTO Members (member_id, full_name, email) VALUES
(101, 'John Smith', 'john.smith@email.com'),
(102, 'Emma Wilson', 'emma.wilson@email.com'),
(103, 'Michael Brown', 'michael.brown@email.com');
SELECT * FROM Members;
CREATE TABLE Loans (
 loan_id INT PRIMARY KEY,
 member_id INT,
 book_id INT,
 loan_date DATE,
 FOREIGN KEY (member_id) REFERENCES Members(member_id),
 FOREIGN KEY (book_id) REFERENCES Books2(book_id)
);
INSERT INTO Loans (loan_id, member_id, book_id, loan_date) VALUES
(1, 101, 1, '2025-01-05'), (2, 102, 2, '2025-01-08'),
(3, 103, 3, '2025-01-10'), (4, 101, 2, '2025-02-01'),
(5, 102, 1, '2025-02-05'), (6, 103, 2, '2025-02-12'),
(7, 101, 3, '2025-03-01'), (8, 102, 3, '2025-03-07'),
(9, 103, 1, '2025-03-15'), (10, 101, 1, '2025-04-01');
SELECT * FROM Loans;
