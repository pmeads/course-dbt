{{ config( materialized='view' ) }}

-- import CTEs

with user_orders as (
   select * from {{ ref('fct_user_orders') }}
),

-- logical CTEs

shipping_lag as (
  select 
    shipping_service, 
    date(delivered_at_utc) - date(estimated_delivery_at_utc) as date_diff
  from fct_user_orders
  where delivered_at_utc is not null
  and estimated_delivery_at_utc is not null

),

shipping_lag_count as (
  select 
    shipping_service, 
    date_diff, 
    count(*) no_times
  from shipping_lag
  group by shipping_service, date_diff
), 

-- final CTE
total_days_late as (

  select 
    shipping_service, 
    sum(date_diff * no_times) as total_days_late
  from shipping_lag_count
  group by shipping_service
  order by total_days_late desc

)

-- simple select 
select * from total_days_late