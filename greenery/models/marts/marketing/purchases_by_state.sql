{{ config( materialized='view' ) }}

select state, 
       sum(order_count) as order_count
from {{ ref('int_purchases_by_location') }}
group by state
order by 2