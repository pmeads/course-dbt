{{ config( materialized='table' ) }}

-- import CTEs
with greenery_products as (

    select *
    from {{ ref('stg_greenery__products') }}

),

-- logical CTEs

products as (

    select 
      p.product_id,
      p.name,
      p.price,
      p.inventory

    from 
        greenery_products as p

),

-- final CTE
final as ( 

    select * 
    from products

) 

select * from final