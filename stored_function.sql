/* I have removed this as more suitable as stored procedure, but keeping the code here for info to view its logic */

/* iii) creates stored function to calculate fine */
DELIMITER //

CREATE FUNCTION calculate_fine(
	in_return_date DATE,
    in_due_date DATE,
    in_book_id int
)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	DECLARE fine DECIMAL(10,2);
    
    IF in_return_date IS NOT NULL THEN -- e.g. for books that have been returned but were overdue
		IF DATEDIFF(in_return_date, in_due_date) <= 7 * 26 THEN -- books less than 6 months overdue
			SET fine = DATEDIFF(in_return_date, in_due_date) * 0.10; -- days overdue * 10 pence
		ELSE -- for books more than 6 months overdue
			SET fine = (7 * 26 * 0.10) + (
				SELECT replacement_cost FROM book_value WHERE book_id = in_book_id
			);
		END IF;
	ELSE -- for books that have not yet been returned and are overdue
		IF DATEDIFF(NOW(), in_due_date) <= 7 * 26 THEN -- books less than 6 months overdue
			SET fine = DATEDIFF(NOW(), in_due_date) * 0.10;
		ELSE -- for books more than 6 months overdue
			SET fine = (7 * 26 * 0.10) + (
				SELECT replacement_cost FROM book_value WHERE book_id = in_book_id
			);
		END IF;
	END IF;
    
    RETURN fine;
END;
//

DELIMITER ;
