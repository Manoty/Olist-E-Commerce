
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "olist"."analytics_staging"."stg_customers__customers"
where customer_id is not null
group by customer_id
having count(*) > 1


