with source as (

   select * from {{ source('src_greenery','products') }}

), 

renamed as (
    
    SELECT
      product_id,
      name,
      price,
      inventory

    FROM
      source 

)

select * from renamed
