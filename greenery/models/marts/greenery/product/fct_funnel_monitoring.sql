{{
  config(
    materialized='table'
  )
}}

select EXTRACT(MONTH from first_session_event) as months, count(distinct session_id) all_sessions,
       sum(case when page_view>0 then 1 else 0 end) as page_view_sessions,
       sum(case when add_to_cart>0 then 1 else 0 end) as add_to_cart_sessions,
       sum(case when checkout>0 then 1 else 0 end) as checkout_sessions
       from {{ ref('fct_sessions') }}
       group by 1