/* This file makes changes to some of the magic_library data tables using ALTER and UPDATE, creates two new 
tables and enables additional queries based on new scenarios. See Readme file for more information about the specifics of each scenario.*/

USE magic_library;

/* safe update mode may need to be disabled for current session */
SET SQL_SAFE_UPDATES = 0;

/* Table changes */

/* i. uses ALTER to add a new column 'in_stock' to 'books' table to record if books out or in stock */
ALTER TABLE books
ADD COLUMN in_stock BOOLEAN DEFAULT TRUE;    -- sets default boolean as true (in stock)

/* ii. uses ALTER to add a new column 'returned' to table 'borrowed_books' to record if books returned*/
ALTER TABLE borrowed_books
ADD COLUMN returned BOOLEAN DEFAULT FALSE;    -- sets default boolean as false (not returned)

/* iii. adds more data to borrowed_books table, including books that have now been returned */
INSERT INTO borrowed_books
(borrow_date, due_date, return_date, wizard_id, book_id, returned)
VALUES
('2022-04-21', DATE_ADD('2022-04-21', INTERVAL 4 WEEK), '2022-04-30', 1, 19, TRUE),
('2022-03-11', DATE_ADD('2022-03-11', INTERVAL 4 WEEK),	'2022-05-06', 12, 14, TRUE),
('2023-01-21', DATE_ADD('2023-01-21', INTERVAL 4 WEEK),	'2023-04-21', 17, 9, TRUE),
('2023-02-05', DATE_ADD('2023-02-05', INTERVAL 4 WEEK),	'2023-02-07', 1, 16, TRUE),
('2023-03-25', DATE_ADD('2023-03-25', INTERVAL 4 WEEK),	'2023-04-21', 8, 16, TRUE),
('2023-04-21', DATE_ADD('2023-04-21', INTERVAL 4 WEEK), '2023-07-31', 1, 4, TRUE),
('2023-05-13', DATE_ADD('2023-05-13', INTERVAL 4 WEEK), '2023-06-01', 1, 9, TRUE),
('2023-03-30', DATE_ADD('2023-03-30', INTERVAL 4 WEEK), '2023-04-16', 1, 17, TRUE),
('2023-06-03', DATE_ADD('2023-06-03', INTERVAL 4 WEEK), '2023-07-03', 2, 14, TRUE),
('2023-05-25', DATE_ADD('2023-05-25', INTERVAL 4 WEEK), '2023-08-08', 11, 7, TRUE);

/* iv. updates 'in_stock' column of books table to show which books are in stock */
/* Uses UPDATE with a nested query */
UPDATE books
SET in_stock = FALSE
WHERE
book_id IN (SELECT book_id FROM borrowed_books WHERE returned = FALSE);

/* v. uses ALTER to add books_borrowed column to 'wizards' table to show how many books wizards have borrowed */
ALTER TABLE wizards
ADD COLUMN books_borrowed INTEGER DEFAULT 0;  -- sets number of books borrowed to default 0

/* vi. UPDATE statement to modify 'books_borrowed' column of the 'wizards' table. */

/*COUNT used to calculate number of borrowed books for each wizard.*/
/*Subquery result assigned to the 'books_borrowed' column in the 'wizards' table */

UPDATE wizards w
SET books_borrowed = (
	SELECT COUNT(bb.borrowed_id)
    FROM borrowed_books bb
    WHERE bb.wizard_id = w.wizard_id
);

/* vii. creates new empty table overdue_books */
CREATE TABLE overdue_books (
overdue_id SERIAL PRIMARY KEY,
wizard_id INTEGER REFERENCES wizards(wizard_id),
book_id INTEGER REFERENCES books(book_id),
due_date DATE,
return_date DATE,
fine_amount DECIMAL(6,2)
);

/* viii. populates overdue_books using UNION operator*/
-- books that have been overdue and now returned
INSERT INTO overdue_books (wizard_id, book_id, due_date, return_date)
SELECT bb.wizard_id, bb.book_id, bb.due_date, bb.return_date
FROM borrowed_books bb
WHERE bb.due_date < bb.return_date   -- selects books where due date is earlier than return date
UNION
-- books that are currently overdue and not yet returned
SELECT
bb.wizard_id, bb.book_id, bb.due_date, NULL as return_date
FROM borrowed_books bb
WHERE bb.due_date < NOW() AND bb.returned = FALSE; -- selects currently overdue books

/* ix. creates new empty table book_value */
CREATE TABLE book_value (
value_id SERIAL PRIMARY KEY,
book_id INTEGER REFERENCES books(book_id),
replacement_cost DECIMAL(5,2));

