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


### Week 2: Models, Tests

What is our user repeat rate?
(Repeat Rate = Users who purchased 2 or more times / users who purchased)

`
with user_orders as (

  select 
    user_id, 
    count(*) user_order_count
  
  from stg_greenery__orders
  
  group by user_id
),
user_order_counts as (

  select 
    count(*) as users_who_ordered, 
    sum(
        case 
          when user_order_count > 1 
          then 1 
          else 0 
        end
    ) as users_who_ordered_more_than_once
    
  from user_orders
)

select 
  round((users_who_ordered_more_than_once::decimal/users_who_ordered),2) as customer_order_repeat_rate
  
from user_order_counts
`

What are good indicators of a user who will likely purchase again? 

- the estimated delivery date was same day as delivered at
- website was easy to navigate 
What are indicators users are unlikely to purchase again? If you had more data, what features would you want to look into to answer this question?
- delivery was late

## marts
# core
- dim_users
- dim_locations
- dim_products
- fct_orders
- fct_order_items
- fct_events
# marketing
- fct_user_events
- fct_user_orders
- fct_user_order_items
what metrics might be particularly useful for marketing?
- what location purchased more by state? by zip? done
- what marketing campains led to sales?  done
- what is the average amount of a product when bought? done
- on avg how long did it take for a customer to reorder a product? 
- which products are reordered? done
- which users ordered the most? done
- what is the avg amount spent? done
- which shipping service had more delays? done
- what orders are preparing but already past their estimated delivery at? - can't do this one as date is stale

# product
what metrics might be particularly useful for products?
- which products did better? which didn't sell and should be phazed out? 
- which products sold together? 
- which products did better by location?
- which products were viewed the most?
- which products were viewed and bought? 
- which products were viewed and did not result in a sale
- which products are out of stock or low on stock?

## Explain the marts models you added. Why did you organize the models in the way you did?
This was a tough assignment because I am very far removed from marketing! I have little business acumen 
but with that said, I believe the strenght of this project was creating models in order to 
answer business questions. For each question that I came up with a possible interest to each department, 
I tried to write a sql statement against the staging tables to answer it. With this approach, 
I realized what fact and dimension tables I could create to satisfy the business need. When there 
was SQL that would be used in more than one place, I created an intermediate model. 
I started out in the models/marts/core dir and created some generic dimension and fact tables. 
Then in the marketing and product folders under models/marts, i tried to create models that would 
use the core tables to answer the questions I came up with. 
