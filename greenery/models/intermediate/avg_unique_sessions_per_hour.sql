with unique_sessions_per_hour as (

  select 
    session_id, 
    date_trunc('hour',created_at) as hour, 
    count(*) as hourly_count

  from {{ ref('stg_events') }}

  group by 
    session_id, 
    date_trunc('hour',created_at)

),

avg_unique_sessions_per_hour as ( 

  select 
    trunc(avg(hourly_count),2) as avg_unique_sessions_per_hour

  from unique_sessions_per_hour

)

select * from avg_unique_sessions_per_hour
