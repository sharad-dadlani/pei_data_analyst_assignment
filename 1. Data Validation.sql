--1.Verify the accuracy, completeness, and reliability of source data. Show your results in a SQL or Python output.

-- Accuracy 
-- Checking for negative revenue (Data Accuracy)
-- Queries


-- a)   
SELECT *
FROM `pei-data-analyst-task.pei_data.order`
where Amount <0


Output : No Data (Data Accuracy and Reliability )

-- b) Check for age<0 or age >100  (Data Accuracy)

Select *
 	FROM
 	`pei-data-analyst-task.pei_data.customer`
 where age <0 or age>90 


Output : No Data

-- c) 	checking duplicate orders

SELECT order_id, count(*) as order_count
FROM `pei-data-analyst-task.pei_data.order`
group by 1
having count(*)>1
order by 2 desc

Output : No Data

-- d) Checking customer level duplicate 
 
SELECT customer_id,count(*)  as customer_count
 FROM `pei-data-analyst-task.pei_data.customer`
group by 1
having count(*)>1
order by 2 desc


-- e) checking Row Level Duplicate for customer_data
 
SELECT customer_id,
first as first_name,
last as last_name,
age,
country,
count(*)  as customer_count
 FROM `pei-data-analyst-task.pei_data.customer`
group by 1,2,3,4,5
having count(*)>1
order by 6 desc


Output : No Data


-- f) Checking Shipping Duplicates for Shipping Data 


SELECT shipping_id,
count(*) as shipping_count
FROM `pei-data-analyst-task.pei_data.shipping`
group by 1
having count(*)>1
order by 2 desc


Output : No Data


-- No Duplicates in the order, customer and shipping data source
-- Data is accurate and reliable  -  Unique Records 


-- g) Primary Foreign Key Relationship check between Data Sources 
 
SELECT *
FROM
`pei-data-analyst-task.pei_data.order` o
left join `pei-data-analyst-task.pei_data.customer` c on o.customer_id = c.customer_id
where c.customer_id is null


Output : No Data 
Data is Accurate and Reliable 

-- h) Completeness Check    

 SELECT count(*) as null_count_o
FROM `pei-data-analyst-task.pei_data.order` 
where order_id is null or item is null or amount is null or customer_id is null
Output - 
null_count
0

Select count(*) as null_count_c
FROM `pei-data-analyst-task.pei_data.customer`
where customer_id is null or first is null or last is null or age is null or country is null
Output - 
null_count
0


SELECT count(*) as null_count_s
FROM `pei-data-analyst-task.pei_data.shipping`
where shipping_id is null or status is null or customer_id is null
Output - 
null_count
0
