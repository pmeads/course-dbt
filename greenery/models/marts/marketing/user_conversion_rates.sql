{{ config( materialized='table' ) }}

with funnel as (
   select 
        'Count' as header,
        sum(page_view_event) as page_view, 
        sum(add_to_cart_event) as add_to_cart,
        sum(checkout_event) as checkouts,
        1 as field_order
    from {{ ref('int_session_funnel') }}

),

session_conversion_rate as (

    select  'Session Conversion Rate' as header,
            1.00 as page_view,
           (round(add_to_cart::decimal/page_view,2)) as add_to_cart,
           (round(checkouts::decimal/page_view,2)) as checkouts,
           2 as field_order
    from funnel
),

checkout_conversion_rate as (

    select 'Checkout Conversion Rate' as header,
           0 as page_view,
           0 as add_to_cart,
           (round(checkouts::decimal/add_to_cart,2)) as checkouts,
           3 as field_order
    from funnel
),

union_cte as (

  select * from funnel
  UNION
  select * from session_conversion_rate
  UNION
  select * from checkout_conversion_rate

)

select 
    header, 
    page_view, 
    add_to_cart, 
    checkouts, 
    current_timestamp(1) as updated_at -- for snapshots
from union_cte 
order by field_order