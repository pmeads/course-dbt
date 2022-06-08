with source as (

   select * from {{ source('src_greenery','addresses') }}

), 

renamed as (
    
    SELECT
      address_id,
      address,
      zipcode,
      state,
      country

    FROM
      source 

)

select * from renamed
