CREATE SCHEMA bt05;
SET search_path TO bt05;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2) DEFAULT 0
);

INSERT INTO employees (name, department, salary)
VALUES
    ('Nguyen Van A', 'HR', 4000),
    ('Tran Thi B', 'IT', 6000),
    ('Le Van C', 'Finance', 10500),
    ('Pham Thi D', 'IT', 8000),
    ('Do Van E', 'HR', 12000);

ALTER TABLE employees
ADD COLUMN status VARCHAR(20);

SELECT * FROM employees;

CREATE OR REPLACE PROCEDURE update_employee_status(p_emp_id INT, OUT p_status TEXT)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_salary NUMERIC(10,2);
    BEGIN
        SELECT e.salary
        INTO v_salary
        FROM employees e
        WHERE id = p_emp_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Employee not found';
        end if;

        IF v_salary < 5000 THEN
            p_status := 'Junior';
        ELSIF v_salary BETWEEN 5000 AND 10000 THEN
            p_status := 'Mid-level';
        ELSE
            p_status := 'Senior';
        end if;

        UPDATE employees
        SET status = p_status
        WHERE id = p_emp_id;
    END;
$$;

DO $$
    DECLARE
        v_status TEXT;
    BEGIN
        CALL update_employee_status(1, v_status);
        RAISE NOTICE '%', v_status;
    end;
$$;

