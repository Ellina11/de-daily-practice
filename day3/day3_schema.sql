-- Day 3 - Star Schema Design

CREATE TABLE DimCustomer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    segment VARCHAR(50)
);

CREATE TABLE DimProduct (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);

CREATE TABLE DimDate (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day_of_month INT,
    day_of_week INT,
    day_name VARCHAR(20),
    week_of_year INT,
    is_weekend BOOLEAN,
    is_holiday BOOLEAN
);

CREATE TABLE FactSales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    date_id INT,
    quantity INT,
    revenue DECIMAL(10,2),
    discount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES DimCustomer(customer_id),
    FOREIGN KEY (product_id)  REFERENCES DimProduct(product_id),
    FOREIGN KEY (date_id)     REFERENCES DimDate(date_id)
);
