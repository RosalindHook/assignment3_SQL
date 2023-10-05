# Assignment3_SQL

## Summary of project ##

* This is my third assignment for the CFG Software Engineering Degree, covering data and MySQL.

* This assignment was designed and written using MySQL Workbench. It comprises three main .sql files containing queries covering the assignment's main criteria, the main purpose of which is *"to solve a specific problem as per your chosen theme."*

* My overarching scenario of use is as follows: You are a librarian in a magical library and need to manage the library stock for your wizarding customers. Books are classified by genre and some are restricted and are only allowed to be borrowed by fully qualified (advanced) wizards. There are a number of different use scenarios that I outline in the 'usage' section, designed to provide real-life (albeit magical) problems that can be solved using SQL queries and by modifying the database/its tables.

## Installation ##

* To run this project, you need to have MySQL Workbench installed.

## Usage ##

* The three key files need to be run in the correct order. This is because queries in the second and third files change the tables in the first to meet all the assignment criteria and address different use scenarios.

### File 1 - 'Assignment3_part1' ###

* This file can be executed in its entirety in one go, as it drops the database if it already exists and recreates it, along with all the necessary tables:
  1. Wizards - contains information about registered wizards;
  2. Skill_level -  contains information about different skill levels relating to book borrowing;
  3. Magic_ability - contains information about different types of ability related to recommended books;
  4. Books - contains information about library book stock;
  5. Genre - types of books;
  6. Borrowed_books - records which books are borrowed and by which wizard, along with the expect and actual return dates.

* Tables II, III and V were origianlly part of larger tables ('Wizards' and 'Books') but have been normalised and split into their own tables. Their data are now referenced as foreign keys (FK) in the 'Wizards', 'Books' and 'Borrowed_books' tables instead.

### File 2 - 'Assignment3_part2' ### 

* This file contains queries to retrieve data from the database/tables established in File 1. To get the desired results, it's recommended to run each query one at a time.

* **Scenario 1:** Retrieve all books (names and authors) in the 'Dream Magic' category, to help a teacher to write a reading list for their Dreams class.
  
* **Scenario 2:** Help a wizard customer find a book by a writer whose surname begins with 'B', 'P', or possibly just has the letter 'D' in it. They can't remember any more details than that.
  
* **Scenario 3:** Discover the unique genres of books written by the Broomte sisters.
  
* **Scenario 4:** List all wizards and their borrowed books, including wizards with no borrowed books, ordered by unique wizard ID.

* **Scenario 5:** Find wizards eligible to borrow restricted books (age 14 or older, skill level advanced or teacher).

* **Scenario 6:** Identify wizards to speak at a book club evening on potion making and encantations (age 14 or older).

* **Scenario 7:** Select books for display at the book club evening, excluding restricted books.

* **Scenario 8:** Identify wizards with overdue books, incluing the date the books were due and listing the most overdue books first.

### File 3 - 'Assignment3_part3' ### 

* This file modifies original tables from File 1 using ALTER and DELETE, enabling new queries. Run each query one at a time.
  
* Key changes include:
  
  1. Adding a column for book availability to the 'books' table (initial default set as TRUE - in stock);
  2. Adding a column indicating whether a book has been returned to the 'borrowed_books' table (initial default set as FALSE - not returned);
  3. Adding more data to borrowed_books table to include returned books;
  4. Updating the 'in_stock' column of 'books' table to reflect availability;
  5. Adding a column to track the number of books borrowed by each wizard to the 'wizards' table;
  6. Updating the 'books_borrowed' column to count the number of books borrowed by each wizard;
  7. Creating a new table 'overdue_books' with a 'fine_amount' column;
  8. Using stored procedure to populate 'overdue_books' table with information about all overdue books;
  9. Adding a new table 'book_value'; and
  10. Populating 'book_value' table with replacement costs linked to the 'books' table via book_id (FK).

* These modified tables enable new scenarios and queries, including a DELETE query for when data becomes obsolete:

* **Scenario 9:** Check the availability of books by Charles Spellkens for a customer.

* **Scenario 10:** Develop a marketing campaign for the library. There are a number of components:
  1. Calculating which wizard/s has borrowed the greatest number of books, to ask them to be the poster wizard for your campaign.
  2. Determining which wizard/s has borrowed the fewest books, in order to target this campaign at them.
  3. Determining the most popular book/s based on total number of borrows, to use this in your planned publicity materials.

* **Scenario 11:** Tackle issue of overdue books. Key aspects of this project include:
  1. Analysing borrowing duration: calculate the average borrowing duration for all books (whether returned or still on loan). This analysis is intended to support determining a reasonable timeframe for chasing overdue books;
  2.  Use a daily event to call the overdue checks procedure;
  2. Calculating fines stored function: This is based on a rate of 10 pence per day, but if the amount of time taken to return the book is greater than 26 weeks (6 months) then it will be assumed missing. In this scenario the fine to the borrower will be capped at 10 pence * 182 days (26 weeks) PLUS the cost of the missing book.
  5. Adding a BOOLEAN column to overdue_books to show whether fine is paid or not; and
  6. If the fine has been paid, DELETING the data from that row.
