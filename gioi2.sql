create schema bt_season08_gioi2;
set search_path to bt_season08_gioi2;

create table products (
                          id serial primary key,
                          name varchar(100),
                          price numeric,
                          discount_percent int
);

insert into products (name, price, discount_percent) values
                                                         ('Laptop Dell', 18000000, 10),
                                                         ('Chuột Logitech', 450000, 5),
                                                         ('Bàn phím cơ', 1200000, 15),
                                                         ('Tai nghe Sony', 2500000, 20);

create or replace procedure calculate_discount(
    p_id int,
    out p_final_price numeric
)
language plpgsql
as $$
declare
    v_price numeric;
    v_discount int;
    v_effective_discount numeric;
begin
    select price, discount_percent
    into v_price, v_discount
    from products
    where id = p_id;

    if v_price is null then
        raise exception 'Sản phẩm không tồn tại';
    end if;

    if v_discount > 50 then
        v_effective_discount := 50;
    else
        v_effective_discount := v_discount;
    end if;

    p_final_price := v_price - (v_price * v_effective_discount / 100);
end;
$$;

do $$
    declare
        final_price numeric;
    begin
        call calculate_discount(1, final_price);
        raise notice 'Giá sau giảm của sản phẩm 1 là: %', final_price;
    end;
$$;

do $$
declare
    r record;
    new_price numeric;
begin
    for r in select id from products loop
            call calculate_discount(r.id, new_price);
            update products
            set price = new_price
            where id = r.id;
        end loop;
end;
$$;

select * from products;
call calculate_discount(2, p_final_price => null);
