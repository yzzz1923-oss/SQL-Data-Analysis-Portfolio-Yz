--Library Management System P2

DROP TABLE IF EXISTS branch;
Create TABLE branch(
	branch_id VARCHAR(10) PRIMARY KEY, 
	manager_id VARCHAR(10), 
	branch_address VARCHAR(55), 
	contact_no VARCHAR(20)
	);

DROP TABLE IF EXISTS employees;
Create TABLE employees(
	emp_id VARCHAR(10) PRIMARY KEY, 
	emp_name VARCHAR(35), 
	position VARCHAR(25), 
	salary INT,
	branch_id VARCHAR(10) --FK
	);

DROP TABLE IF EXISTS books;
Create TABLE books(
	isbn VARCHAR(25) PRIMARY KEY, 
	book_title VARCHAR(80), 
	category VARCHAR(25), 
	rental_price FLOAT,
	status VARCHAR(15),
	author VARCHAR(55),
	publisher VARCHAR(55)
	);

DROP TABLE IF EXISTS members;
Create TABLE members(
	member_id VARCHAR(10) PRIMARY KEY, 
	member_name VARCHAR(35), 
	member_address VARCHAR(55), 
	reg_date DATE
	);

DROP TABLE IF EXISTS issued;
Create TABLE issued(
	issued_id VARCHAR(10) PRIMARY KEY, 
	issued_member_id VARCHAR(10), --FK 
	issued_book_name VARCHAR(75), 
	issued_date DATE,
	issued_book_isbn VARCHAR(25), --FK
	issued_emp_id VARCHAR(10) --FK
	);

DROP TABLE IF EXISTS return_stat;
Create TABLE return_stat(
	return_id VARCHAR(10) PRIMARY KEY, 
	issued_id VARCHAR(10), --FK
	return_book_name VARCHAR(75), 
	return_date DATE,
	return_book_isbn VARCHAR(25)
	);

-- FOREIGN KEY(connections)
ALTER TABLE issued
ADD CONSTRAINT fk_member FOREIGN KEY(issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued
ADD CONSTRAINT fk_book FOREIGN KEY(issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued
ADD CONSTRAINT fk_emp FOREIGN KEY(issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch FOREIGN KEY(branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_stat
ADD CONSTRAINT fk_issued FOREIGN KEY(issued_id)
REFERENCES issued(issued_id);

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued;
SELECT * FROM members;
SELECT * FROM return_stat;

--CRUD (Create, Read, Update, Delete) Operation
--Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
--Task 2: Update an Existing Member's Address 
--Change member C101's address to 125 Elm St
UPDATE members
SET member_address = '125 Elm St'
WHERE member_id = 'C101';
SELECT * FROM members
ORDER BY member_id ASC;
--Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued
WHERE issued_id = 'IS121';
SELECT * FROM issued;
--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * from issued
WHERE issued_emp_id = 'E101';
--Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_member_id, COUNT(issued_id) AS num_issued FROM issued
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1;
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS
SELECT books.isbn, books.book_title, COUNT(issued.issued_id) AS total_books_issued_cnt FROM issued
INNER JOIN books
ON issued.issued_book_isbn = books.isbn
GROUP BY books.isbn, books.book_title;
SELECT * FROM book_issued_cnt;

--Task 7. count how many books each category has
SELECT category,COUNT(category) as num_category FROM books
GROUP BY category
ORDER BY category;

--Task 8: Find Total Rental Income by Category:
SELECT category, COUNT(isbn), SUM(rental_price) 
FROM issued as ist 
JOIN books as b
  ON b.isbn = ist.issued_book_isbn
GROUP BY category;

--Task 9: List Members Who Registered in the Last 4 years:
SELECT * FROM members
WHERE reg_date >= Current_Date - INTERVAL '4 years';

--Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,branch.*,e2.emp_name as manager FROM employees as e1
JOIN branch
ON e1.branch_id = branch.branch_id
JOIN employees as e2
ON e2.emp_id = branch.manager_id;

--Task 11. Create a Table of Books with Rental Price Above 7:
CREATE TABLE expensive_books AS
SELECT * FROM BOOKS
WHERE rental_price >= 7.00;
SELECT * FROM expensive_books;

--Task 12: Retrieve the List of Books Not Yet Returned
SELECT * FROM issued
LEFT JOIN return_stat
on issued.issued_id = return_stat.issued_id
WHERE return_id IS NULL
ORDER BY issued.issued_id;





