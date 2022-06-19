{{
  config(
    materialized='table'
  )
}}

select stg_greenery__orders.order_id, 
stg_greenery__orders.promo_id,
sum(stg_greenery__order_items.quantity) as total_items_ordered,
sum(stg_greenery__orders.order_cost) as total_cost_for_ordered_items

from {{ ref('stg_greenery__orders') }} 
left join {{ ref('stg_greenery__order_items') }} 
on stg_greenery__orders.order_id = stg_greenery__order_items.order_id

group by 1,2