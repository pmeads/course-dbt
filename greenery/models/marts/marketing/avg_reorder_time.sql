{{ config( materialized='view' ) }}

-- import CTEs

with user_order_agg as (

    select * from {{ ref('fct_user_order_agg') }}

),

-- logical CTEs

users_who_reordered as (

  select 
    user_id 
  from user_order_agg
  where order_count > 1

),

order_plus_next_order as (

  select 
      o.user_id, 
      o.order_id, 
      o.created_at_utc,
      lead(o.created_at_utc,1) over (PARTITION BY o.user_id order by o.created_at_utc) as next_ordered_at_utc
  from fct_orders as o 
  join users_who_reordered as u on u.user_id = o.user_id

),

-- final CTE 
avg_reorder_time as (
  select avg( next_ordered_at_utc - created_at_utc) as order_diff
  from order_plus_next_order
  where next_ordered_at_utc is not null
)

-- simple select
select * from avg_reorder_time
