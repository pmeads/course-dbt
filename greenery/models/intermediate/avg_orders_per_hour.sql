with orders_per_hours as (

  select 
    count(*),
    date_trunc('hour',created_at) as hour

  from {{ ref( 'stg_orders' ) }}
  
  group by date_trunc('hour',created_at)

)

select 
  trunc(avg(count),1) as avg_orders_per_hour 
from orders_per_hours
