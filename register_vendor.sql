USE [ISYS4283];
GO
IF OBJECT_ID('dbo.register_vendor', 'p') IS NULL
    EXEC('CREATE PROCEDURE register_vendor AS SELECT 1')
GO
ALTER PROCEDURE register_vendor 
	@name NVARCHAR(255) = NULL,
	@description NVARCHAR(MAX) = NULL
AS
SET NOCOUNT ON
	-- check if vendor exists
	DECLARE @ovender CHAR(11);
	SET @ovender = (SELECT id FROM vendors WHERE id = SYSTEM_USER);

	-- create new vendor
	IF @ovender IS NULL
		BEGIN
			INSERT INTO vendors (id, name, description)
			VALUES (SYSTEM_USER, @name, @description)
		END
	ELSE
		BEGIN
			UPDATE vendors
			SET name = @name, description = @description
			WHERE id = @ovender
		END
GO
