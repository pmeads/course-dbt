{{ config( materialized='view' ) }}

-- import CTEs
with greenery_products_joined as (

    select * from {{ ref('int_greenery_products_joined') }}

),

greenery_products_ordered as ( 

    select 
        product_name,
        product_price,
        order_discount,
        order_item_quantity,
        total_order_cost,
        (
            (product_price * order_item_quantity) * 
            ((100 - order_discount) * 0.01)
        ) as order_product_cost
    from greenery_products_joined
    order by product_name

)
-- final query
select * from greenery_products_ordered
