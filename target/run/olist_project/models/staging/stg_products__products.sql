
  
    
    

    create  table
      "olist"."analytics_staging"."stg_products__products__dbt_tmp"
  
    as (
      

with products as (
  select
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
  from "olist"."main"."raw_products"
)

, category_translation as (
  select
    product_category_name,
    product_category_name_english
  from main.raw_product_category_translation
)

, joined as (
  select
    p.product_id,
    p.product_category_name,
    ct.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
  from products p
  left join category_translation ct
    on p.product_category_name = ct.product_category_name
)

select * from joined
    );
  
  