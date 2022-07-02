
{{
  config(
    materialized='table'
  )
}}
select session_id, user_id, count(distinct page_url) distinct_products_viewed
from {{ ref('stg_greenery__events') }}
where event_type='page_view'
group by 1,2