
  
    
    

    create  table
      "olist"."analytics_staging"."stg_customers__customers__dbt_tmp"
  
    as (
      

with source as (
  select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
  from main.raw_customers
)

select
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  customer_city,
  customer_state
from source
    );
  
  