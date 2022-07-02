{% macro get_event_types() %}


{%
  set event_types = dbt_utils.get_query_results_as_dict(
    "select distinct quote_literal(event_type) as event_type, event_type as column_name from"
    ~ ref('stg_greenery__events')
  )
%}

{% endmacro %}