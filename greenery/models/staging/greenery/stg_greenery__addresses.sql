{{
  config(
    materialized='view'
  )
}}

with address_source as (
    select * from {{source('src_greenery', 'addresses')}}
),

renamed_recast as (select
    address_id,
    address,
    zipcode,
    state,
    country 
    from address_source
)


select * from renamed_recast