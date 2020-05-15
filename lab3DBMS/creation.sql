CREATE TABLE Consumer (
	cid INT PRIMARY KEY IDENTITY(1,1),
	username VARCHAR(30) NOT NULL,
	password VARCHAR(30) NOT NULL,
	type VARCHAR(30)
)

CREATE TABLE Category (
	catid INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(30)
)

--INSERT INTO Category VALUES ('antibiotics'), ('vitamins')
--SELECT * FROM Category

CREATE TABLE Drug (
	did INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(30) NOT NULL,
	price INT NOT NULL,
	form VARCHAR(30) NOT NULL,
	catid INT FOREIGN KEY REFERENCES Category(catid),
)

CREATE TABLE Request (
	rid INT PRIMARY KEY IDENTITY(1,1),
	descr VARCHAR(30),
	rname VARCHAR(30),
	quantity INT,
	rstatus VARCHAR(30),
	deadline DATE,
	did INT FOREIGN KEY REFERENCES Drug(did),
	cid INT FOREIGN KEY REFERENCES Consumer(cid),
)