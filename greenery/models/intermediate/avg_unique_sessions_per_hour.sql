-- on avgerage, how many unique session do we have per hour? 
with sessions_each_hour as ( 

  select 
    distinct session_id, 
    date_trunc('hour',created_at_utc) as hour  

  from dbt_philip_m.stg_greenery__events

  order by 2

), 
sessions_per_hour as (

  select 
     hour, 
     count(*) as hourly_count

  from sessions_each_hour

  group by hour

)

select trunc(avg(hourly_count),2) avg_sessions_per_hour from sessions_per_hour