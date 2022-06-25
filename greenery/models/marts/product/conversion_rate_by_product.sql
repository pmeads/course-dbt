{{ config( materialized='table' ) }}

-- import CTEs 
with events as (

    select * from {{ ref('fct_events') }}

),

product_checkouts as ( 

  select
    b.product_id, 
    count(distinct (a.session_id )) as checkout_count
  from events as a
  join fct_events as b on b.session_id = a.session_id 
  where a.checkout_event = 1
  and b.product_id is not null
  group by b.product_id
  order by product_id

), 

product_page_views as (

    select
    b.product_id, 
    count(distinct (a.session_id )) as page_view_count
    from fct_events as a
    join fct_events as b on b.session_id = a.session_id 
    where a.page_view_event = 1
    and b.product_id is not null
    group by b.product_id
    order by product_id

),

product_final as (

  select
    checkout_count,
    page_view_count,
    trunc(round(checkout_count / page_view_count::decimal,2) * 100) || '%' as conversion_rate_by_product
  FROM product_checkouts as a
  join product_page_views as b on b.product_id = a.product_id
  order by 3 desc
    

)

select * from product_final