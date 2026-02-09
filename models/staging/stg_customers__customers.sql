{{
  config(
    materialized='table',
    description='Cleaned customer dimension with location'
  )
}}

with source as (
  select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
  from {{ source('olist', 'raw_customers') }}
)

select
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
from source