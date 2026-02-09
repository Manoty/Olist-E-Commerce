
  
    
    

    create  table
      "olist"."analytics_staging"."stg_order_items__order_items__dbt_tmp"
  
    as (
      

select
  order_item_id,
  order_id,
  product_id,
  seller_id,
  shipping_limit_date,
  price,
  freight_value
from "olist"."main"."raw_order_items"
    );
  
  