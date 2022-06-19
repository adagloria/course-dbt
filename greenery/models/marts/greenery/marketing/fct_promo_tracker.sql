{{
  config(
    materialized='table'
  )
}}

select stg_greenery__promos.promo_id, 
    stg_greenery__promos.discount,
    stg_greenery__promos.status as promo_status,
    sum(int_promo_order_summary.total_items_ordered)as total_items_ordered,
    sum(int_promo_order_summary.total_cost_for_ordered_items)as total_cost_for_ordered_items


from {{ ref('stg_greenery__promos') }}
left join {{ ref('int_promo_order_summary') }}
 on stg_greenery__promos.promo_id = int_promo_order_summary.promo_id


group by 1, 2, 3