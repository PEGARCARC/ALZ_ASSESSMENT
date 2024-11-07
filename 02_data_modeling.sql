-- Hub Tables Creation --
CREATE TABLE hub_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);

CREATE TABLE hub_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);

-- Satellite Tables Creation --
CREATE TABLE sat_customers (
    customer_id INT,
    customer_name VARCHAR(255),
    effective_date DATE,
    end_date DATE,
    PRIMARY KEY (customer_id, effective_date)
);

CREATE TABLE sat_products (
    product_id INT,
    product_name VARCHAR(255),
    effective_date DATE,
    end_date DATE,
    PRIMARY KEY (product_id, effective_date)
);

-- Link Table Creation --
CREATE TABLE link_sales (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    FOREIGN KEY (customer_id) REFERENCES hub_customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES hub_products(product_id)
);

-- Data Insertion Example --
INSERT INTO hub_customers (customer_id, customer_name) VALUES (101, 'Alice');
INSERT INTO hub_products (product_id, product_name) VALUES (1001, 'Widget');
INSERT INTO link_sales (transaction_id, customer_id, product_id, sale_date) VALUES (1, 101, 1001, '2024-10-31');

-- Incremental Loading. Modify scripts to add only new records. Example with a source table called "staging_sales" --
INSERT INTO link_sales (transaction_id, customer_id, product_id, sale_date)
SELECT transaction_id, customer_id, product_id, sale_date
FROM staging_sales
WHERE transaction_id NOT IN (SELECT transaction_id FROM link_sales);

-- Use auto-increment fields for surrogate keys --
CREATE TABLE hub_customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(255)
);

-- Slowly Changing Dimensions (SCDs). Extend satellite tables to handle SCDs -- 
ALTER TABLE sat_customers ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- Partitioning and Compression. Use SQL features to partition and compress tables for performance --
-- Example of partitioning --
CREATE TABLE sales_partitioned (
    transaction_id INT,
    customer_id INT,
    product_id INT,
    sale_date DATE
)
PARTITION BY RANGE (YEAR(sale_date)) (
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026)
);

-- Error Handling and Logging. Implement error handling in SQL scripts.
-- Example of error handling
BEGIN
    -- Insert data
    INSERT INTO link_sales (transaction_id, customer_id, product_id, sale_date)
    VALUES (1, 101, 1001, '2024-10-31');
EXCEPTION
    WHEN OTHERS THEN
        -- Log error
        INSERT INTO error_log (error_message) VALUES (SQLERRM);
END;
