{% macro get_payment_methos() %}

{% set payment_mehods_sql %}

select DISTINCT
payment_method
from {{ ref('raw_payments') }}
order by 1

{% endset %}

{{% set results = run_query(payment_methods_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}