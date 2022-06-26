{{
  config(
    materialized='table'
  )
}}


with temp_table as(

select session_id
, created_at
, events.product_id
, user_id
, order_id
, name
, sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped
, sum(case when event_type = 'checkout' then 1 else 0 end) as checkout
, sum(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart
, sum(case when event_type = 'page_view' then 1 else 0 end) as page_view

from {{ ref('stg_greenery__events') }} events
left join {{ ref('stg_greenery__products') }} products
on events.product_id = products.product_id


group by 1, 2, 3, 4, 5, 6),

products as(
     select name, session_id,
            count(distinct session_id) filter (where page_view > 0) as unique_product_views,
            count(distinct session_id) filter (where add_to_cart > 0) as number_of_carts
            
    from temp_table
    group by 1, 2
    order by 1
),

placed_orders as (
    select session_id, count(distinct  session_id ) filter (where checkout > 0) as sessions_with_checkouts from temp_table
    group by 1
)

select p.name, sum(p.unique_product_views) as views, 
sum(p.number_of_carts) carts, 
sum(po.sessions_with_checkouts) checkouts
from products p
left join placed_orders po
on p.session_id = po.session_id
group by 1
order by 1





