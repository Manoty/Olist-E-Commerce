{{
  config(
    materialized='table',
    description='Seller dimension with location'
  )
}}

with source as (
  select
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
  from main.raw_sellers
)

select * from source