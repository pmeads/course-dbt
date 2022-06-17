{{ config( materialized='table' ) }}

-- import CTEs
with greenery_orders as (

    select *
    from {{ ref('stg_greenery__orders') }}

),

greenery_order_items as (

    select *
    from {{ ref('stg_greenery__order_items') }}

),

greenery_products as (

    select *
    from {{ ref('stg_greenery__products') }}

),

greenery_products_ordered as (

    select 
        p.product_name,
        p.product_price,
        oi.order_item_quantity,
        o.order_cost

    from greenery_orders as o
    join greenery_order_items as oi on oi.order_id = o.order_id
    join greenery_products as p on oi.product_id = p.product_id

)

-- final query
select * from greenery_products_ordered