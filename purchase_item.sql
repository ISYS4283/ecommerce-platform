USE [ISYS4283];
GO
IF OBJECT_ID('dbo.purchase_item', 'p') IS NULL
    EXEC('CREATE PROCEDURE purchase_item AS SELECT 1')
GO
ALTER PROCEDURE purchase_item
	@product INT,
	@quantity INT,
	@vendor CHAR(11) = NULL
AS
	SET NOCOUNT ON
	IF @vendor IS NULL
		SET @vendor = SYSTEM_USER

	-- validate product exists and does not belong to vendor
	DECLARE @pid INT
	SET @pid = (
		SELECT id
		FROM products
		WHERE id = @product
		  AND vendor != @vendor
	)
	IF @pid IS NULL
		THROW 51000, 'The product does not exist.', 16;

	-- create header
	INSERT INTO purchase_orders (vendor)
	VALUES (@vendor)

	-- create line item
	INSERT INTO po_lines (purchase_order, product, quantity)
	VALUES (SCOPE_IDENTITY(), @product, @quantity)
GO

GRANT EXECUTE ON purchase_item TO ISYS4283vendors;
GO
