Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices


### Week 1 questions and answers
- users
>>130
- avg orders per hour
with orders_per_hours as (

  select 
    count(*),
    date_trunc('hour',created_at) as hour
    
  from dbt_philip_m.stg_orders
  group by date_trunc('hour',created_at)

)

select trunc(avg(count),1) from orders_per_hours
>>7.5

- avg time order takes from being placed to being delivered

select avg(delivered_at_utc - created_at_utc) as time_diff 
from dbt_philip_m.stg_greenery__orders;
>> 3 days 21:24:11.803279

- how many users made a particular amount of purchases
with user_orders as (

  select 
    user_id, 
    count(*) user_order_count
  
  from dbt_philip_m.stg_orders
  
  group by user_id
  
), 

order_count as (

  select 
    user_order_count as number_of_purchases, 
    count(*) as number_of_users_who_purchased_this_amount
  
  from user_orders
  
  group by user_order_count
  
  order by user_order_count
  
)

number_of_purchases	number_of_users_who_purchased_this_amount
1	25
2	28
3	34
4	20
5	10
6	2
7	4
8	1

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
>> 16.32