CREATE SCHEMA bt01;
SET SEARCH_PATH TO bt01;

CREATE TABLE order_detail (
    id SERIAL PRIMARY KEY,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    unit_price NUMERIC
);

INSERT INTO order_detail (order_id, product_name, quantity, unit_price)
VALUES
    (101, 'Laptop Dell', 1, 25000000),
    (101, 'Chuột Logitech', 2, 500000),
    (101, 'Bàn phím cơ', 1, 1500000),

    (102, 'iPhone 15', 1, 22000000),
    (102, 'Tai nghe Bluetooth', 2, 1200000),

    (103, 'Sách PostgreSQL', 3, 250000);

SELECT *
FROM order_detail;

-- 1. Viết một Stored Procedure có tên calculate_order_total(order_id_input INT, OUT total NUMERIC)
-- Tham số order_id_input: mã đơn hàng cần tính
-- Tham số total: tổng giá trị đơn hàng
CREATE OR REPLACE PROCEDURE calculate_order_total(
    order_id_input INT,
    OUT total NUMERIC
)
LANGUAGE plpgsql
AS $$
   BEGIN
       SELECT SUM(quantity * unit_price) INTO total
       FROM order_detail o
       WHERE o.order_id = order_id_input;
   END;
$$;

DO $$
    DECLARE total NUMERIC;
    BEGIN
       CALL calculate_order_total(102, total);
       RAISE NOTICE 'Tổng đơn hàng là: %', total;
    end;
$$;


