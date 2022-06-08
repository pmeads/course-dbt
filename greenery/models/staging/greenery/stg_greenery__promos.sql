with source as (

   select * from {{ source('src_greenery','promos') }}

), 

renamed as (
    
    SELECT
      promo_id,
      discount,
      status

    FROM
      source 

)

select * from renamed
