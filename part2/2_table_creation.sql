CREATE TABLE IF NOT EXISTS transactions
(
    user_id INTEGER NOT NULL,
    product_id VARCHAR(255) NOT NULL,
    refunded BOOLEAN NOT NULL,
    purchase_date DATE NOT NULL,
    country_code VARCHAR(20),
    media_source VARCHAR(255)
);