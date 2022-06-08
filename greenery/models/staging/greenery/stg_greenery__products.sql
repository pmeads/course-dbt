with source as (

   select * from {{ source('greenery','products') }}

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
