{{
  config(
    materialized='table',
    description='Order payments (may be multiple per order)'
  )
}}

with source as (
  select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
  from {{ source('olist', 'raw_order_payments') }}
)

select * from source
