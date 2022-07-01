
{{ config( materialized='table' ) }}

with product_drop_offs as (
  select 
        spf.product_id,
        p.name as product_name, 
        sum(case when spf.page_view_event = 1 then 1 else 0 end) as product_viewed,
        sum(case when spf.page_view_event = 1 and spf.add_to_cart_event = 1 then 1 else 0 end) as viewed_products_added_to_cart,
        sum(case when spf.page_view_event = 1 and spf.add_to_cart_event = 0 then 1 else 0 end) as viewed_products_not_added_to_cart,
        sum(case when spf.add_to_cart_event = 1 and spf.product_sold = 'N' then 1 else 0 end) as product_in_cart_not_purchased
    from {{ ref('int_session_product_funnel') }} as spf
    left join {{ ref('dim_products') }} as p on p.product_id = spf.product_id
    group by spf.product_id, product_name
)
select 
    product_id,
    product_name,
    product_viewed,
    viewed_products_not_added_to_cart,
    product_in_cart_not_purchased,
    round(viewed_products_not_added_to_cart::decimal/product_viewed,2) as product_not_added_to_cart_rate,
    round(product_in_cart_not_purchased::decimal/viewed_products_added_to_cart,2) as product_in_cart_not_purchased_rate,
    current_timestamp(1) as updated_at
from product_drop_offs 
order by product_name