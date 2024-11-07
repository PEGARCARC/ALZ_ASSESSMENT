-- Creación de tablas Hub
CREATE TABLE hub_customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);

CREATE TABLE hub_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);

-- Creación de tablas Satellite
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

-- Creación de la tabla Link
CREATE TABLE link_sales (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    FOREIGN KEY (customer_id) REFERENCES hub_customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES hub_products(product_id)
);

-- Inserción de datos de ejemplo
INSERT INTO hub_customers (customer_id, customer_name) VALUES (101, 'Alice');
INSERT INTO hub_products (product_id, product_name) VALUES (1001, 'Widget');
INSERT INTO link_sales (transaction_id, customer_id, product_id, sale_date) VALUES (1, 101, 1001, '2024-10-31');
