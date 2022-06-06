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
this info was derived by assuming the estimated delivery did not differ from the real delivery date. 
typically, you'd have a status = 'completed' along with another date field like 'delivered_at'

select avg(estimated_delivery_at - created_at) as time_diff
from dbt_philip_m.stg_orders
>> 2 days 22:23:41.656051

- how many users made a particular amount of purchases
with user_orders as (
  select user_id, count(*) user_order_count
  from dbt_philip_m.stg_orders
  group by user_id
), 
order_count as (
  select user_order_count, count(*) order_count
  from user_orders
  group by user_order_count
  order by user_order_count
)
select order_count, user_order_count
from order_count
>> 25 --> 1
28 --> 2
34 --> 3
20 --> 4
10 --> 5
2 --> 6
4 --> 7
1 --> 8

- on avgerage, how many unique session do we have per hour? 
with sessions_per_hour as (
  select session_id, date_trunc('hour',created_at) as hour, count(*) as hourly_count
  from dbt_philip_m.stg_events
  group by session_id, date_trunc('hour',created_at)
)
select trunc(avg(hourly_count),2) avg_sessions_per_hour
from sessions_per_hour
>> 3.75