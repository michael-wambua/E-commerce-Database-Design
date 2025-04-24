-- E-commerce Database Schema

-- Create Tables with proper relationships and constraints

-- Brand Table
CREATE TABLE brand (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_description TEXT,
    logo_url VARCHAR(255),
    website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Category Table
CREATE TABLE product_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INTEGER REFERENCES product_category(category_id),
    category_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Table
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    brand_id INTEGER REFERENCES brand(brand_id),
    category_id INTEGER REFERENCES product_category(category_id),
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Color Table
CREATE TABLE color (
    color_id SERIAL PRIMARY KEY,
    color_name VARCHAR(50) NOT NULL,
    color_code VARCHAR(20) NOT NULL, -- HEX code
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Size Category Table
CREATE TABLE size_category (
    size_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL, -- e.g., Clothing, Shoes, etc.
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Size Option Table
CREATE TABLE size_option (
    size_id SERIAL PRIMARY KEY,
    size_category_id INTEGER REFERENCES size_category(size_category_id),
    size_name VARCHAR(20) NOT NULL, -- e.g., S, M, L, XL, 42, 43, etc.
    size_code VARCHAR(10), -- Optional standardized code
    sort_order INTEGER, -- For ordering sizes properly (S < M < L)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attribute Category Table
CREATE TABLE attribute_category (
    attribute_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL, -- e.g., Physical, Technical
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Attribute Type Table
CREATE TABLE attribute_type (
    attribute_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL, -- e.g., text, number, boolean
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Attribute Table
CREATE TABLE product_attribute (
    attribute_id SERIAL PRIMARY KEY,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_category_id INTEGER REFERENCES attribute_category(attribute_category_id),
    attribute_type_id INTEGER REFERENCES attribute_type(attribute_type_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Variation Table
CREATE TABLE product_variation (
    variation_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES product(product_id),
    attribute_id INTEGER REFERENCES product_attribute(attribute_id),
    value TEXT NOT NULL, -- The actual value of the attribute for this product
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Item Table (Represents specific purchasable items with variations)
CREATE TABLE product_item (
    item_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES product(product_id),
    sku VARCHAR(100) UNIQUE NOT NULL,
    size_id INTEGER REFERENCES size_option(size_id),
    color_id INTEGER REFERENCES color(color_id),
    price DECIMAL(10, 2) NOT NULL, -- May differ from base price
    stock_quantity INTEGER DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Image Table
CREATE TABLE product_image (
    image_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES product(product_id),
    product_item_id INTEGER REFERENCES product_item(item_id), -- Can be NULL if it's a general product image
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data for testing

-- Insert Brands
INSERT INTO brand (brand_name, brand_description, logo_url, website) VALUES
('Nike', 'Athletic footwear and apparel', 'https://unsplash.com/logos/nike.png', 'https://nike.com'),
('Samsung', 'Electronics manufacturer', 'https://unsplash.com/logos/samsung.png', 'https://samsung.com'),
('IKEA', 'Furniture and home accessories', 'https://unsplash.com/logos/ikea.png', 'https://ikea.com'),
('Adidas', 'Sportswear and equipment', 'https://unsplash.com/logos/adidas.png', 'https://adidas.com'),
('Apple', 'Consumer electronics', 'https://unsplash.com/logos/apple.png', 'https://apple.com');

-- Insert Product Categories
INSERT INTO product_category (category_name, parent_category_id, category_description) VALUES
('Electronics', NULL, 'Electronic devices and accessories'),
('Clothing', NULL, 'Apparel items for all ages'),
('Furniture', NULL, 'Home and office furniture'),
('Smartphones', 1, 'Mobile phones and accessories'),
('Laptops', 1, 'Portable computers'),
('Men''s Clothing', 2, 'Clothing items for men'),
('Women''s Clothing', 2, 'Clothing items for women'),
('Athletic Wear', 2, 'Sports and fitness clothing'),
('Sofas', 3, 'Living room seating furniture'),
('Desks', 3, 'Work and study desks');

-- Insert Colors
INSERT INTO color (color_name, color_code) VALUES
('Black', '#000000'),
('White', '#FFFFFF'),
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Green', '#00FF00'),
('Yellow', '#FFFF00'),
('Gray', '#808080'),
('Navy', '#000080'),
('Purple', '#800080'),
('Orange', '#FFA500');

-- Insert Size Categories
INSERT INTO size_category (category_name, description) VALUES
('Clothing', 'Standard clothing sizes'),
('Shoes', 'Footwear sizes'),
('Electronics', 'Size categories for electronics'),
('Furniture', 'Furniture dimensions categories');

-- Insert Size Options
INSERT INTO size_option (size_category_id, size_name, size_code, sort_order) VALUES
(1, 'XS', 'XS', 1),
(1, 'S', 'S', 2),
(1, 'M', 'M', 3),
(1, 'L', 'L', 4),
(1, 'XL', 'XL', 5),
(1, 'XXL', 'XXL', 6),
(2, '38', 'EU38', 1),
(2, '39', 'EU39', 2),
(2, '40', 'EU40', 3),
(2, '41', 'EU41', 4),
(2, '42', 'EU42', 5),
(2, '43', 'EU43', 6),
(2, '44', 'EU44', 7),
(3, 'Small', 'SM', 1),
(3, 'Medium', 'MD', 2),
(3, 'Large', 'LG', 3),
(4, 'Single', 'SGL', 1),
(4, 'Double', 'DBL', 2),
(4, 'Queen', 'QN', 3),
(4, 'King', 'KG', 4);

-- Insert Attribute Categories
INSERT INTO attribute_category (category_name, description) VALUES
('Physical', 'Physical characteristics of products'),
('Technical', 'Technical specifications'),
('Material', 'Material composition information'),
('Performance', 'Performance-related attributes');

-- Insert Attribute Types
INSERT INTO attribute_type (type_name, description) VALUES
('text', 'Text values'),
('number', 'Numeric values'),
('boolean', 'True/False values'),
('date', 'Date values'),
('json', 'Structured data in JSON format');

-- Insert Product Attributes
INSERT INTO product_attribute (attribute_name, attribute_category_id, attribute_type_id) VALUES
('Weight', 1, 2),
('Dimensions', 1, 1),
('Material', 3, 1),
('RAM', 2, 2),
('Storage', 2, 2),
('Processor', 2, 1),
('Battery Life', 4, 2),
('Water Resistant', 4, 3),
('Release Date', 2, 4),
('Connectivity Options', 2, 5);

-- Insert Products
INSERT INTO product (product_name, brand_id, category_id, description, base_price) VALUES
('iPhone 14 Pro', 5, 4, 'Latest flagship smartphone from Apple', 999.99),
('Galaxy S23', 2, 4, 'Powerful Android smartphone', 899.99),
('MacBook Pro 16"', 5, 5, 'Professional-grade laptop', 2499.99),
('Air Jordan 1', 1, 2, 'Classic basketball sneakers', 180.00),
('Ultra Boost', 4, 2, 'Premium running shoes', 200.00),
('BILLY Bookcase', 3, 3, 'Versatile bookcase for any room', 79.99),
('MALM Bed Frame', 3, 3, 'Stylish and functional bed frame', 299.99),
('Nike Dri-FIT T-Shirt', 1, 8, 'Moisture-wicking athletic shirt', 35.00),
('Samsung Galaxy Tab S8', 2, 1, 'High-performance tablet', 699.99),
('Adidas Track Pants', 4, 8, 'Comfortable athletic pants', 65.00);

-- Insert Product Variations
INSERT INTO product_variation (product_id, attribute_id, value) VALUES
(1, 4, '6 GB'),
(1, 5, '256 GB'),
(1, 7, '24 hours'),
(1, 8, 'true'),
(2, 4, '8 GB'),
(2, 5, '128 GB'),
(2, 6, 'Snapdragon 8 Gen 2'),
(3, 4, '16 GB'),
(3, 5, '512 GB'),
(3, 6, 'Apple M2 Pro'),
(4, 3, 'Leather'),
(5, 3, 'Synthetic mesh'),
(8, 3, 'Polyester'),
(10, 3, 'Cotton blend');

-- Insert Product Items (specific buyable items with variations)
INSERT INTO product_item (product_id, sku, size_id, color_id, price, stock_quantity) VALUES
(1, 'IP14PRO-256-BLK', 15, 1, 1099.99, 50),
(1, 'IP14PRO-256-WHT', 15, 2, 1099.99, 45),
(2, 'GS23-128-BLK', 15, 1, 899.99, 30),
(2, 'GS23-128-GRN', 15, 5, 899.99, 25),
(3, 'MBP16-512-SLV', 16, 7, 2499.99, 15),
(4, 'AJ1-40-RED', 10, 3, 180.00, 20),
(4, 'AJ1-42-RED', 12, 3, 180.00, 18),
(4, 'AJ1-44-BLK', 14, 1, 180.00, 15),
(5, 'UB-41-BLU', 11, 4, 200.00, 22),
(5, 'UB-42-BLU', 12, 4, 200.00, 25),
(5, 'UB-43-BLU', 13, 4, 200.00, 20),
(6, 'BILLY-WHT', 16, 2, 79.99, 100),
(6, 'BILLY-BLK', 16, 1, 79.99, 85),
(7, 'MALM-QN-WHT', 19, 2, 299.99, 10),
(7, 'MALM-KG-WHT', 20, 2, 399.99, 8),
(8, 'DRFT-S-BLU', 2, 4, 35.00, 50),
(8, 'DRFT-M-BLU', 3, 4, 35.00, 60),
(8, 'DRFT-L-BLU', 4, 4, 35.00, 45),
(9, 'GTABS8-256-GRY', 15, 7, 699.99, 30),
(10, 'ADTP-M-BLK', 3, 1, 65.00, 40),
(10, 'ADTP-L-BLK', 4, 1, 65.00, 38),
(10, 'ADTP-XL-BLK', 5, 1, 65.00, 25);

-- Insert Product Images
INSERT INTO product_image (product_id, product_item_id, image_url, alt_text, is_primary) VALUES
(1, 1, 'https://unsplash.com/images/iphone-14-pro-black.jpg', 'iPhone 14 Pro in Black', TRUE),
(1, 2, 'https://unsplash.com/images/iphone-14-pro-white.jpg', 'iPhone 14 Pro in White', TRUE),
(2, 3, 'https://unsplash.com/images/galaxy-s23-black.jpg', 'Samsung Galaxy S23 in Black', TRUE),
(2, 4, 'https://unsplash.com/images/galaxy-s23-green.jpg', 'Samsung Galaxy S23 in Green', TRUE),
(3, 5, 'https://unsplash.com/images/macbook-pro-16.jpg', 'MacBook Pro 16-inch', TRUE),
(3, NULL, 'https://unsplash.com/images/macbook-pro-16-side.jpg', 'MacBook Pro 16-inch Side View', FALSE),
(4, 6, 'https://unsplash.com/images/air-jordan-1-red-40.jpg', 'Air Jordan 1 in Red, Size 40', TRUE),
(4, 8, 'https://unsplash.com/images/air-jordan-1-black-44.jpg', 'Air Jordan 1 in Black, Size 44', TRUE),
(5, 9, 'https://unsplash.com/images/ultra-boost-blue-41.jpg', 'Ultra Boost in Blue, Size 41', TRUE),
(6, 12, 'https://unsplash.com/images/billy-white.jpg', 'BILLY Bookcase in White', TRUE),
(6, 13, 'https://unsplash.com/images/billy-black.jpg', 'BILLY Bookcase in Black', TRUE),
(7, 14, 'https://unsplash.com/images/malm-queen-white.jpg', 'MALM Queen Bed Frame in White', TRUE),
(8, 16, 'https://unsplash.com/images/dri-fit-blue-s.jpg', 'Nike Dri-FIT T-Shirt in Blue, Size S', TRUE),
(9, 19, 'https://unsplash.com/images/galaxy-tab-s8-gray.jpg', 'Samsung Galaxy Tab S8 in Gray', TRUE),
(10, 20, 'https://unsplash.com/images/adidas-track-pants-black-m.jpg', 'Adidas Track Pants in Black, Size M', TRUE);