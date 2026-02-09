{{
  config(
    materialized='table',
    description='Customer dimension with lifetime metrics'
  )
}}

SELECT
  c.customer_id,
  c.customer_city,
  c.customer_state,
  COUNT(DISTINCT o.order_id) as lifetime_orders,
  SUM(o.order_total_value) as lifetime_value,
  AVG(o.days_to_delivery) as avg_delivery_days
FROM {{ ref('stg_customers__customers') }} c
LEFT JOIN {{ ref('fct_orders') }} o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_city, c.customer_state