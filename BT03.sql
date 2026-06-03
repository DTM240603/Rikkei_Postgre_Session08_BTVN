CREATE SCHEMA bt03;
SET SEARCH_PATH TO bt03;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
    salary NUMERIC
);

INSERT INTO employees (emp_name, job_level, salary)
VALUES
    ('Nguyễn Văn An', 1, 10000000),
    ('Trần Thị Bình', 2, 12000000),
    ('Lê Minh Khoa', 3, 15000000),
    ('Phạm Hoàng Nam', 1, 9000000),
    ('Võ Thu Hà', 2, 11000000);

SELECT *
FROM employees;

CREATE OR REPLACE PROCEDURE adjust_salary(p_emp_id INT, OUT p_new_salary NUMERIC)
LANGUAGE plpgsql
AS $$
    DECLARE
        p_level INT;
        p_current_salary NUMERIC;
    BEGIN
        SELECT job_level, salary
        INTO p_level, p_current_salary
        FROM employees
        WHERE emp_id = p_emp_id;

        IF p_level = 1 THEN
            p_new_salary := p_current_salary * 1.05;

        ELSIF p_level = 2 THEN
            p_new_salary := p_current_salary * 1.1;

        ELSIF p_level = 3 THEN
            p_new_salary := p_current_salary * 1.15;
        end if;

        UPDATE employees
        SET salary = p_new_salary
        WHERE emp_id = p_emp_id;
    END;
$$;

DO $$
    DECLARE v_new_salary NUMERIC;
    BEGIN
        CALL adjust_salary(3, v_new_salary);
        RAISE NOTICE 'Lương mới của nhân viên là: %', v_new_salary;
    END;
$$;