DROP TABLE po_lines;
DROP TABLE purchase_orders;
DROP TABLE goods_receipts;
DROP TABLE products_audit;
DROP TABLE products;
DROP TABLE vendors_audit;
DROP TABLE vendors;

CREATE TABLE vendors (
	id CHAR(11) PRIMARY KEY,
	name NVARCHAR(255),
	description NVARCHAR(MAX)
);
INSERT INTO vendors (id) VALUES ('jeff');

CREATE TABLE vendors_audit (
	id INT IDENTITY PRIMARY KEY,
	vendor CHAR(11) NOT NULL FOREIGN KEY REFERENCES vendors(id),
	name NVARCHAR(255),
	description NVARCHAR(MAX),
	created DATETIME DEFAULT GETDATE()
);

CREATE TABLE products (
	id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(255) UNIQUE NOT NULL,
	description NVARCHAR(MAX),
	image VARCHAR(255),
	price MONEY NOT NULL,
	vendor CHAR(11) FOREIGN KEY REFERENCES vendors(id),
	CHECK (price > 0)
);

CREATE TABLE products_audit (
	id INT IDENTITY PRIMARY KEY,
	product INT NOT NULL FOREIGN KEY REFERENCES products(id),
	name NVARCHAR(255),
	description NVARCHAR(MAX),
	image VARCHAR(255),
	price MONEY,
	vendor CHAR(11) FOREIGN KEY REFERENCES vendors(id),
	created DATETIME DEFAULT GETDATE()
);

CREATE TABLE goods_receipts (
	id INT IDENTITY PRIMARY KEY,
	product INT NOT NULL FOREIGN KEY REFERENCES products(id),
	quantity INT NOT NULL,
	delivered DATETIME DEFAULT GETDATE(),
	CHECK (quantity > 0)
);

CREATE TABLE purchase_orders (
	id INT IDENTITY PRIMARY KEY,
	ordered DATETIME DEFAULT GETDATE(),
	vendor CHAR(11) NOT NULL FOREIGN KEY REFERENCES vendors(id),
	approved DATETIME NULL
);

CREATE TABLE po_lines (
	id INT IDENTITY PRIMARY KEY,
	purchase_order INT NOT NULL FOREIGN KEY REFERENCES purchase_orders(id),
	product INT NOT NULL FOREIGN KEY REFERENCES products(id),
	quantity INT NOT NULL
);
