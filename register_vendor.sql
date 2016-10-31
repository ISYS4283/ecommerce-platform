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
	INSERT INTO vendors (id, name, description)
	VALUES (SYSTEM_USER, @name, @description);
GO
