
with source as (

   select * from {{ source('greenery','users') }}

), 

renamed as (
    
    SELECT
      user_id,
      first_name, 
      last_name, 
      email, 
      phone_number,
      created_at,
      updated_at,
      address_id

    FROM
      source 

)

select * from renamed