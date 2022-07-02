{{
  config(
    materialized='table'
  )
}}

select months
      , (all_sessions - page_view_sessions) page_view_drop_off
      , (page_view_sessions - add_to_cart_sessions) add_to_cart_drop_off
      , (add_to_cart_sessions - checkout_sessions) check_out_drop_off
       from {{ ref('fct_funnel_monitoring') }}