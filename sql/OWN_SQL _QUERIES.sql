
SELECT
    current_database() AS database_name,
    version() AS postgres_version;


CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_cost NUMERIC(10,2) NOT NULL,
    reorder_point INT NOT NULL,
    target_stock INT NOT NULL
);

SELECT * FROM PRODUCTS;


CREATE TABLE suppliers (
    supplier_id VARCHAR(10) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    supplier_tier VARCHAR(30)
);

SELECT * FROM suppliers;

CREATE TABLE inventory (
    product_id VARCHAR(10) PRIMARY KEY,
    onhand_qty INT NOT NULL,
    snapshot_date DATE NOT NULL,
    CONSTRAINT fk_inventory_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

SELECT * FROM inventory;


CREATE TABLE purchase_orders (
    purchaseorderid VARCHAR(10) PRIMARY KEY,
    product_id VARCHAR(10) NOT NULL,
    supplier_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    promised_date DATE NOT NULL,
    received_date DATE NOT NULL,
    order_qty INT NOT NULL,
    unit_cost NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_po_products
        FOREIGN KEY (product_id)
        REFERENCES public.products(product_id),
    CONSTRAINT fk_po_suppliers
        FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);

SELECT * FROM purchase_orders;


---------------------------------------------------------------------------------------------------------------------------
--Check your current table id present in your schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

--Check your current table structure
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN 
  ( 'products', 'suppliers', 'inventory','purchase_orders' )
ORDER BY table_name, ordinal_position;









