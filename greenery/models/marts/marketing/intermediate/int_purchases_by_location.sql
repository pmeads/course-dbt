{{ config( materialized='table' ) }}

select 
  a.state, 
  a.zipcode, 
  count(*) as order_count
from {{ ref('fct_orders') }} as o
left join {{ ref('dim_addresses') }} a on a.address_id = o.address_id

group by a.state, a.zipcode

order by 3 desc 

