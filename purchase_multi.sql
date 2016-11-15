USE [ISYS4283];
GO

-- table valued parameter
IF TYPE_ID(N'product_quantity') IS NOT NULL
DROP TYPE dbo.product_quantity;

CREATE TYPE dbo.product_quantity AS TABLE
(
    product INT,
    quantity INT
);

DECLARE @pq product_quantity;
INSERT INTO @pq (product, quantity) VALUES (1,2);
SELECT * FROM @pq;

