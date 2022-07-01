{% snapshot drop_offs_by_product_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='product_id',

      strategy='timestamp',
      updated_at='updated_at',
    )
  }}

  select * from {{ ref('drop_offs_by_product') }}

{% endsnapshot %}