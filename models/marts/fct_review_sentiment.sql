{{
  config(
    materialized='table',
    description='Order reviews with sentiment analysis'
  )
}}

SELECT
  r.review_id,
  r.order_id,
  o.order_id is not null as order_exists,
  r.review_score,
  CASE 
    WHEN r.review_score >= 4 THEN 'Positive'
    WHEN r.review_score = 3 THEN 'Neutral'
    ELSE 'Negative'
  END as sentiment,
  LENGTH(r.review_comment_message) as comment_length,
  CASE WHEN r.review_comment_message IS NOT NULL THEN 1 ELSE 0 END as has_comment,
  r.review_creation_date::date as review_date,
  p.product_category_name_english,
  s.seller_city
FROM raw_order_reviews r
LEFT JOIN {{ ref('stg_orders__orders') }} o ON r.order_id = o.order_id
LEFT JOIN raw_order_items oi ON r.order_id = oi.order_id
LEFT JOIN {{ ref('stg_products__products') }} p ON oi.product_id = p.product_id
LEFT JOIN {{ ref('stg_sellers__sellers') }} s ON oi.seller_id = s.seller_id