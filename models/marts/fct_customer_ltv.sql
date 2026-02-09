{{
  config(
    materialized='table',
    description='Customer lifetime value with segmentation'
  )
}}

SELECT
  c.customer_id,
  c.customer_unique_id,
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT o.order_id) as total_orders,
  SUM(oi.price + oi.freight_value) as lifetime_revenue,
  ROUND(AVG(oi.price + oi.freight_value), 2) as avg_order_value,
  MIN(o.order_purchase_timestamp::date) as first_purchase_date,
  MAX(o.order_purchase_timestamp::date) as last_purchase_date,
  CASE 
    WHEN SUM(oi.price + oi.freight_value) > 1000 THEN 'High Value'
    WHEN SUM(oi.price + oi.freight_value) > 500 THEN 'Medium Value'
    ELSE 'Low Value'
  END as customer_segment,
  COUNT(DISTINCT CASE WHEN r.review_score >= 4 THEN o.order_id END) as satisfied_orders,
  ROUND(AVG(r.review_score), 2) as avg_review_score
FROM {{ ref('stg_customers__customers') }} c
LEFT JOIN {{ ref('stg_orders__orders') }} o ON c.customer_id = o.customer_id
LEFT JOIN {{ ref('stg_order_items__order_items') }} oi ON o.order_id = oi.order_id
LEFT JOIN raw_order_reviews r ON o.order_id = r.order_id
GROUP BY c.customer_id, c.customer_unique_id, c.customer_city, c.customer_state