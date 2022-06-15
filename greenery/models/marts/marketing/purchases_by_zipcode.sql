{{ config( materialized='view' ) }}

select 
    zipcode, 
    state,
    order_count
from {{ ref('int_purchases_by_location') }}
