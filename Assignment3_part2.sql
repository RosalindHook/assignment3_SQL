/* This file contains queries to retrieve data; each query is based on specific scenarios of use within the
overarching scenario outlined in part 1 - i.e. that of being a librarian in a magic library. See Readme file for
more information about specifics of each scenario.*/

USE magic_library;

/*Scenario 1 - setting up a reading list with all books about 'Dream magic'*/
/* uses INNER JOIN on genre_id in 'books' and 'genre' tables. Returns by surname in desc order */
SELECT b.book_id, b.book_title, b.author_name, b.author_surname
FROM books b
INNER JOIN genre g ON b.genre_id = g.genre_id
WHERE g.genre = 'Dream magic'
ORDER BY b.author_surname DESC;

/*Scenario 2 - searching for an unknown writer whose surname begins with 'B', 'P' or maybe just has 'D' in it*/
/* uses WHERE and LIKE to return results and orders by author surname in ascending order*/
SELECT b.book_id, b.book_title, b.author_name, b.author_surname
FROM books b
WHERE author_surname LIKE 'B%'
OR author_surname LIKE 'P%'
OR author_surname LIKE '%D%'
ORDER BY b.author_surname ASC;

/*Scenario 3 - determining the different genre types of the Broomte sisters' books */
/* uses DISTINCT to only return different genre types once. INNER JOIN on genre_id in 'books'/'genre' tables */
SELECT DISTINCT g.genre
FROM books b
INNER JOIN genre g ON b.genre_id = g.genre_id
WHERE b.author_surname LIKE 'Broomte%';

/* Scenario 4 - which books has each wizard borrowed? */
/* Uses two LEFT JOINs on borrowed_books and books tables. Returns NULL for wizards without borrowed books*/
SELECT w.wizard_id, w.wizard_name, b.book_title
FROM wizards w
LEFT JOIN 
borrowed_books bb
ON w.wizard_id = bb.wizard_id
LEFT JOIN
books b
ON bb.book_id = b.book_id
ORDER BY w.wizard_id ASC;

/*Scenario 5 - wizards that can borrow restricted items (must be 14+ and with advanced/teacher skills)*/
/*INNER JOIN on skill_level in 'wizards' and 'skill_level' tables. WHERE statements for age and level */
SELECT w.wizard_id, w.wizard_name
FROM wizards w
INNER JOIN skill_level s ON w.skill_id = s.skill_id
WHERE w.age >= 14
AND
s.skill_level = 'Advanced' OR s.skill_level = 'Teacher'
ORDER BY w.wizard_name ASC;

/*Scenario 6 - book club speakers on potion making and encantations, and age >= 14 */
/*INNER JOIN magic_ability on 'wizards' and 'magic_ability' tables*/
SELECT w.wizard_id, w.wizard_name, w.first_name, w.last_name, m.magic_ability
FROM wizards w
INNER JOIN magic_ability m ON w.ability_id = m.ability_id
WHERE
w.age >= 14
AND
m.magic_ability = 'Encantations' OR m.magic_ability = 'Potion making'
ORDER BY w.wizard_name ASC;

/* Scenario 7 - retrieve books about spellcraft and potioncraft, avoiding restricted, order by author surname*/
SELECT b.book_id, b.book_title, b.author_name, b.author_surname, g.genre
FROM books b
INNER JOIN genre g ON b.genre_id = g.genre_id
WHERE
b.restricted = FALSE
AND
g.genre = 'Spellcraft' OR g.genre = 'Potioncraft'
ORDER BY b.author_surname ASC;

/* Scenario 8 - retrieve wizard_id and first_name of wizards with overdue books and names of books.
Ordered by most overdue books first. */

/* using multiple INNER JOINS between three tables*/
/* checks if due_date is before NOW() function */
SELECT w.wizard_id, w.first_name, b.book_title, bb.due_date
FROM wizards w
INNER JOIN borrowed_books bb ON w.wizard_id = bb.wizard_id
INNER JOIN books b ON bb.book_id = b.book_id
WHERE
bb.due_date < NOW()
ORDER BY bb.due_date ASC;
