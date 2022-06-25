{{ config( materialized='table' ) }}
{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_greenery__events'),
    column='event_type') -%}

-- import CTEs
with greenery_events as (

    select *
    from {{ ref('stg_greenery__events') }}

),

-- logical CTEs
events_with_type_cols as (

  select user_id, session_id, order_id, product_id, event_type,
    {%- for event_type in event_types %}
      case event_type when '{{event_type}}' then 1 else 0  end as {{event_type}}_event
      {%- if not loop.last %},{% endif -%}
    {% endfor %}
  from greenery_events

)

-- simple query
select * from events_with_type_cols