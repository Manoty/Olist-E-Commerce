
  
    
    

    create  table
      "olist"."analytics_staging"."stg_payments__payments__dbt_tmp"
  
    as (
      

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
    );
  
  