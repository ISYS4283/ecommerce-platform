USE [ISYS4283];
GO
IF OBJECT_ID('dbo.issue_goods_receipt', 'p') IS NULL
    EXEC('CREATE PROCEDURE issue_goods_receipt AS SELECT 1')
GO
ALTER PROCEDURE issue_goods_receipt
	@product INT,
	@quantity INT
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

	-- create record
	INSERT INTO goods_receipts (product, quantity)
	VALUES (@product, @quantity)
GO

GRANT EXECUTE ON issue_goods_receipt TO ISYS4283vendors;
GO
