USE Pharmacy
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

CREATE OR ALTER PROCEDURE uspAddRequest2 (@desc VARCHAR(30), @name VARCHAR(30), @quantity INT, 
										@status VARCHAR(30), @deadline DATE, @cid INT,
										@dname VARCHAR(30), @dprice INT, @dform VARCHAR(30), @dcat INT)
AS
	SET NOCOUNT ON;
	DECLARE @drugid INT;
	BEGIN TRAN
		EXEC uspAddDrug @dname, @dprice, @dform, @dcat
		SET @drugid = (SELECT D.did FROM Drug D WHERE D.name = @dname AND D.form = @dform)
		print @drugid
	COMMIT TRAN
	BEGIN TRY
		BEGIN TRAN
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


EXEC uspAddRequest2 'req99', 'req99', 20, 'processing', '2020-07-20', 1, 'drug100', 30, 'pills', 1; 

EXEC uspAddRequest2 'req2', 'req2', 20, 'processing', '2020-07-21', 2, 'drug99', 30, 'pills', 1; 

SELECT * FROM Drug

SELECT * FROM Request

GO

