1. How many users do we have?

```sql
select count(distinct user_guid) 
from dbt.dbt_adaugo_o.stg_greenery__users;
```
Result: 130 users

------------------------------------------------------------------------

2. On average, how many orders do we receive per hour?

```sql
	with order_count as (
	SELECT count(distinct order_id) orders, 
			EXTRACT(HOUR FROM created_at), EXTRACT(DAY FROM created_at)
		from dbt.dbt_adaugo_o.stg_greenery__orders  
		group by 2,3)
		
	select round(avg(orders), 0) orders_per_hour from order_count
```
Result:  
8

-----------------------------------------------------------------------------
3. On average, how long does an order take from being placed to being delivered?

```sql
select avg(delivered_at - created_at) as avg_delivery_time 
from dbt.dbt_adaugo_o.stg_greenery__orders
where delivered_at is not null;
```

Result: 
3 days 21 hours, 24 minutes, 11.8 seconds

--------------------------------------------------------------------------------
4. How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

```sql
with tmp_table as (
select user_id, count(distinct order_id)counts 
from dbt.dbt_adaugo_o.stg_greenery__orders
group by 1)
select sum(case when counts >= 3 then 1 else 0 end) as Three_or_more_purchases,
       sum(case when counts = 2 then 1 else 0 end) as Two_purchases,
       sum(case when counts = 1 then 1 else 0 end) as One_purchases
  from tmp_table
```

Result: Three_or_more_purchases: 71; 
        Two_purchases: 28; 
        One_purchase: 25

-------------------------------------------------------------------------
5. On average, how many unique sessions do we have per hour?

```sql
	with counts as 
	(SELECT date_trunc('hour',  created_at) as hour, 
    count(distinct(session_id)) counts
	from  dbt.dbt_adaugo_o.stg_greenery__events
	group by 1)
  
  select round(avg(counts), 0) unique_sessions from counts

```

Result:  16