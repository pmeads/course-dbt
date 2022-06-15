{{ config( materialized='table' ) }}

-- import CTEs
with greenery_events as (

    select *
    from {{ ref('stg_greenery__events') }}

)

-- final query
select * from greenery_events