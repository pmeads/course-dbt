{% snapshot customer_funnel_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='header',

      strategy='timestamp',
      updated_at='updated_at',
    )
  }}

  select * from {{ ref('customer_funnel') }}

{% endsnapshot %}