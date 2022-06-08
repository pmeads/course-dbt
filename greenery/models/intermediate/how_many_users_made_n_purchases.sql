with user_purchases as (

  select 
    user_id, 
    count(*) user_purchase_count
  
  from {{ ref('stg_orders') }}
  
  group by user_id
  
), 

purchase_count as (

  select 
    user_purchase_count as number_of_purchases, 
    count(*) as number_of_users_who_purchased_this_amount
  
  from user_purchases
  
  group by user_purchase_count
  
  order by user_purchase_count
  
)

select * from purchase_count