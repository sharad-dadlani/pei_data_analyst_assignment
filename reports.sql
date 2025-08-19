**Enable Business Reporting Requirement**
  
-- 1. The total amount spent and the country for the Pending delivery status for each country.
-- With current data sources Joining order with shipping on customer id will result in data inaccuracy. Join will be at order_id level for accurate reporting . Datasets updated in the sheet.
 
--Updated dataset used

-- Query : 
Select c.country,
sum(amount) as total_amount_spend
from pei_data.order o
inner join pei_data.customer c on o.customer_id = c.customer_id
inner join pei_data.shipping s on o.order_id = s.order_id
where s.status = 'Pending'
group by 1


-- 2. the total number of transactions, total quantity sold, and total amount spent for each customer, along with the product details.
-- Updated Dataset used

Select c.customer_id,
concat(first,'',last) as customer_name,
c.country,
count(distinct order_id) as total_transactions,
sum(quantity) as total_quantity,
sum(amount) as total_amount_spend
from
pei_data.order o
inner join pei_data.customer c on o.customer_id = c.customer_id
group by 1,2,3
  
--3. the maximum product purchased for each country.

with pid_data as
(
Select c.country,
id_product,
item as product_name,
sum(quantity) as quantity
from order o
inner join customer c on o.customer_id = c.customer_id
group by 1,2,3
),
rank_data as
(
Select country,
id_product,
product_name ,
quantity,
dense_rank() over(partition by country order by quantity desc ) as rn
from pid_data
)
Select
country,
id_product,
product_name,
quantity
from rank_data
where rn = 1

  
--4. The most purchased product based on the age category less than 30 and above 30.

with prod_detail as
(
SELECT  
id_product,
item as product_name,
case when age<30 then 'age less than 30'
when age>= 30 then '30 and above'
end as age_category ,
sum(quantity) as quantity
 FROM
 pei_data.order o
inner join pei_data.customer c on o.customer_id = c.customer_id  
group by 1,2,3
),
rn as
(
Select age_category,
id_product,
product_name,
quantity,
dense_rank() over(partition by age_category order by quantity desc ) as rnk  
from prod_detail
)
Select age_categoty,
id_product,
product_name,
quantity
from rn
where rnk = 1
  
-- 5. the country that had minimum transactions and sales amount.

with transaction_detail as
(
Select
c.country,
count(distinct o.order_id) as total_transactions,
sum(amount) as total_sales
From pei_data.order o
Inner join pei_data.customer c on o.customer_id = c.customer_id
group by 1
),
rn as
(
Select  
country,
total_transactions,
total_sales,
dense_rank() over(order by total_transactions, total sales) as rnk
from transaction_detail
)
Select country,
total_transactions,
total_sales  
from
rn
where rnk=1  
