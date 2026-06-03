CREATE SCHEMA bt02;
SET SEARCH_PATH TO bt02;

CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

INSERT INTO inventory (product_name, quantity)
VALUES
    ('Laptop Dell', 10),
    ('Chuột Logitech', 50),
    ('Bàn phím cơ Razer', 5),
    ('Tai nghe Bluetooth', 0),
    ('iPhone 15', 8);

SELECT *
FROM inventory;

CREATE OR REPLACE PROCEDURE check_stock(p_id INT, p_qty INT)
LANGUAGE plpgsql
AS $$
    DECLARE quantity INT;
    BEGIN
        SELECT i.quantity INTO quantity
        FROM inventory i
        WHERE i.product_id = p_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Không tìm thấy sản phẩm có mã %', p_id;
        end if;

        IF quantity < p_qty THEN
            RAISE EXCEPTION 'Không đủ hàng trong kho';
        ELSE
            RAISE EXCEPTION 'Đủ hàng trong kho';
        END IF;
    END;
$$;

CALL check_stock(1, 10);