{{ config( materialized='table' ) }}

-- import CTEs
with greenery_addresses as (

    select *
    from {{ ref('stg_greenery__addresses') }}

)

-- final query
select DISTINCT zipcode, state from greenery_addresses