USE [ISYS4283];
GO
IF OBJECT_ID('dbo.approve_po', 'p') IS NULL
    EXEC('CREATE PROCEDURE approve_po AS SELECT 1')
GO
ALTER PROCEDURE approve_po
	@po INT
AS
	SET NOCOUNT ON
	-- validate po exists and belongs to vendor
	DECLARE @pid INT
	SET @pid = (
		SELECT id
		FROM purchase_orders
		WHERE id = @po
		  AND vendor = SYSTEM_USER
	)
	IF @pid IS NULL
		THROW 51000, 'The purchase order does not exist.', 16;

	-- create header
	UPDATE purchase_orders
	SET approved = GETDATE()
	WHERE id = @po
GO

GRANT EXECUTE ON approve_po TO ISYS4283vendors;
GO
