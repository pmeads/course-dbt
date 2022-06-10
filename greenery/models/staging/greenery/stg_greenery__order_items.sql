with source as (

   select * from {{ source('src_greenery','order_items') }}

), 

renamed as (
    
    select
      order_id,
      product_id,
      quantity

    from
      source 

)

select * from renamed
