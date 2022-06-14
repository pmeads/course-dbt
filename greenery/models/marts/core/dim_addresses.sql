{{ config( materialized='table' ) }}

-- import CTEs
with greenery_addresses as (

    select *
    from {{ ref('stg_greenery__addresses') }}

),

-- logical CTEs

addresses as (

    select 
      a.address_id,
      a.address,
      a.zipcode,
      a.state,
      a.country

    from 
        greenery_addresses as a

),

-- final CTE
final as ( 

    select * 
    from addresses

) 

select * from final