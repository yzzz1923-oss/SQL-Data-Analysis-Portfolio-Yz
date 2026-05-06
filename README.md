# SQL-Data-Analysis-Portfolio-Yz
A passionate beginner's SQL portfolio, exploring various data analysis scenarios with a focus on business metrics, data processing, and hands-on learning.
## 🛒 Project 1: Retail Business Analysis 
Database: `sql project.sql`
## 🏗️ Project 1 Learning
1. **Database Initialization:** Designed table schemas and imported raw retail data into PostgreSQL.
2. **Data Cleansing:** Identified and handled missing/null values to ensure metric accuracy.
3. **Exploratory Data Analysis :** Conducted foundational queries to understand customer demographics, category distributions, and overall dataset structure.
4. **Business Insight Extraction:** Translated real-world business questions into complex SQL queries to identify revenue drivers and customer behaviors.

<details>
<summary><b>🔍 Click to view: Table Creation </b></summary>

```sql
CREATE TABLE retail_sales(
	transactions_id INTEGER PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INTEGER,	
	gender VARCHAR(15),
	age INTEGER,
	category VARCHAR(15),
	quantiy INTEGER,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT 	
);
```
## Delete Null Info
```sql
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
</details>

<details>
<summary><b>🔍 Click to view: SQL Code </b></summary>

## Analysis and finding
### 1) Write a SQL query to retrieve all columns for sales made on '2022-12-02':
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-12-02';
```
### 2) Write a SQL query to retrieve all transactions order by date where the category is 'Clothing' and the quantity sold is more than 3 in the month of Oct-2022:
```sql
SELECT * from retail_sales
WHERE category = 'Clothing' AND quantity >= 3 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-10'
ORDER BY sale_date;
```
### 3) Write a SQL query to calculate the total sales (total_sale) and total order (total_order) for each category:
```sql
SELECT category, SUM(total_sale), COUNT(*) as total_order from retail_sales
GROUP BY category;
```
### 4) Write a SQL query to find the average age of customers who purchased items from the 'Electronics' category:
```sql
SELECT ROUND(AVG(age), 0) as average_age from retail_sales
WHERE category = 'Electronics';
```
### 5) Write a SQL query to find all transactions where the total_sale is greater than 1000:
```sql
SELECT * FROM retail_sales
WHERE total_sale >= 1000;
```
### 6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:
```sql
SELECT category, gender, COUNT(transactions_id) AS num_of_tid FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```
### 7) Write a SQL query to calculate the total sale for each month. Find out best selling month in each year:
```sql
SELECT year, month, total_sale FROM (  
    SELECT 
        EXTRACT(YEAR FROM sale_date) as year,
        EXTRACT(MONTH FROM sale_date) as month,
        SUM(total_sale) as total_sale, 
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC) AS rank 
    FROM retail_sales
    GROUP BY year,month) as t1
WHERE rank = 1;
```
### 8) Write a SQL query to find the top 10 customers based on the highest total sales:
```sql
SELECT customer_id, SUM(total_sale) AS total_sale FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 10;
```
### 9) Write a SQL query to find the number of unique customers who purchased items from each category:
```sql
SELECT category, COUNT(DISTINCT (customer_id)) AS num_of_customer FROM retail_sales
GROUP BY category;
```
### 10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
```sql
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift 
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale 
GROUP BY shift
ORDER BY 
    CASE shift
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;
```
</details>

### 💡 Personal Reflection: From Zero to One 
To be completely honest, this is the very first data project I have ever done. As a beginner, I was quite overwhelmed at the beginning and didn't even know where to start. 

* **My Learning Curve:** For the few questions, I had to rely heavily on tutorials to understand the syntax. But as I progressed, I forced myself to change my habit: **I started writing the SQL queries on my own first, and only checked the reference answers afterward.** Seeing my own code actually run and produce the right results was incredibly rewarding!
* **What I Realized:** This project was my real gateway  into data analysis. It helped me realize that SQL is not just about memorizing cold syntax like `GROUP BY` or `JOIN`. It is a very practical tool to answer real-world questions—like finding out "what time is the busiest" or "who are the top customers."

This project might be simple, but it marks my first solid step into the world of data, and it gave me the confidence to keep learning!

## 🛒 Project 2: Library Management System 
Database: `library_p2.sql` and `library_p2_advanced.sql`

## 🏗️ Project 2 Learning
1) **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2) **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3) **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4) **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

<img width="975" height="1072" alt="ERDp2" src="https://github.com/user-attachments/assets/768b2027-90c0-4520-91bf-8ccef69a2031" />
<details>
<summary><b>🔍 Click to view: Table Creation </b></summary>

## Table Creation 
Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.
```sql

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
```
</details>

<details>
<summary><b>🔍 Click to view: SQL intermediate </b></summary>

