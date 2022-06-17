{{ config( materialized='view' ) }}

-- import CTEs

with products_ordered as (

    select * from {{ ref('fct_products_ordered') }}

),

-- logical CTEs

avg_product_order as (

    select
      product_name,
      product_price,
      round(avg(order_item_quantity),1) as avg_size_per_order,
      round(avg(order_product_cost::decimal),2) as avg_cost_per_order
      

    from products_ordered
    group by product_name, product_price
)

-- final
select * from avg_product_order 
order by product_name