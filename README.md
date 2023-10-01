# Assignment3_SQL

## Summary of project ##

* This is my third assignment for the CFG Software Engineering Degree, covering data and MySQL.

* This assignment was designed and written using MySQL Workbench. It comprises three main files containing queries covering the assignment's main criteria, the main purpose of which is *to solve a specific problem as per your chosen theme.*

* My overarching scenario of use is as follows: You are a librarian in a magical library and need to manage the library stock for your wizarding customers. Books are classified by genre and some are restricted and are only allowed to be borrowed by fully qualified (advanced) wizards. There are a number of different use scenarios that I outline in the 'usage' section, designed to provide problems that can be solved using SQL queries and by modifying the database/its tables.

## Installation ##

* You need to use MySQL Workbench to run three files.

## Usage ##

* The three key files need to be run in the correct order. This is because queries in the second and third files change the tables in the first, in order to meet all the criteria of the assignment and deal with different scenarios of use.

* SQL in the first file can be executed in its entirety in one go, whereas the second and third need to be run in portions.

### File 1 - 'Assignment3_part1' ###

* This file can be executed in its entirety in one go, because it drops the database if it already exists and creates it again, as well as all the tables therein.
  
* This file creates the database and its main tables as follows:
  1. Wizards - contains information about the wizards who are registered with the library;
  2. Skill_level -  contains info about different skill levels which will relate to books that can be borrowed;
  3. Magic_ability - contains info about different types of ability that will relate to books that are recommended;
  4. Books - contains information about the books available to borrow from the library;
  5. Genre - types of books;
  6. Borrowed_books - sets out which books are borrowed and by which wizard, as well as the expected and actual date of return.

* NB tables ii, iii and v were origianlly part of bigger tables - 'Wizards' and 'Books' respectively - but through normalisation have now been split into their own tables and are now referenced as foreign keys (FK) in the 'Wizards', 'Books' and 'Borrowed_books' tables instead.

### File 2 - 'Assignment3_part2' ### 

* This file contains queries to retrieve data from the database/tables established in part 1. Because each query generates different results, the recommendation is to run this script one query at a time

* Each query is based on specific scenarios of use within the overarching scenario outlined in the 'summary' section - i.e. that you are a librarian in a magic library.

* **Scenario 1:** One of the teachers is setting up a reading list for their class. They want to know all the books (names and authors) that are registered to the library in the category of 'Dream magic'.
* **Scenario 2:** A wizard customer is looking for a book by a writer whose surname begins with 'B'. Or possibly 'P'. To be honest, the surname might just have the letter 'D' in it somewhere. They can't quite remember but they'd know if they heard the name. Can you help them?
* **Scenario 3:** That's it! It's one of the Broomte sisters. But now the wizard wants to know what kinds of books they write i.e. what the genres of the Broomte sisters' books?
* **Scenario 4:** You want to see a list of all wizards and their borrowed books, including wizards who haven't borrowed any books. You want the information to be ordered by the wizard's unique ID, and if a wizard does not have a book out, you will see them in the results but with the book_title returned as NULL.
* **Scenario 5:** You want to get a list of the wizards who are able to borrow restricted books. They have to be 14 or over, with a skill level of advanced or teacher.
* **Scenario 6:** You are organising a book club evening on the theme of potion making and encantations. Which wizards should you ask to speak at the evening? All speakers must be aged 14 or over.
* **Scenario 7:** And for this same evening, which books might you wish to have out on display? Anyone can come to this event so you had better avoid anything restricted!!
* **Scenario 8:** You need to chase those wizards who have overdue books. Find out the wizard id and first name of those wizards late to return their books, the date it had been due back, and  which books are late, so that you have the key information to contact them. Finally, order the results by most overdue books first, to prioritise these.

### File 3 - 'Assignment3_part3' ### 

* This file makes changes to some of the original tables using ALTER and DELETE, which in turn allows new queries to be made. Because the tables need to be modified before the new queries are made, and because each query generates different results, the recommendation is to run this scripe one query at a time.
  
* Key changes using ALTER is as follows:
  
  1. Adding a column for book availability to the 'books' table (initial default set as TRUE - in stock);
  2. Adding a column showing whether a book has been returned to the 'borrowed_books' table (initial default set as FALSE - not returned);
  3. Adding a column to track the number of books borrowed by each wizard to the 'wizards' table;
  4. Adding a new table (table vii) called overdue_books;
  5. Adding a new table (table viii) book_value.

* These modified tables enable new scenarios and queries to be made, including DELETE. Again, these all relate to the overarching scenario of being a librarian in a magic library.

* **Scenario 9:** One of your customers has asked for a book by Charles Spellkens, and wants to check if there are any in stock. You want to determine the availability of books by this author.
* **Scenario 10:** You want to develop a magical marketing campaign to encourage all wizards to use the library. There are a number of components to your campaign:
  1. Firstly, working out which wizard/s has borrowed the greatest number of books, to ask them to be the poster wizard for your campaign.
  2. Secondly, you want to determine which wizard/s has borrowed the fewest books, in order to target this campaign at them.
  3. Finally, you want to work out the most popular book/s based on total number of borrows, to use this in your planned publicity materials.
* **Scenario 11:** You want to do some more work to stop books going overdue.
* [NB this needs more work but there will be something using new table to insert record when a book becomes overdue. When the book is returned then the record will be removed (deleted from this table). May use a stored procedure of function here - this would encapsulate the logic for inserting/deleting records into a single, reusable code block.
* Possibly -
  1. checking average length of borrowing (both for returned books and those not yet returned to determine what is reasonable point at which to chase)
  2. if overdue triggers alert to librarian
  3. if overdue by over a month, then start to incur charges
  4. if lost then fine is cost of book plus charges
  5. when book returned then fine is 10% cost of book plus charges
  6. once fine is issued delete the record
