{{
  config(
    materialized='table',
    description='Seller performance with quality metrics'
  )
}}

SELECT
  s.seller_id,
  s.seller_city,
  s.seller_state,
  COUNT(DISTINCT oi.order_id) as orders_sold,
  COUNT(DISTINCT oi.product_id) as unique_products_sold,
  SUM(oi.price + oi.freight_value) as total_revenue,
  ROUND(AVG(oi.price + oi.freight_value), 2) as avg_item_price,
  COUNT(DISTINCT r.review_id) as total_reviews,
  ROUND(AVG(r.review_score), 2) as avg_review_score,
  ROUND(100.0 * SUM(CASE WHEN r.review_score >= 4 THEN 1 ELSE 0 END) / NULLIF(COUNT(DISTINCT r.review_id), 0), 1) as positive_review_pct,
  COUNT(DISTINCT p.product_category_name_english) as category_count
FROM {{ ref('stg_sellers__sellers') }} s
LEFT JOIN {{ ref('stg_order_items__order_items') }} oi ON s.seller_id = oi.seller_id
LEFT JOIN raw_order_reviews r ON oi.order_id = r.order_id
LEFT JOIN {{ ref('stg_products__products') }} p ON oi.product_id = p.product_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC