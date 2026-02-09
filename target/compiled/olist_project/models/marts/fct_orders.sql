

SELECT
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_purchase_at,
  o.order_approved_at,
  o.order_delivered_customer_at,
  o.order_estimated_delivery_at,
  o.days_to_delivery,
  o.is_late_delivery,
  COUNT(DISTINCT oi.order_item_id) as num_items,
  SUM(oi.item_total_value) as order_total_value,
  COUNT(DISTINCT p.payment_sequential) as num_payments
FROM "olist"."analytics_staging"."stg_orders__orders" o
LEFT JOIN "olist"."analytics_staging"."stg_order_items__order_items" oi ON o.order_id = oi.order_id
LEFT JOIN "olist"."analytics_staging"."stg_payments__payments" p ON o.order_id = p.order_id
GROUP BY o.order_id, o.customer_id, o.order_status, o.order_purchase_at, o.order_approved_at, 
         o.order_delivered_customer_at, o.order_estimated_delivery_at, o.days_to_delivery, o.is_late_delivery