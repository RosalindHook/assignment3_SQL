/* calculates fines for all overdue books, both those returned and those still out (10p per day) plus
cost of missing book if overdue > 6 months NB I aim to turn this into stored function */
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
