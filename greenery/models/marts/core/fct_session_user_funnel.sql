{{ config( materialized='table' ) }}

-- import CTEs
with session_funnel as ( select * from {{ ref('int_session_funnel') }} ),

users as ( select * from {{ ref('dim_users') }} ),

-- logical CTEs

funnel_with_user_detail as (

    select 
        s.session_id,
        s.page_view_event,
        s.add_to_cart_event,
        s.checkout_event,
        u.*
    from session_funnel as s
    join users as u on u.user_id = s.user_id 

)

select * from funnel_with_user_detail