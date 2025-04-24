# E-commerce Database Project

This repository contains the SQL schema and sample data for a comprehensive e-commerce database system. The database is designed to support all core functionalities of a modern e-commerce platform, including product management, variations, categorization, and image storage.

## Database Structure

The database consists of the following interconnected tables:

- **brand**: Stores information about product manufacturers/brands
- **product_category**: Hierarchical category system for products
- **product**: Core product information and basic details
- **color**: Available color options for products
- **size_category**: Groups of size types (Clothing, Shoes, etc.)
- **size_option**: Specific sizes within each category
- **attribute_category**: Groups of product attributes
- **attribute_type**: Data types for product attributes
- **product_attribute**: Specific attributes that can be assigned to products
- **product_variation**: Connects products with their attribute values
- **product_item**: Specific purchasable variants of products
- **product_image**: Images associated with products or specific items

## Features

- **Flexible Product Management**: Support for complex products with multiple variations
- **Hierarchical Categories**: Categories can have parent-child relationships
- **Comprehensive Attribute System**: Custom attributes with different data types
- **Size Management**: Organized size system for different product types
- **Color Management**: Standard color definitions with color codes
- **Image Support**: Multiple images per product with primary image designation
- **Stock Management**: Inventory tracking at the product item level
- **Brand Management**: Complete brand information storage

## Implementation

### Prerequisites

- MySQL (or another SQL database with minor syntax adjustments)
- Database administration tool (pgAdmin, DBeaver, etc.) or command-line access

### Installation

1. Create a new database in your MySQL server
2. Execute the SQL script in the file `ecommerce_database.sql`
3. The script will:
   - Create all necessary tables with appropriate relationships
   - Set up constraints and indices
   - Populate the database with sample data for testing

```bash
# Example command to run the SQL script via mysql
mysql -U username -d database_name -f ecommerce_database.sql
```

### Entity Relationship Diagram (ERD)

![ERD Diagram](./ERD%20Diagram.drawio.png)

The repository includes instructions for creating an ERD using draw.io to visualize the database structure. Following these steps will help you understand the relationships between entities:

1. Open [draw.io](https://app.diagrams.net/)
2. Create a new diagram using the ERD template
3. Add entities for each table and their attributes
4. Connect entities with appropriate relationship lines
5. Add cardinality notations and descriptive labels

## Sample Data

The SQL script includes sample data for all tables, featuring:

- 5 brands (Nike, Samsung, IKEA, Adidas, Apple)
- 10 product categories in a hierarchical structure
- 10 colors with hex codes
- 4 size categories with 20 size options
- 4 attribute categories with 10 product attributes
- 10 products with variations
- 22 product items (specific variants)
- 15 product images

This sample data provides a solid foundation for testing queries, building applications, or further extending the database.

## Usage Examples

### Basic Queries

```sql
-- Get all products from a specific brand
SELECT p.product_id, p.product_name, p.base_price
FROM product p
WHERE p.brand_id = 1;

-- Get all available sizes for a specific product
SELECT so.size_name, so.size_code
FROM product_item pi
JOIN size_option so ON pi.size_id = so.size_id
WHERE pi.product_id = 4
ORDER BY so.sort_order;

-- Get all items with their availability status
SELECT p.product_name, pi.sku, c.color_name, so.size_name, pi.price, pi.stock_quantity
FROM product_item pi
JOIN product p ON pi.product_id = p.product_id
JOIN color c ON pi.color_id = c.color_id
JOIN size_option so ON pi.size_id = so.size_id
WHERE pi.stock_quantity > 0;
```

### Advanced Queries

```sql
-- Get complete product information with variations
SELECT p.product_name, b.brand_name, 
       pa.attribute_name, pv.value, 
       c.color_name, so.size_name, 
       pi.price, pi.stock_quantity
FROM product p
JOIN brand b ON p.brand_id = b.brand_id
LEFT JOIN product_variation pv ON p.product_id = pv.product_id
LEFT JOIN product_attribute pa ON pv.attribute_id = pa.attribute_id
LEFT JOIN product_item pi ON p.product_id = pi.product_id
LEFT JOIN color c ON pi.color_id = c.color_id
LEFT JOIN size_option so ON pi.size_id = so.size_id
WHERE p.product_id = 1;

-- Get product images grouped by product
SELECT p.product_name, 
       string_agg(DISTINCT pi.image_url, ', ') as product_images,
       count(DISTINCT pi.image_id) as image_count
FROM product p
LEFT JOIN product_image pi ON p.product_id = pi.product_id
GROUP BY p.product_id, p.product_name;
```

## Extending the Database

This database can be extended with additional tables for:

- User accounts and authentication
- Shopping carts and wishlists
- Order processing and history
- Payment methods
- Shipping information
- Reviews and ratings
- Promotions and discounts

## License

This project is available under the MIT License.

## Contributors

- [Michael Sylvester Wambua] - Initial design and implementation