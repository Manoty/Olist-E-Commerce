
    
    

select
    order_id as unique_field,
    count(*) as n_records

from "olist"."analytics_staging"."stg_orders__orders"
where order_id is not null
group by order_id
having count(*) > 1


