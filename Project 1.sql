--Creating and importing the product_sales data from CSV file
CREATE TABLE product_sales (
    Date DATE,
    Customer_Type VARCHAR(255),
    Country VARCHAR(50),
    Product VARCHAR(50),
	Discount_Band VARCHAR(50),
    Units_Sold INT
);

--\copy product_sales(Date, Customer_Type, Country, Product, Discount_Band, Units_Sold) FROM 'C:/Users/thaku/OneDrive/Desktop/Data Analysis Project/Data Analysis Project November 2024 - Copy/product_sales.csv' DELIMITER ',' CSV HEADER;
-- Above code in PSQL for importing CSV file 

--Creating and Insering data the product_data

CREATE TABLE product_data (
    Product_ID VARCHAR(20),
    Product VARCHAR(255),
    Category VARCHAR(100),
    cost_price NUMERIC(10, 2),
    sale_price NUMERIC(10, 2),
    Brand VARCHAR(50),
	Description TEXT,
	Image_url TEXT
);

INSERT INTO product_data (
    product_id, 
    product, 
    category, 
    cost_price, 
    sale_price, 
    brand, 
    description, 
    image_url
) VALUES
('SR1001', 'MV7', 'Dynamic Microphone', 174, 199, 'Shure', 
 'A versatile USB/XLR dynamic microphone ideal for podcasting, streaming, and vocal recording. It features built-in DSP for sound customization and excellent voice isolation, inspired by the legendary SM7B microphone.', 
 'https://absentdata.com/wp-content/uploads/2024/11/m7_gif.gif'),

('RR10020', 'NT1-A', 'Condenser Microphone', 160, 229, 'Rode', 
 'A popular condenser microphone known for its low self-noise and clear sound quality, perfect for vocal and instrument recordings. It comes with a shock mount and pop filter, making it a great choice for home studios.', 
 'https://absentdata.com/wp-content/uploads/2024/11/nt-1_image-removebg-preview.png'),

('FR10021', 'Scarlett 2i2', 'Audio Interface', 118, 169, 'Focusrite', 
 'A compact USB audio interface with two inputs, allowing users to connect microphones and instruments for high-quality audio recording. Known for its ease of use and low-latency performance, it’s a staple in beginner and professional setups alike.', 
 'https://absentdata.com/wp-content/uploads/2024/11/focusrite-scarlett-2i2-2-removebg-preview.png'),

('PS10022', 'AudioBox USB 96 Studio', 'Recording Bundle', 90, 199, 'PreSonus', 
 'A complete recording bundle that includes an audio interface, M7 condenser microphone, headphones, and software. This all-in-one package is designed for musicians, podcasters, and streamers looking for an affordable, portable recording setup.', 
 'https://absentdata.com/wp-content/uploads/2024/11/AudioBox-USB-96-Studio.png'),

('HY1004', 'QuadCast S', 'Streaming Microphone', 97, 139, 'HyperX', 
 'A USB condenser microphone featuring customizable RGB lighting, tap-to-mute functionality, and four polar patterns for versatile recording options. Ideal for gaming, streaming, and content creation.', 
 'https://absentdata.com/wp-content/uploads/2024/11/hyper_x_color_gif.gif'),

('AR1200', 'Arctis 7P+', 'Wireless Gaming Headset', 104, 149, 'SteelSeries', 
 'A wireless gaming headset with excellent sound quality and long battery life, designed specifically for compatibility with PlayStation 5. It features a retractable microphone, comfortable ear cushions, and a durable build.', 
 'https://absentdata.com/wp-content/uploads/2024/11/Arc_Headset-removebg-preview.png');



--Creating and Inserting data discount_band

CREATE TABLE discount_data (
    Month VARCHAR(50),
    Discount_band VARCHAR(50),
    Discount INT
	);

INSERT INTO discount_data (month, discount_band, discount)
VALUES
('January', 'none', 0),
('January', 'low', 6),
('January', 'medium', 10),
('January', 'high', 5),
('February', 'none', 0),
('February', 'low', 6),
('February', 'medium', 11),
('February', 'high', 5),
('March', 'none', 0),
('March', 'low', 6),
('March', 'medium', 4),
('March', 'high', 15),
('April', 'none', 0),
('April', 'low', 3),
('April', 'medium', 8),
('April', 'high', 15),
('May', 'none', 0),
('May', 'low', 7),
('May', 'medium', 11),
('May', 'high', 9),
('June', 'none', 0),
('June', 'low', 6),
('June', 'medium', 4),
('June', 'high', 7),
('July', 'none', 0),
('July', 'low', 8),
('July', 'medium', 9),
('July', 'high', 20),
('August', 'none', 0),
('August', 'low', 8),
('August', 'medium', 8),
('August', 'high', 17),
('September', 'none', 0),
('September', 'low', 5),
('September', 'medium', 7),
('September', 'high', 12),
('October', 'none', 0),
('October', 'low', 9),
('October', 'medium', 14),
('October', 'high', 20),
('November', 'none', 0),
('November', 'low', 15),
('November', 'medium', 19),
('November', 'high', 24),
('December', 'none', 0),
('December', 'low', 14),
('December', 'medium', 18),
('December', 'high', 20);


-----------------------------------------------------------------------------------

SELECT * FROM product_sales
SELECT * FROM product_data
SELECT * FROM discount_data


SELECT 
    a.Product, 
    a.Category, 
    a.Brand, 
    a.Description, 
    a.Cost_price, 
    a.Sale_Price, 
    a.Image_url,
    b.Date,
    b.country,
    b.customer_type, 
    b.discount_band,
    c.discount, -- Correctly reference discount from discount_data
    b.units_sold,
    (a.Sale_Price * b.units_sold) AS Revenue,
    (a.Cost_price * b.units_sold) AS Total_Cost,
    EXTRACT(MONTH FROM b.Date) AS month,
    TO_CHAR(b.Date, 'FMMonth') AS month_name,
    EXTRACT(YEAR FROM b.Date) AS year,
    ROUND((1 - COALESCE(c.discount, 0) * 1.0 / 100) * (a.Sale_Price * b.units_sold)) AS discount_revenue
FROM product_data a
JOIN product_sales b
    ON a.Product_Id = b.Product
LEFT JOIN discount_data c
    ON TRIM(LOWER(b.discount_band::TEXT)) = TRIM(LOWER(c.discount_band::TEXT))
    AND TRIM(LOWER(TO_CHAR(b.Date, 'FMMonth'))) = TRIM(LOWER(c.month));
  