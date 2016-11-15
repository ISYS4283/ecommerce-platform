---- example:
--DECLARE @pq product_quantity;
--INSERT INTO @pq (product, quantity) VALUES (2,2),(4,2);
--EXEC [ISYS4283].[dbo].[purchase_multi] @pq;


USE [ISYS4283];
GO

IF OBJECT_ID('dbo.purchase_multi', 'p') IS NOT NULL
    DROP PROCEDURE purchase_multi;
IF TYPE_ID(N'product_quantity') IS NOT NULL
	DROP TYPE dbo.product_quantity;
GO

-- table valued parameter
CREATE TYPE dbo.product_quantity AS TABLE
(
    product INT,
    quantity INT
);

-- stored procedure
GO
CREATE PROCEDURE purchase_multi
	@pq dbo.product_quantity READONLY,
	@vendor CHAR(11) = NULL
AS
	SET NOCOUNT ON

	-- set default user
	IF @vendor IS NULL
		SET @vendor = SYSTEM_USER

	-- start transaction
	BEGIN TRY
		BEGIN TRANSACTION
			-- create header
			INSERT INTO purchase_orders (vendor)
			VALUES (@vendor);
			DECLARE @poid INT;
			SET @poid = SCOPE_IDENTITY();

			DECLARE db_cursor CURSOR FOR SELECT product, quantity FROM @pq;
			DECLARE @product INT;
			DECLARE @quantity INT;

			-- iterate through table valued parameter for line items
			OPEN db_cursor;
			FETCH NEXT FROM db_cursor INTO @product, @quantity;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- validate product exists and does not belong to vendor
				DECLARE @pid INT
				SET @pid = (
					SELECT id
					FROM products
					WHERE id = @product
					  AND vendor != @vendor
				)
				IF @pid IS NULL
					THROW 51000, 'The product does not exist, or customer == vendor.', 16;

				-- insert line item
				INSERT INTO [po_lines] ([purchase_order], [product], [quantity])
				VALUES (@poid, @product, @quantity);

				FETCH NEXT FROM db_cursor INTO @product, @quantity;
			END;
			CLOSE db_cursor;
			DEALLOCATE db_cursor;
		COMMIT
	END TRY

	BEGIN CATCH
		ROLLBACK;
		THROW
	END CATCH
GO

GRANT EXECUTE ON purchase_multi TO ISYS4283vendors;
GO
