with source as (

   select * from {{ source('src_greenery','order_items') }}

), 

renamed as (
    
    SELECT
      order_id,
      product_id,
      quantity

    FROM
      source 

)

select * from renamed
