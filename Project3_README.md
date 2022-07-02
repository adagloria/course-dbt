## 1. What is our overall conversion rate?
```sql
    select round(sum(checkouts)/sum(views),2) as conversion_rate
    from dbt.dbt_adaugo_o.int_sessions_by_product 
    where name is not null
```
----------------------------------------------------------------------------------------------------------------------------------------------------------

## 2. What is our conversion rate by product?
```sql
  select name, 
   round((checkouts/views),2) as conversion_rate
    from dbt.dbt_adaugo_o.int_sessions_by_product 
    where name is not null 
    group by 1, 2
    order by 2 desc

```

-------------------------------------------------------------------------------------------------------------------------------------------------------------

## 4. What package did you install?

  - package: dbt-labs/dbt_utils
    version: 0.8.6
  - package: dbt-labs/codegen
    version: 0.7.0
  - package: calogica/dbt_date
    version: 0.5.7
  - package: brooklyn-data/dbt_artifacts
    version: 0.8.0