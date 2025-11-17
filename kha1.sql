create schema bt_season08_kha1;
set search_path to bt_season08_kha1;

create table order_detail (
                              id serial primary key,
                              order_id int,
                              product_name varchar(100),
                              quantity int,
                              unit_price numeric
);
insert into order_detail (order_id, product_name, quantity, unit_price) values
                                                                            (1, 'Laptop Dell', 1, 18000000),
                                                                            (1, 'Chuột Logitech', 2, 450000),
                                                                            (2, 'Bàn phím cơ', 1, 1200000),
                                                                            (3, 'Tai nghe Sony', 1, 2500000);

create or replace procedure calculate_order_total(
    in order_id_input int,
    out total numeric
)
language plpgsql
as $$
begin
    select sum(quantity * unit_price)
    into total
    from order_detail
    where order_id = order_id_input;
end;
$$;

do $$
    declare
        total_value numeric;
    begin
        call calculate_order_total(1, total_value);
        raise notice 'Tổng đơn hàng 1 là: %', total_value;
    end;
$$;
