{{
  config(
    materialized = 'table'
  )
}} 

with session_length as (
  select 
    session_id
    , min(created_at) as first_event
    , max(created_at) as last_event
  from {{ ref('stg_greenery__events') }}
  group by 1
)

select
  int_session_events_basic_agg.session_id
  , int_session_events_basic_agg.user_id
  , stg_greenery__users.first_name
  , stg_greenery__users.last_name
  , stg_greenery__users.email
  , int_session_events_basic_agg.page_view
  , int_session_events_basic_agg.add_to_cart
  , int_session_events_basic_agg.checkout
  , int_session_events_basic_agg.package_shipped
  , int_products_viewed_count.distinct_products_viewed as products_viewed
  , session_length.first_event as first_session_event
  , session_length.last_event as last_session_event
  , (date_part('day', session_length.last_event::timestamp - session_length.first_event::timestamp) * 24 + 
      date_part('hour', session_length.last_event::timestamp - session_length.first_event::timestamp)) * 60 +
      date_part('minute', session_length.last_event::timestamp - session_length.first_event::timestamp)
    as session_length_minutes

from {{ ref('int_session_events_basic_agg') }}
left join {{ ref('stg_greenery__users') }}
  on int_session_events_basic_agg.user_id = stg_greenery__users.user_guid
left join session_length
  on int_session_events_basic_agg.session_id = session_length.session_id
left join {{ ref('int_products_viewed_count') }}
  on int_session_events_basic_agg.session_id = int_products_viewed_count.session_id