{{ config( materialized='table' ) }}

with sessions as (
        select 
            distinct session_id, user_id 
        from {{ ref('fct_events') }}
    ),
add_to_cart as (
        select 
            distinct fct_events.session_id 
        from fct_events
        where add_to_cart_event = 1
        ),
checkout as (
        select 
            distinct fct_events.session_id 
        from fct_events
        where checkout_event = 1
),
final_cte as (
    select 
        s.user_id,
        s.session_id, 
        case when s.session_id is not null then 1 else 0 end as page_view_event,
        case when atc.session_id is not null then 1 else 0 end as add_to_cart_event,
        case when co.session_id is not null then 1 else 0 end as checkout_event
    from sessions as s
    left join add_to_cart as atc on atc.session_id = s.session_id
    left join checkout as co on co.session_id = s.session_id
    order by s.user_id, s.session_id
)
select * from final_cte