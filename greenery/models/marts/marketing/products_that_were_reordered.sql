
{{ config( materialized='table' ) }}

-- import CTE
with product_orders as (

    select *
    from {{ ref('int_greenery_products_joined') }}

),

-- logical CTE

products_reordered as ( 

  select p1.product_id, 
         p1.product_name, 
         count(*) as times_reordered
  from int_greenery_products_joined as p1
  join int_greenery_products_joined as p2
    on p1.user_id = p2.user_id
    and p1.product_id = p2.product_id
  where p1.created_at_utc > p2.created_at_utc
  group by p1.product_id, p1.product_name
  order by 2

)

-- final CTE

select * from products_reordered
