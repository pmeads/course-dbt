{{ config( materialized='table' ) }}

-- import CTEs
with greenery_users as (

    select *
    from {{ ref('stg_greenery__users') }}

),

greenery_address as (

    select *
    from {{ ref('stg_greenery__addresses') }}

),

-- logical CTEs

users_with_addresses as (

    select 
      u.user_id,
      u.first_name,
      u.last_name,
      u.email,
      u.phone_number,
      u.created_at_utc,
      u.updated_at_utc,
      a.address_id,
      a.address,
      a.zipcode,
      a.state,
      a.country

    from 
        greenery_users as u
    left join greenery_address as a on a.address_id = u.address_id 

),

-- final CTE
final as ( 

    select * 
    from users_with_addresses

) 

select * from final