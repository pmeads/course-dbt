{{ config( materialized='table' ) }}

-- import CTEs
with users as (
    select * from {{ ref('stg_greenery__users') }}
),

addresses as (
  select * from {{ ref('stg_greenery__addresses') }}
),

orders as (
  select * from {{ ref('stg_greenery__orders') }}
),

-- logical CTEs
user_orders as (
  select 
     u.user_id,
     u.first_name,
     u.last_name,
     u.email,
     u.phone_number,
     a.zipcode,
     a.state,
     count(o.order_id) as order_count
  from users as u
  join addresses as a on a.address_id = u.address_id
  left join orders as o on o.user_id = u.user_id

  group by u.user_id, u.first_name, u.last_name, u.email, u.phone_number, a.zipcode, a.state
  
)

-- final
select * from user_orders order by order_count desc
