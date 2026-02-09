
  
    
    

    create  table
      "olist"."analytics_staging"."stg_sellers__sellers__dbt_tmp"
  
    as (
      

with source as (
  select
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
  from main.raw_sellers
)

select * from source
    );
  
  