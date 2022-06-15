{{ config( materialized='table' ) }}

-- import CTEs
with greenery_orders as (

    select *
    from {{ ref('stg_greenery__orders') }}

)

-- final query
select * from greenery_orders