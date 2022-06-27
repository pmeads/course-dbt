{% macro make_binary_cols_for_lov(in_ref,in_column_name, in_col_suffix) %}
  
  -- get list of VALUES
  {%- set lov_types = dbt_utils.get_column_values(
    table=ref(in_ref),
    column=in_column_name) -%}

  {%- for lov_type in lov_types %}
      case {{in_column_name}} when '{{lov_type}}' then 1 else 0  end as {{lov_type}}_{{in_col_suffix}}
      {%- if not loop.last %},{% endif -%}
  {% endfor %}

{% endmacro %}