create schema bt_season08_gioi1;
set search_path to bt_season08_gioi1;

create table employees (
                           emp_id serial primary key,
                           emp_name varchar(100),
                           job_level int,
                           salary numeric
);
insert into employees (emp_name, job_level, salary) values
                                                        ('Nguyễn Văn A', 1, 8000000),
                                                        ('Trần Thị B', 2, 12000000),
                                                        ('Lê Văn C', 3, 18000000),
                                                        ('Phạm Thị D', 2, 11000000);

create or replace procedure adjust_salary(
    p_emp_id int,
    out p_new_salary numeric
)
language plpgsql
as $$
declare
    v_job_level int;
    v_salary numeric;
    v_rate numeric;
begin
    select job_level, salary
    into v_job_level, v_salary
    from employees
    where emp_id = p_emp_id;

    if v_salary is null then
        raise exception 'Nhân viên không tồn tại';
    end if;

    case v_job_level
        when 1 then v_rate := 0.05;
        when 2 then v_rate := 0.10;
        when 3 then v_rate := 0.15;
        else
            raise exception 'job_level không hợp lệ';
        end case;

    p_new_salary := v_salary + (v_salary * v_rate);

    update employees
    set salary = p_new_salary
    where emp_id = p_emp_id;
end;
$$;

call adjust_salary(2, p_new_salary => null);
