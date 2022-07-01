with orders_per_hours as (

  select 
    count(*),
    date_trunc('hour',created_at_utc) as hour

  from {{ ref( 'stg_greenery__orders' ) }}
  
  group by date_trunc('hour',created_at_utc)

)

select 
  trunc(avg(count),1) as avg_orders_per_hour 
from orders_per_hours
