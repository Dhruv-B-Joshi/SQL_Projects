-- Creating the required tables
CREATE TABLE authors (
id_ SMALLINT,
FirstName VARCHAR(10),
LastName VARCHAR(10),
PRIMARY KEY(id_)
);

INSERT INTO authors VALUES
(11, 'Ellen', 'Writter'),(12, 'Olga', 'Savelivea'),(13, 'Jack', 'Smart'),(14, 'Donald', 'Brain'),(15, 'Yao', 'Dou');

SELECT * FROM authors;

CREATE TABLE editors (
id_ SMALLINT,
FirstName VARCHAR(10),
LastName VARCHAR(10),
PRIMARY KEY(id_));

INSERT INTO editors VALUES 
(21, 'Daniel', 'Brown'),(22, 'Mark', 'Johnson'),(23, 'Marina', 'Evans'),
(24, 'Catherine', 'Roberts'),(25, 'Sebastian', 'Wright'),(26, 'Barbra', 'Jones'),(27, 'Mathew', 'Smith');

SELECT * FROM editors;

CREATE TABLE translators (
id_ SMALLINT,
FirstName VARCHAR(10),
LastName VARCHAR(10),
PRIMARY KEY(id_));

INSERT INTO translators VALUES 
(31, 'Ira', 'Davis'),(32, 'Ling', 'Weng'),(33, 'Kristian', 'Green'),(34, 'Roman', 'Edwards');

SELECT * FROM translators;

CREATE TABLE books (
Book_id SMALLINT,
Title VARCHAR(25),
Book_type VARCHAR(10),
AuthorID SMALLINT,
EditorID SMALLINT,
TranslatorID SMALLINT, 
PRIMARY KEY(Book_id),
FOREIGN KEY(AuthorID) REFERENCES authors(id_) ON DELETE SET NULL,
FOREIGN KEY(EditorID) REFERENCES editors(id_) ON DELETE SET NULL,
FOREIGN KEY(TranslatorID) REFERENCES translators(id_) ON DELETE SET NULL
);

INSERT INTO books VALUES 
(1, 'Time to grow up!', 'Original', 11, 21, null),
(2, 'Your Trip', 'Translated', 15, 22, 32),
(3, 'Lovely Love', 'Original', 14, 24, null),
(4, 'Dream Your Life', 'Original', 11, 24, null),
(5, 'Oranges', 'Translated', 12, 25, 31),
(6, 'Your Happy Life', 'Translated', 15, 22, 33),
(7, 'Applied AI', 'Translated', 13, 23, 34),
(8, 'My Last Book', 'Original', 11, 27, null);

SELECT * FROM books;

-- #1: Showing books with their authors - Inner Join

SELECT b.book_id, b.title, a.FirstName, a.LastName
FROM books b
INNER JOIN authors a
ON b.authorid = a.id_
ORDER BY b.book_id;

-- #2: Showing books with their translators - Join(same as Inner Join)

SELECT b.book_id, b.title, b.book_type, t.lastname AS translator
FROM books b
JOIN translators t
ON b.translatorid = t.id_
ORDER BY b.book_id;

-- #3: Showing all books alongside their authors, editors and translators; if they exist - Left Join

SELECT b.book_id, b.title, b.book_type, a.lastname AS author,
e.lastname AS editor, t.lastname AS translator
FROM books b
LEFT JOIN authors a
ON b.authorid = a.id_
LEFT JOIN editors e
ON b.editorid = e.id_
LEFT JOIN translators t
ON b.translatorid = t.id_
ORDER BY b.book_id;

-- #4: Books and editors with RIGHT JOIN

SELECT b.book_id, b.title, e.lastname AS editor
FROM books b
RIGHT JOIN editors e
ON b.editorid = e.id_
ORDER BY b.book_id;

-- #5: Showing all books, authors, editors, and translators - FULL JOIN OR FULL OUTER JOIN

SELECT b.book_id, b.title, a.lastname AS author, e.lastname AS editor, t.lastname AS translator
FROM books b
FULL JOIN authors a
ON b.authorid = a.id_
FULL JOIN editors e
ON b.editorid = e.id_
FULL JOIN translators t
ON b.translatorid = t.id_
ORDER BY b.book_id;


