{{ config( materialized='view' ) }}

-- import CTEs

with events as (

    select * from {{ ref('fct_events') }}

),

--logical CTEs

sessions_each_hour as ( 

  select 
    distinct session_id, 
    date_trunc('hour',created_at_utc) as hour  

  from events

  order by 2

), 

sessions_per_hour as (

  select 
     hour, 
     count(*) as hourly_count

  from sessions_each_hour

  group by hour

),

avg_sessions_per_hour as (

  select trunc(avg(hourly_count),2) avg_sessions_per_hour 
  from sessions_per_hour

)

-- simple SELECT
select * from avg_sessions_per_hour
