{{ config( materialized='view' ) }}

-- import CTEs

with fct_events_agg as (

    select 
      checkout_events,
      total_sessions

    from {{ ref('fct_events_agg') }}
),

-- logical CTEs

conversion_rate_cte as (

   select trunc(round(checkout_events / total_sessions::decimal, 2) * 100)||'%' as "Converstion Rate"
   from fct_events_agg

)

select * from conversion_rate_cte