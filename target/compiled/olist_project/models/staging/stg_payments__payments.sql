

with source as (
  select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
  from "olist"."main"."raw_order_payments"
)

select * from source