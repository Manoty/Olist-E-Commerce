{{
  config(
    materialized='table',
    description='Order line items'
  )
}}

select
  order_item_id,
  order_id,
  product_id,
  seller_id,
  shipping_limit_date,
  price,
  freight_value
from {{ source('olist', 'raw_order_items') }}