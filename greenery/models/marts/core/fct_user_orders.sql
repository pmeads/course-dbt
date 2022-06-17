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
     o.order_id, 
     o.promo_id,
     o.address_id,
     o.created_at_utc,
     o.order_cost,
     o.shipping_cost,
     o.order_total,
     o.tracking_id,
     o.shipping_service,
     o.estimated_delivery_at_utc,
     o.delivered_at_utc
  from users as u
  join addresses as a on a.address_id = u.address_id
  left join orders as o on o.user_id = u.user_id
  
)

-- final
select * from user_orders