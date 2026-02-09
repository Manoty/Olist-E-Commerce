

with source as (
  select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
  from "olist"."main"."raw_orders"
)


, cleaned as (
  select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::timestamp as order_purchase_at,
    order_approved_at::timestamp as order_approved_at,
    order_delivered_carrier_date::timestamp as order_delivered_carrier_at,
    order_delivered_customer_date::timestamp as order_delivered_customer_at,
    order_estimated_delivery_date::timestamp as order_estimated_delivery_at,
    case 
      when order_delivered_customer_date is not null 
      then date_diff('day', order_purchase_timestamp::timestamp, order_delivered_customer_date::timestamp)
      else null 
    end as days_to_delivery,
    case
      when order_delivered_customer_date > order_estimated_delivery_date then true
      else false
    end as is_late_delivery
  from source
)

select * from cleaned