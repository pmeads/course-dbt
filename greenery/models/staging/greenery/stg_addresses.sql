with source as (

   select * from {{ source('greenery','addresses') }}

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
