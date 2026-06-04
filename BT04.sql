CREATE SCHEMA bt04;
SET SEARCH_PATH TO bt04;

CREATE SCHEMA bt04;
SET search_path TO bt04;

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC,
    discount_percent INT
);

INSERT INTO products (name, price, discount_percent)
VALUES
    ('Laptop Dell', 25000000, 10),
    ('iPhone 15', 22000000, 20),
    ('Chuột Logitech', 500000, 5),
    ('Tai nghe Bluetooth', 1500000, 60),
    ('Bàn phím cơ Razer', 2000000, 50);

SELECT *
FROM products;

-- 1. Viết Procedure calculate_discount(p_id INT, OUT p_final_price NUMERIC) để:
-- Lấy price và discount_percent của sản phẩm
-- Tính giá sau giảm:
--  p_final_price = price - (price * discount_percent / 100)
-- Nếu phần trăm giảm giá > 50, thì giới hạn chỉ còn 50%
-- Cập nhật lại cột price trong bảng products thành giá sau giảm
CREATE OR REPLACE PROCEDURE calculate_discount(p_id INT, OUT p_final_price NUMERIC)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_price NUMERIC;
        v_discount_percent INT;
    BEGIN
        SELECT
            p.price,
            CASE
                WHEN p.discount_percent > 50 THEN 50
                ELSE p.discount_percent
            END
        INTO
            v_price,
            v_discount_percent
        FROM products p
        WHERE p.id = p_id;

        p_final_price = v_price - (v_price * v_discount_percent / 100);

        UPDATE products
        SET price = p_final_price
        WHERE id = p_id;
    END;
$$;

DO $$
    DECLARE
        v_final_price NUMERIC;
    BEGIN
        CALL calculate_discount(2, v_final_price);
        RAISE NOTICE 'Giá sau khuyến mãi là: %', v_final_price;
    END;
$$;




