{{
  config(
    materialized='table',
    description='Seller dimension with performance metrics'
  )
}}

SELECT
  s.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) as orders_sold,
  SUM(oi.item_total_value) as total_revenue,
  AVG(oi.item_total_value) as avg_item_price
FROM {{ ref('stg_sellers__sellers') }} s
LEFT JOIN {{ ref('stg_order_items__order_items') }} oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state