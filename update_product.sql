USE [ISYS4283];
GO
IF OBJECT_ID('dbo.update_product', 'p') IS NULL
    EXEC('CREATE PROCEDURE update_product AS SELECT 1')
GO
ALTER PROCEDURE update_product 
	@product INT,
	@name NVARCHAR(255) = NULL,
	@price MONEY = NULL,
	@description NVARCHAR(MAX) = NULL,
	@image VARCHAR(255) = NULL
AS
SET NOCOUNT ON
	-- validate product ID belongs to vendor
	DECLARE @pid INT
	SET @pid = (
		SELECT id
		FROM products
		WHERE id = @product
		  AND vendor = SYSTEM_USER
	)
	IF @pid IS NULL
		THROW 51000, 'The product does not exist.', 16;

	IF @name IS NOT NULL
		BEGIN TRY
			UPDATE products SET name = @name
			WHERE id = @product
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH

	IF @price IS NOT NULL
		BEGIN TRY
			UPDATE products SET price = @price
			WHERE id = @product
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH

	IF @description IS NOT NULL
		BEGIN TRY
			UPDATE products SET description = @description
			WHERE id = @product
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH

	IF @image IS NOT NULL
		BEGIN TRY
			UPDATE products SET image = @image
			WHERE id = @product
		END TRY
		BEGIN CATCH
			THROW;
		END CATCH

	-- audit
	INSERT INTO products_audit (product, name, price, description, image, vendor)
	VALUES (@product, @name, @price, @description, @image, SYSTEM_USER)
GO

GRANT EXECUTE ON update_product TO ISYS4283vendors;
GO
