{{ config( materialized='table' ) }}

-- import CTEs
with events as (

    select *
    from {{ ref('fct_events') }}

),

-- logical CTEs 
events_agg as (

  select 
    sum(checkout_event) as checkout_events, 
    sum(page_view_event) as page_view_events,
    sum(add_to_cart_event) as add_to_cart_events,
    sum(package_shipped_event) as package_shipped_events,
    count(distinct(session_id)) as total_sessions
  from fct_events

)
-- final query
select * from events_agg