{{ config( materialized='view' ) }}

with user_order_counts as (

  select 
    count(*) as users_who_ordered, 
    sum(
        case 
          when user_order_count > 1 
          then 1 
          else 0 
        end
    ) as users_who_ordered_more_than_once
    
  from {{ ref('fct_user_orders') }}
  where order_count > 0
)

select 
  round((users_who_ordered_more_than_once::decimal/users_who_ordered),2) as user_order_repeat_rate
  
from user_order_counts