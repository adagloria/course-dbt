###### 1. What is our user repeat rate?

```sql
with orders_cohort as (
select user_id 
,count (distinct order_id)as user_orders
from dbt.dbt_adaugo_o.stg_greenery__orders
group by 1)
,user_bucket as (
  select user_id
  ,(user_orders = 1) ::int as has_one_purchases
  ,(user_orders >=2)::int as has_two_purchases
  ,(user_orders >=3)::int as has_three_purchases
  from orders_cohort
  )
 select sum(has_two_purchases)::float
  / count(distinct user_id)::float as repeat_rate
from user_bucket;

```
Result:  0.79

-----------------------------------------------------------------------------------------------

###### 2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Session length and multiple page visits are good indicators to pick out users who would likely purchase again.

Other features that could help in prediciting repeat buyers are more specific customer information like gender, age, employed(Y/N) etc. This would help us build profiles, segment users, understand their needs and better predict their likelihood of purchasing more than once

------------------------------------------------------------------------------------------------

###### 3. Explain the marts models you added. Why did you organize the models in the way you did?

***Product:*** I created models under this category to help track session activity to help the business team understand user behavior and interaction. The intermediate model was used to perform a basic aggregation while the fact table was used to output all the needed details regarding the sesion and users

***Core:*** The models under the Core category provides delivery information. Helps to answer questions around delivery duration and assesses if delivery KPIs are met (e.g. are orders delivered on or before the estimated delivery date?)

***Marketing:*** The models created give high level information about promos and measures sales during such periods. My intermediate model performed a basic aggregation between the orders and order_items tables, in order to make the code more readable.

-------------------------------------------------------------------------------------------------

###### 4. What assumptions are you making about each model? (i.e. why are you adding each test?)

I expect that each model must have a non-null unique primary key, so I designed my tests to check for this. 
I noticed some duplicated records for my delivery tracker model under the **Core** sub-folder, I am investigating and working on resolving the error.

-------------------------------------------------------------------------------------------------

###### 5. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

I would ensure to execute dbt test after every dbt runs, after which I would resolve all the errors that were thrown up. For every new model or modification, the tests must be repeated to ensure accuracy.
It's also a good idea to monitor changes in the sources/models that serve as inputs and dependencies to other models, therefore there should be tests for every model and source in our warehouse.

