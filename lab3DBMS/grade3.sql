USE Pharmacy
GO

CREATE OR ALTER PROCEDURE uspAddConsumer (@cname VARCHAR(30), @cpass VARCHAR(30), @ctype VARCHAR(30))
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM Consumer C WHERE C.username = @cname)
			BEGIN
				RAISERROR('Username already exists', 14, 1)
			END

			INSERT INTO Consumer VALUES (@cname, @cpass, @ctype);
			COMMIT TRAN
		END TRY
	BEGIN CATCH
		ROLLBACK tran
		print 'Transaction rollbacked'
	END CATCH
GO

EXEC uspAddConsumer 'dan', 'dan', 'admin'; 

SELECT * FROM Consumer

GO

CREATE OR ALTER PROCEDURE uspAddDrug (@name VARCHAR(30), @price INT, @form VARCHAR(30), @category INT)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM Drug D WHERE D.name = @name AND D.form = @form)
			BEGIN
				RAISERROR('Drug already exists', 14, 1)
			END

			INSERT INTO Drug VALUES (@name, @price, @form, @category);
			COMMIT TRAN
		END TRY
	BEGIN CATCH
		ROLLBACK tran
		print 'Transaction rollbacked'
	END CATCH
GO

EXEC uspAddDrug 'Vitamin C', 30, 'pills', 2; 

SELECT * FROM Drug

GO

CREATE OR ALTER PROCEDURE uspAddRequest (@desc VARCHAR(30), @name VARCHAR(30), @quantity INT, 
										@status VARCHAR(30), @deadline DATE, @cid INT, @did INT,
										@dname VARCHAR(30), @dprice INT, @dform VARCHAR(30), @dcat INT)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY
			DECLARE @drugid INT;
			SET @drugid = @did;
			IF NOT (EXISTS (SELECT * FROM Drug D WHERE D.did = @did))
			BEGIN
				BEGIN TRAN
				EXEC uspAddDrug @dname, @dprice, @dform, @dcat
				COMMIT TRAN
				SET @drugid = (SELECT D.did FROM Drug D WHERE @dname = D.name AND @dform = D.form)
				print @drugid
			END
			IF EXISTS (SELECT * FROM Request R WHERE R.cid = @cid AND R.deadline = @deadline AND R.rname = @name)
			BEGIN
				RAISERROR('Request already exists', 14, 1)
			END

			INSERT INTO Request VALUES (@desc, @name, @quantity, @status, @deadline, @drugid, @cid);
			COMMIT TRAN
		END TRY
	BEGIN CATCH
		ROLLBACK tran
		print ERROR_MESSAGE()
		print ERROR_PROCEDURE()
		print ERROR_LINE()
		print 'Transaction rollbacked'
	END CATCH
GO

 
EXEC uspAddRequest 'request3', 'request3', 20, 'processing', '2020-09-12', 2, 10, 'paracetamol', 30, 'pills', 1;

EXEC uspAddRequest 'req2', 'req2', 20, 'processing', '2020-07-21', 2, 5, 'drug6', 30, 'pills', 2; 

SELECT * FROM Drug

SELECT * FROM Request

GO

