/* Run this file to establish the database and its 6 core tables. Scenario of use is librarian in a magic library.
More information is available in the related ReadMe file.*/

DROP DATABASE IF EXISTS magic_library;

CREATE DATABASE magic_library;
USE magic_library;

/* Wizard related tables x 3 */
/* Wizards' magic abilities table */
CREATE TABLE magic_ability (
	ability_id SERIAL PRIMARY KEY,   -- Unique identifier for magic abilities
	magic_ability VARCHAR(50) NOT NULL   -- Name of magic ability
);

/* Wizards' skill levels table */
CREATE TABLE skill_level (
	skill_id SERIAL PRIMARY KEY,
	skill_level VARCHAR(50) NOT NULL
);

/* Main wizard info table */
CREATE TABLE wizards (
	wizard_id SERIAL PRIMARY KEY,
	wizard_name VARCHAR(100) UNIQUE NOT NULL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	age SMALLINT NOT NULL,
	skill_id INTEGER REFERENCES skill_level(skill_id),   -- establishes FK relationship with skills table
    ability_id INTEGER REFERENCES magic_ability(ability_id)   -- establishes FK relationship with ability table
);

/* Book stock related tables x 2 */
/* Type of books */
CREATE TABLE genre (
	genre_id SERIAL PRIMARY KEY,
	genre VARCHAR(50)
);

/* Main books table */
CREATE TABLE books (
	book_id SERIAL PRIMARY KEY,
	book_title VARCHAR(250),
	author_name VARCHAR(50),
	author_surname VARCHAR(50) NOT NULL,
	genre_id INTEGER REFERENCES genre(genre_id),    -- FK relationship with genre table
	restricted BOOLEAN
);

/* 1 x table relating wizards to borrowed books */
CREATE TABLE borrowed_books (
	borrowed_id SERIAL PRIMARY KEY,
	borrow_date DATE,
	due_date DATE,
    return_date DATE,
	wizard_id INTEGER REFERENCES wizards(wizard_id),   -- FK with wizards table
	book_id INTEGER REFERENCES books(book_id)    -- FK with books table
);

/* Queries x 6 to insert data into created tables NB SERIAL PRIMARY KEYS insert automatically */
/* Insert magic levels */
INSERT INTO skill_level
(skill_level) 
VALUES 
('Beginner'),
('Intermediate'),
('Advanced'),
('Teacher')
;

/* Insert magic abilities */
INSERT INTO magic_ability
(magic_ability)
VALUES
('Encantations'),
('Flight'),
('Potion making'),
('Dark arts'),
('Invisibility'),
('Shape-shifting'),
('Hypnotic song');

/* Insert wizard ID data */
INSERT INTO wizards
(wizard_name, first_name, last_name, age, skill_id, ability_id)
VALUES
('TheEnchanter','Fiendish','Finnegan',3,1,4),
('HocusTheMysticSmith','Hocus','Smith',11,1,1),
('JonesTheDiabolical','Diabolism','Jones',40,2,4),
('AlchemyWizAndrews','Alchemy','Andrews',371,3,3),
('TheFascinatingSorcerer','Fascinating','Finnegan',597,4,4),
('DestinedToDivine','Divinity','Destiny',5,1,1),
('MerlinTheEnigmatic','Merlin','McDonald',75,1,2),
('AuroraSpellWeaver','Aurora','Carey',13,2,7),
('IridessaMoonDancer','Iridessa','Moon',218,4,7),
('MerryweatherTheMystical','Merryweather','MacMichael',12,3,6),
('PixieParkerTheSorceress','Pixie','Parker',14,2,2),
('NerissaTheArcane','Nerissa','Taylor',56,2,7),
('OldCrone', 'Neithhotep',null,5023,4,1);

/* Insert different books types */
INSERT INTO genre
(genre) 
VALUES 
('Spellcraft'),
('Potioncraft'),
('Dream magic'),
('Enchanted creatures'),
('Dark magic');

INSERT INTO books 
(book_title,author_name,author_surname,genre_id,restricted)
VALUES
('Wizarding Heights','Emily','Broomte',1,FALSE),
('Pride and Potions','Jane','Alchemist',2,FALSE),
('Moby Witch','Herman','Spellville',1,FALSE),
('An Enchanted Chamber of Ones Own','Virginia','Werewoolf',3,FALSE),
('To the Labyrinth','Virginia','Werewoolf',3,FALSE),
('The Importance of Being Ursamancer','Oscar','Weird',4,FALSE),
('The Haunting of Dorian Shade','Oscar','Weird',5,TRUE),
('Jane Eerie', 'Charlotte', 'Broomte',	5,	TRUE),
('The Phantom of Wildfell Hall', 'Emily', 'Broomte', 5,	FALSE),
('The Sorceror of Casterbridge', 'Thomas', 'Hexley', 1, FALSE),
('Jude the Uncanny', 'Thomas', 'Hexley', 5, FALSE),
('A Tale of Two Cauldrons',	'Charles', 'Spellkens',	2, FALSE),
('Great Enchantments', 'Charles', 'Spellkens', 1, FALSE),
('Mystic Manor', 'Charles',	'Spellkens', 3,	FALSE),
('Haunted Times', 'Charles', 'Spellkens', 5, TRUE),
('The Mystical Garden', 'Frances', 'Haunted', 3, FALSE),
('Clairvoyance and Palmistry', 'Fyodor', 'Mysticdovski', 3, TRUE),
('The Hobgoblins Tale',	'Margaret',	'Anansi', 4, FALSE),
('The Illusion', null, 'Hocus', 5, TRUE),
('The Odd-Divination', null, 'Hocus', 3, FALSE)
;

/* Use of DATE_ADD function to calculate return dates 4 weeks after borrowing, and NOW() function to get current 
date and time */
INSERT INTO borrowed_books
(borrow_date, due_date, return_date, wizard_id, book_id)
VALUES
('2021-03-28', DATE_ADD('2021-03-28', INTERVAL 4 WEEK), null, 5, 7),
('2021-03-28', DATE_ADD('2021-03-28', INTERVAL 4 WEEK),	null, 5, 15),
(NOW(), DATE_ADD(NOW(), INTERVAL 4 WEEK), null, 5, 19),
('2023-09-13', DATE_ADD('2023-09-13', INTERVAL 4 WEEK),	null, 9,16),
('2023-09-20', DATE_ADD('2023-09-20', INTERVAL 4 WEEK),	null, 9,17),
('2022-12-25', DATE_ADD('2022-12-25', INTERVAL 4 WEEK),	null, 8, 5),
(NOW(), DATE_ADD(NOW(), INTERVAL 4 WEEK), null, 2, 1),
(NOW(), DATE_ADD(NOW(), INTERVAL 4 WEEK), null, 2, 2),
(NOW(), DATE_ADD(NOW(), INTERVAL 4 WEEK), null, 2, 3),
(NOW(), DATE_ADD(NOW(), INTERVAL 4 WEEK), null, 2, 4);

/* optional queries to check that all tables are created and populated with correct data
SELECT * FROM wizards;
SELECT * FROM magic_ability;
SELECT * FROM skill_level;
SELECT * FROM books;
SELECT * FROM genre;
SELECT * FROM borrowed_books; */
