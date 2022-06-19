{{
  config(
    materialized = 'table'
  )
}} 

with delivery_time as (
  select 
    order_id, 
    (delivery_date::date - time_of_order::date) as days_taken_to_deliver,
    case 
         when estimated_delivery_date > delivery_date then 'Early delivery'
         when estimated_delivery_date < delivery_date then 'Late delivery'
         else 'Delivered as estimated'
    END as delivery_KPI
  from {{ ref('int_delivery_info') }}
  where order_status = 'delivered'
)

select int_delivery_info.order_id, 
    int_delivery_info.user_id,
    stg_greenery__users.first_name,
    stg_greenery__users.last_name,
    stg_greenery__users.email,
    int_delivery_info.address_id,
    stg_greenery__addresses.address as delivery_address,
    stg_greenery__addresses.zipcode as delivery_zipcode,
    stg_greenery__addresses.state as delivery_state,
    stg_greenery__addresses.country as delivery_country,
    int_delivery_info.time_of_order,
    int_delivery_info.order_cost,
    int_order_item_summary.number_of_items_ordered,
    int_delivery_info.shipping_cost,
    int_delivery_info.order_total,
    int_delivery_info.shipping_service,
    int_delivery_info.estimated_delivery_date,
    int_delivery_info.delivery_date,
    int_delivery_info.order_status,
    delivery_time.days_taken_to_deliver,
    delivery_time.delivery_KPI

from {{ ref('int_delivery_info') }}
left join {{ ref('stg_greenery__users') }}
  on int_delivery_info.user_id = stg_greenery__users.user_guid
left join {{ ref('stg_greenery__addresses') }}
  on int_delivery_info.address_id = stg_greenery__users.address_guid
left join {{ ref('int_order_item_summary') }}
  on int_delivery_info.order_id = int_order_item_summary.order_id
left join delivery_time
  on int_delivery_info.order_id = delivery_time.order_id