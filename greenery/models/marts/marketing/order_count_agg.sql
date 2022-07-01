with user_orders as (

  select 
    user_id, 
    count(*) user_order_count
  
  from {{ ref('stg_greenery__orders') }}
  
  group by user_id
  
), 

order_count as (

  select 
    user_order_count as number_of_orders, 
    count(*) as number_of_users_who_ordered_this_amount
  
  from user_orders
  
  group by user_order_count
  
  order by user_order_count
  
)

select * from order_count