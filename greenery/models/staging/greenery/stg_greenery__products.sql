with source as (

   select * from {{ source('src_greenery','products') }}

), 

renamed as (
    
    select
      product_id,
      name,
      price,
      inventory

    from
      source 

)

select * from renamed