/* x. adds data to table book_value */
INSERT INTO book_value
(book_id, replacement_cost)
VALUES
(1, 45.92),
(2, 45.92),
(3, 67.41),
(4, 126.59),
(5, 367.00),
(6, 10.99),
(7, 11.99),
(8, 27.89),
(9, 3.45),
(10, 12.30),
(11, 13.59),
(12, 6.79),
(13, 3.25),
(14, 123.45),
(15, 34.56),
(16, 12.50),
(17, 99.99),
(18, 57.98),
(19, 358.99),
(20, 278.95);

/* optional queries to check changes i to viii made:
SELECT * FROM books;    -- to check in_stock column added and updated based on availability
SELECT * FROM borrowed_books;   -- to check returned column and new data added
SELECT * FROM wizards;   -- to check books_borrowed column added and updated based on no of books
SELECT * FROM overdue_books;   -- to check new empty table created
SELECT * FROM book_value;   -- to check new book_value table and data*/

/* New scenarios*/
 
/* Scenario 9 - retrieve in stock books by Charles Spellkens */
SELECT book_id, book_title
FROM books
WHERE author_name = 'Charles'
AND author_surname = 'Spellkens'
AND in_stock = 1;   -- returns A Tale of Two Cauldrons, Great Enchantments and Mystic Manor

/* Scenario 10 - magical marketing campaign*/

/* i) - using aggregate function MAX() to determine which wizard/s has borrowed the most books, with nested 
sub-query */
SELECT wizard_id, wizard_name, first_name, last_name, age, books_borrowed
FROM wizards
WHERE books_borrowed = (SELECT MAX(books_borrowed) FROM wizards);  -- returns TheEnchanter and HocusTheMysticSmith

/* ii) using aggregate function MIN() to determine which wizard/s has borrowed the fewest books, with nested 
sub-query.*/
SELECT wizard_id, wizard_name, first_name, last_name, age, books_borrowed
FROM wizards
WHERE books_borrowed = (SELECT MIN(books_borrowed) FROM wizards);  -- returns 6 wizards who have never borrowed books

/* iii) using INNER JOIN and COUNT() to determine most popular books based on total number of borrows */
SELECT b.book_id, b.book_title, b.author_surname, COUNT(*) AS total_borrows
FROM books b
INNER JOIN borrowed_books bb ON b.book_id = bb.book_id
GROUP BY b.book_id, b.book_title, b.author_surname
ORDER BY total_borrows DESC;    -- The Mystical Garden is most popular with 3 borrows

/* Scenario 11 - building an automated library management system*/

/* i) uses aggregate function AVG() to calculate difference between return data and borrow date for
each borrowed book, then calculates the average of those differences. Returns single value representing
average borrowing duration in days*/

SELECT AVG(DATEDIFF(bb.return_date, bb.borrow_date)) AS average_duration
FROM borrowed_books bb;    -- average is 42.6 days

/* ii) to follow */

/* iii) calculates fines for all overdue books, both those returned and those still out (10p per day) plus
cost of missing book if overdue > 6 months*/
UPDATE overdue_books
SET fine_amount = 
CASE
    WHEN return_date IS NOT NULL THEN    -- for books that have been returned but were overdue
        CASE
            WHEN DATEDIFF(return_date, due_date) <= 7 * 26  -- books less than 6 months overdue
            THEN DATEDIFF(return_date, due_date) * 0.10  -- days overdue * 10 pence
            ELSE (7 * 26 * 0.10) +    -- 6 month overdue fine plus replacement cost of the book
            (SELECT replacement_cost FROM book_value bv WHERE bv.book_id = overdue_books.book_id)
        END
    ELSE  -- for books still not returned and overdue
        CASE
            WHEN DATEDIFF(NOW(), due_date) <= 7 * 26  -- books less than 6 months overdue
            THEN DATEDIFF(NOW(), due_date) * 0.10  -- days overdue * 10 pence
            ELSE (7 * 26 * 0.10) +   -- 6 month overdue fine plus replacement cost of book
            (SELECT replacement_cost FROM book_value bv WHERE bv.book_id = overdue_books.book_id)
        END
	END
WHERE return_date > due_date  -- returned late
OR due_date < NOW();  -- still not returned and overdue

/* optional query to check table overdue_books 
SELECT * FROM overdue_books; */

/* iv) Adds a fine_paid column to the overdue_books table, sets default value as FALSE */
ALTER TABLE overdue_books
ADD COLUMN fine_paid BOOLEAN DEFAULT FALSE;
/* optional query to check table overdue_books 
SELECT * FROM overdue_books; */

/* updates table to set fine_paid to TRUE for specified overdue_id values */
UPDATE overdue_books
SET fine_paid = TRUE
WHERE overdue_id = 1 OR overdue_id = 3 OR overdue_id = 4;
/* optional query to check table overdue_books 
SELECT * FROM overdue_books; */

/* deletes rows where the fine has been paid, i.e. is TRUE */
DELETE FROM overdue_books
WHERE fine_paid = TRUE;
/* optional query to check table overdue_books 
SELECT * FROM overdue_books; */
