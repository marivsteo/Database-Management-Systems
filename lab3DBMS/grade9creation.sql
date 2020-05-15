USE testdb
GO

DROP TABLE IF EXISTS Table1
CREATE TABLE Table1 (
	id INT IDENTITY,
	name VARCHAR(20),
	somestr VARCHAR(20)
);

DROP TABLE IF EXISTS Table2
CREATE TABLE Table2 (
	id INT IDENTITY,
	name VARCHAR(20),
	someint INT
);

INSERT INTO Table1(name, somestr) VALUES ('name1', 'testval');
INSERT INTO Table2(name, someint) VALUES ('name2', 10); 

SELECT * FROM Table1
SELECT * FROM Table2

GO