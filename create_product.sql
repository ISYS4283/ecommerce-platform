USE [ISYS4283];
GO
IF OBJECT_ID('dbo.create_product', 'p') IS NULL
    EXEC('CREATE PROCEDURE create_product AS SELECT 1')
GO
ALTER PROCEDURE create_product 
	@name NVARCHAR(255),
	@price MONEY,
	@description NVARCHAR(MAX) = NULL,
	@image VARCHAR(255) = NULL
AS
SET NOCOUNT ON
	INSERT INTO products (name, price, description, image, vendor)
	VALUES (@name, @price, @description, @image, SYSTEM_USER)

	-- audit
	IF(@@ROWCOUNT > 0)
	INSERT INTO products_audit (product, name, price, description, image, vendor)
	VALUES (SCOPE_IDENTITY(), @name, @price, @description, @image, SYSTEM_USER)
GO

GRANT EXECUTE ON create_product TO ISYS4283vendors;
GO
