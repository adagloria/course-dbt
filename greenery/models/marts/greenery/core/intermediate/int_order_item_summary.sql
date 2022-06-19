{{
  config(
    materialized = 'table'
  )
}} 

select order_id, 
    sum(quantity) number_of_items_ordered
from {{ ref('stg_greenery__order_items') }}
group by 1