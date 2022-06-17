-- import CTEs
{{ config( materialized='table' ) }}

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

greenery_promos as (

    select * 
    from {{ ref('stg_greenery__promos') }}
),

-- logical CTEs
greenery_products_joined as (

    select 
        
        p.product_name,
        p.product_price,
        case 
            when promo.discount is null 
            then 0
            else promo.discount
        end as order_discount,
        oi.order_item_quantity,
        o.order_cost as total_order_cost,
        o.created_at_utc,
        o.order_id,
        o.address_id,
        o.user_id,       
        p.product_id,
        promo.promo_id

    from greenery_orders as o
    join greenery_order_items as oi on oi.order_id = o.order_id
    join greenery_products as p on oi.product_id = p.product_id
    left join greenery_promos as promo on promo.promo_id = o.promo_id

)

select * from greenery_products_joined
