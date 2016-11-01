USE [ISYS4283];
GO

IF OBJECT_ID('dbo.grant_role', 'p') IS NULL
    EXEC('CREATE PROCEDURE grant_role AS SELECT 1')
GO
ALTER PROCEDURE grant_role
AS
	SET NOCOUNT ON
	DECLARE @login CHAR(11)
	DECLARE @query NVARCHAR(255)

	IF DATABASE_PRINCIPAL_ID('ISYS4283vendors') IS NULL
		CREATE ROLE ISYS4283vendors;

	DECLARE MY_CURSOR CURSOR 
	  LOCAL STATIC READ_ONLY FORWARD_ONLY
	FOR 
	SELECT vendor 
	FROM logins

	OPEN MY_CURSOR
	FETCH NEXT FROM MY_CURSOR INTO @login
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @query = 'CREATE USER ' + @login + ' FROM LOGIN ' + @login
		EXEC sp_executesql @query
		EXEC sp_addrolemember 'ISYS4283vendors', @login
		FETCH NEXT FROM MY_CURSOR INTO @login
	END
	CLOSE MY_CURSOR
	DEALLOCATE MY_CURSOR
GO