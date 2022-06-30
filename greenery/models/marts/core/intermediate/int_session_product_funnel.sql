{{ config( materialized='table' ) }}

with sessions as (
        select 
            distinct session_id, user_id 
        from fct_events
    ),

page_views as (
        select 
            fct_events.session_id, 
            product_id, 
            page_view_event 
        from fct_events
        join sessions on sessions.session_id = fct_events.session_id and page_view_event = 1
    ),
add_to_cart as (
        select 
            fct_events.session_id, 
            product_id, 
            add_to_cart_event 
        from fct_events
        join sessions on sessions.session_id = fct_events.session_id and add_to_cart_event = 1
        ),
checkout as (
        select 
            fct_events.session_id, 
            fct_events.order_id,
            checkout_event 
        from fct_events
        join sessions on sessions.session_id = fct_events.session_id and checkout_event = 1
),
final_cte as (
    select 
        s.user_id,
        s.session_id, 
        pv.product_id,
        co.order_id,
        pv.page_view_event,
        coalesce(atc.add_to_cart_event,0) as add_to_cart_event,
        case when coalesce(co.checkout_event,0) = 1 then 'Y' else 'N' end as product_sold
    from sessions as s
    join page_views as pv on pv.session_id = s.session_id
    left join add_to_cart as atc on atc.session_id = s.session_id and atc.product_id = pv.product_id
    left join checkout as co on co.session_id = atc.session_id
    order by s.user_id,s.session_id,pv.product_id,co.order_id
)
select * from final_cte
