{{
  config(
    materialized='table'
  )
}}

select order_id, 
    user_id,
    address_id,
    created_at as time_of_order,
    order_cost,
    shipping_cost,
    order_total,
    shipping_service,
    estimated_delivery_at as estimated_delivery_date,
    delivered_at as delivery_date,
    status as order_status

from {{ ref('stg_greenery__orders') }}