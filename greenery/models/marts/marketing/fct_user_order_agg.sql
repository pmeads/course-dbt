{{ config( materialized='view' ) }}
-- import CTEs

with user_orders as (
   select * from {{ ref('fct_user_orders') }}
),

-- logical CTEs
user_order_count as (

  select
     user_id,
     first_name,
     last_name,
     email,
     phone_number,
     zipcode,
     state,
     max(created_at_utc) as last_order_date_utc,
     sum(order_cost) as amount_spent,
     count(order_id) as order_count
         
  from user_orders

  group by user_id, first_name, last_name, email, phone_number, zipcode, state

),

user_order_agg as (

   select
      *,
      case 
        when order_count = 0
          then 0
        else
           round(amount_spent::decimal/order_count,2)
       end as avg_amount_spent
     
   from user_order_count

)
-- final CTE
select * from user_order_agg
