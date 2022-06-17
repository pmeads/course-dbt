{{ config( materialized='view' ) }}
-- import CTEs

with user_orders as (
   select * from {{ ref('fct_user_orders') }}
),

-- logical CTEs
user_order_count as (

  select
     u.user_id,
     u.first_name,
     u.last_name,
     u.email,
     u.phone_number,
     a.zipcode,
     a.state,
     max(o.created_at_utc) as last_order_date_utc,
     count(o.order_id) as order_count
  from user_orders

  group by u.user_id, u.first_name, u.last_name, u.email, u.phone_number, a.zipcode, a.state
  order by order_count desc

)

-- final CTE
select * from user_order_count
