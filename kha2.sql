create schema bt_season08_kha2;
set search_path to bt_season08_kha2;

create table inventory (
                           product_id serial primary key,
                           product_name varchar(100),
                           quantity int
);
insert into inventory (product_name, quantity) values
                                                   ('Laptop Dell', 10),
                                                   ('Chuột Logitech', 50),
                                                   ('Bàn phím cơ', 30),
                                                   ('Tai nghe Sony', 20);

create or replace procedure check_stock(
    p_id int,
    p_qty int
)
    language plpgsql
as $$
declare
    current_qty int;
begin
    select quantity into current_qty
    from inventory
    where product_id = p_id;

    if current_qty is null then
        raise exception 'Sản phẩm không tồn tại!';
    elsif current_qty < p_qty then
        raise exception 'Không đủ hàng trong kho';
    end if;
    raise notice 'Sản phẩm đủ hàng';
end;
$$;

call check_stock(1, 5);
call check_stock(1, 220);

