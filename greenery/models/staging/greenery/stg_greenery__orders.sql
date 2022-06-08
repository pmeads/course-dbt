with source as (

   select * from {{ source('src_greenery','orders') }}

), 

renamed as (
    
    SELECT
      order_id,
      user_id,
      promo_id,
      address_id,
      created_at as created_at_utc,
      order_cost,
      shipping_cost,
      order_total,
      tracking_id,
      shipping_service,
      estimated_delivery_at as estimated_delivery_at_utc,
      status

    FROM
      source 

)

select * from renamed