### CRUD (Create, Read, Update, Delete) Operation
## Task 1. Create a New Book Record 
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
```sql
INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
## Task 2: Update an Existing Member's Address 
Change member C101's address to 125 Elm St
```sql
UPDATE members
SET member_address = '125 Elm St'
WHERE member_id = 'C101';
SELECT * FROM members
ORDER BY member_id ASC;
```
## Task 3: Delete a Record from the Issued Status Table 
Delete the record with issued_id = 'IS121' from the issued_status table.
```sql
DELETE FROM issued
WHERE issued_id = 'IS121';
SELECT * FROM issued;
```
## Task 4: Retrieve All Books Issued by a Specific Employee 
Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * from issued
WHERE issued_emp_id = 'E101';
```
## Task 5: List Members Who Have Issued More Than One Book 
Use GROUP BY to find members who have issued more than one book.
```sql
SELECT issued_member_id, COUNT(issued_id) AS num_issued FROM issued
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1;
```
## Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results each book and total book_issued_cnt**
```sql
CREATE TABLE book_issued_cnt AS
SELECT books.isbn, books.book_title, COUNT(issued.issued_id) AS total_books_issued_cnt FROM issued
INNER JOIN books
ON issued.issued_book_isbn = books.isbn
GROUP BY books.isbn, books.book_title;
SELECT * FROM book_issued_cnt;
```
## Task 7. count how many books each category has
```sql
SELECT category,COUNT(category) as num_category FROM books
GROUP BY category
ORDER BY category;
```
## Task 8: Find Total Rental Income by Category:
```sql
SELECT category, COUNT(isbn), SUM(rental_price) 
FROM issued as ist 
JOIN books as b
  ON b.isbn = ist.issued_book_isbn
GROUP BY category;
```
## Task 9: List Members Who Registered in the Last 4 years:
```sql
SELECT * FROM members
WHERE reg_date >= Current_Date - INTERVAL '4 years';
```

## Task 10: List Employees with Their Branch Manager's Name and their branch details:
```sql
SELECT e1.emp_id,e1.emp_name,e1.position,e1.salary,branch.*,e2.emp_name as manager FROM employees as e1
JOIN branch
ON e1.branch_id = branch.branch_id
JOIN employees as e2
ON e2.emp_id = branch.manager_id;
```

## Task 11. Create a Table of Books with Rental Price Above 7:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM BOOKS
WHERE rental_price >= 7.00;
SELECT * FROM expensive_books;
```

## Task 12: Retrieve the List of Books Not Yet Returned
```sql
SELECT * FROM issued
LEFT JOIN return_stat
on issued.issued_id = return_stat.issued_id
WHERE return_id IS NULL
ORDER BY issued.issued_id;
```
</details>

<details>
<summary><b>🔍 Click to view: SQL Advanced </b></summary>
  
## Task 13: Identify Members with Overdue Books
**Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.**
```sql
-- issued <-> member <-> books <-> return_stat
-- filter books which are returned
-- check day > 30 or not

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_stat as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1
```

## Task 14: Update Book Status on Return
**Write a query to update the status of books in the books table to 
"Yes" when they are returned (based on entries in the return_status table).**
```sql
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_stat(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

-- Testing FUNCTION add_return_records

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_stat
WHERE issued_id = 'IS135';

DELETE FROM return_stat
WHERE issued_

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');
```

## Task 15: Branch Performance Report
**Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.**
```sql
CREATE TABLE branch_reports AS
SELECT 
	b.branch_id,
	b.manager_id,
	COUNT(iss.issued_id) AS num_book_issued,
	COUNT(rs.return_id) AS num_book_return, 
	SUM(bk.rental_price) as total_revenue 
FROM issued AS iss
INNER JOIN employees AS em
ON iss.issued_emp_id = em.emp_id
INNER JOIN branch AS b
ON em.branch_id = b.branch_id
LEFT JOIN return_stat AS rs
on iss.issued_id = rs.issued_id
INNER JOIN books AS bk
on iss.issued_book_isbn = bk.isbn
GROUP BY 1,2;

SELECT * FROM branch_reports
```

## Task 16: CTAS: Create a Table of Active Members
**Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 2 years 1 month.**
```sql
CREATE TABLE active_member AS
SELECT * FROM members
WHERE member_id in (
SELECT DISTINCT issued_member_id FROM issued
WHERE issued_date > CURRENT_DATE - INTERVAL '2 year 1 month');

SELECT * FROM active_member;
```

## Task 17: Find Employees with the Most Book Issues Processed
**Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.**
```sql
SELECT * FROM employees;
SELECT e.emp_name, b.*, COUNT(iss.issued_id) as num_book_issued FROM issued as iss
INNER JOIN employees as e
ON iss.issued_emp_id = e.emp_id
INNER JOIN branch as b
ON e.branch_id = b.branch_id
GROUP BY 1,2;
```

## Task 18: Stored Procedure Objective: 
**Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). If the book is available, 
it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), 
the procedure should return an error message indicating that the book is currently not available.
简单来说这个就是借书系统 如果有书 那就借出去 没书就说没有**
```sql
SELECT * FROM books;
SELECT * FROM issued;

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
--variable
	v_status VARCHAR(10); 

BEGIN
--code
--check if book status yes
	SELECT status INTO v_status FROM books
	WHERE isbn = p_issued_book_isbn;
	IF v_status = 'yes' THEN
		INSERT INTO issued(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES
		(p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);
		UPDATE books
	    	SET status = 'no'
	    WHERE isbn = p_issued_book_isbn;
		RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;
	
	ELSE
		RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
	
	END IF;
END;
$$

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;
CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'
```
</details>

### 💡 What I Learned (我的个人感悟)
Building this library system from scratch was a huge step up for me. Instead of just "reading" data like in the first project, I learned how to actively manage and automate a system:

* **The Power of Automation:** Writing `Stored Procedures` for the first time was challenging, but it made me realize that SQL can do more than just answer questions—it can enforce business rules (like automatically updating a book's availability when someone borrows it). This felt exactly like updating a player's inventory in a video game!
* **Connecting the Dots:** Designing the Database Schema taught me how different pieces of a business (employees, users, physical assets) are connected through primary and foreign keys. 
* **Spotting Risks:** The most fascinating part was writing the logic to find "overdue books." It clicked for me that mathematically, finding a user who hasn't returned a book in 30 days is the exact same logic as identifying a **"churned player"** who hasn't logged into a game for a month.
