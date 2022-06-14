{{ config( materialized='table' ) }}

-- import CTEs
with greenery_promos as (

    select *
    from {{ ref('stg_greenery__promos') }}

),

-- logical CTEs

promos as (

    select 
      p.promo_id,
      p.discount,
      p.status

    from 
        greenery_promos as p

),

-- final CTE
final as ( 

    select * 
    from products

) 

select * from final