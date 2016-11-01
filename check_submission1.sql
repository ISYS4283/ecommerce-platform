USE [ISYS4283];
GO
IF OBJECT_ID('dbo.check_submission1', 'p') IS NULL
    EXEC('CREATE PROCEDURE check_submission1 AS SELECT 1')
GO
ALTER PROCEDURE check_submission1
	@vendor CHAR(11) = NULL
AS
	SET NOCOUNT ON
	IF @vendor IS NULL
		SET @vendor = SYSTEM_USER

	-- registered
	DECLARE @ven CHAR(11)
	SET @ven = (
		SELECT id
		FROM vendors
		WHERE id = @vendor
	)
	IF @ven IS NULL
		THROW 50001, 'Vendor is not registered.', 1;

	-- product
	DECLARE @count_products INT
	SET @count_products = (
		SELECT COUNT(id)
		FROM products
		WHERE vendor = @vendor
	)
	IF @count_products < 1
		THROW 50002, 'No products created.', 1;

	-- goods receipt
	DECLARE @count_gr INT
	SET @count_gr = (
		SELECT COUNT(product)
		FROM goods_receipts
		WHERE product IN (
			SELECT id
			FROM products
			WHERE vendor = @vendor
		)
	)
	IF @count_gr < 1
		THROW 50003, 'No goods receipts created.', 1;

	-- purchase
	DECLARE @count_po INT
	SET @count_po = (
		SELECT COUNT(id)
		FROM purchase_orders
		WHERE vendor = @vendor
	)
	IF @count_po < 1
		THROW 50004, 'No purchase orders created.', 1;

	-- approve
	DECLARE @count_po_app INT
	SET @count_po_app = (
		SELECT COUNT(id)
		FROM purchase_orders
		WHERE vendor = @vendor
		  AND approved IS NOT NULL
	)
	IF @count_po_app < 1
		THROW 50005, 'No approved purchase orders.', 1;

	-- success: made it through gauntlet
	PRINT 'Congratulations, all checks passed!'
GO

GRANT EXECUTE ON check_submission1 TO ISYS4283vendors;
GO
