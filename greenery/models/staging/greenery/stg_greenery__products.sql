with source as (

   select * from {{ source('src_greenery','products') }}

), 

renamed as (
    
    select
      product_id,
      name as product_name,
      price as product_price,
      inventory as product_inventory

    from
      source 

)

select * from renamed
