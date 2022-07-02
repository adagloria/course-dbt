{{
  config(
    materialized = 'table'
  )
}}

{%
  set event_types = get_event_types
%}

select
  session_id
  , created_at
  , user_id
  {% for event_type in event_types['event_type'] %}
  , sum(case when event_type = {{event_type}} then 1 else 0 end) as {{ event_types['column_name'][loop.index0] }}
  {% endfor %}
from {{ ref('stg_greenery__events') }}

group by 1,2,3