{{ config( materialized='table' ) }}

-- import CTEs
with greenery_events as (

    select *
    from {{ ref('stg_greenery__events') }}

),

-- logical CTEs
events_with_type_cols as (

  select 
    user_id, 
    session_id, 
    order_id, 
    product_id, 
    event_type,
    {{ make_binary_cols_for_lov('stg_greenery__events','event_type','event') }}
  from greenery_events

)

-- simple query
select * from events_with_type_cols