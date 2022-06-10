with source as (

   select * from {{ source('src_greenery','addresses') }}

), 

renamed as (
    
    select
      address_id,
      address,
      zipcode,
      state,
      country

    from
      source 

)

select * from renamed