# <p align="center"><ins>Programming Assignment 2</ins></p>
## **<ins> Objective </ins>**
### You will continue with expressing report queries. As with the assignment #1, you will express the queries in standard SQL. The reports below are similar in nature with the reports from the assignment #1; however, there are two main differences between the two: (1) the new reports will require aggregation “outside” the groups (in assignment #1, all of the aggregates were computed for the rows within the groups); (2) some of the aggregates in the new reports will be computed based on other aggregates of the same reports – they are known as “dependent aggregates”.

## **<ins> Query 1 </ins>**
### For each product and month, count the number of sales transactions that were between the previous and the following month's average sales quantities. For January and December, you can display <NULL> or 0; alternatively, you can skip those months (those that do not have averages for the previous and/or following months).
## **<ins> Code </ins>**

```sql 
WITH q1 AS
(
SELECT month, prod AS product, avg(quant) as avg_quant
FROM sales s
GROUP BY month, prod 
),

prev_avg AS (
select m1.month, m1.product Products, m2.avg_quant AS prev_avg, m2.month before_month
from q1 m1 left join q1 m2
on m1.product = m2.product and m1.month - 1 = m2.month
),
next_avg AS (
select m1.month, m1.product Product, m2.avg_quant AS next_avg, m2.month before_month
from q1 m1 left join q1 m2
on m1.product = m2.product and m1.month + 1 = m2.month
),

reference AS 
(
select p.month, p.Products, p.prev_avg, n.next_avg
from prev_avg p, next_avg n
WHERE p.Products = n.Product and p.month = n.month
)

select r.products, r.month, Count(quant) AS Sales_Count_Between_Avgs
FROM sales s, reference r
WHERE s.prod = r.products AND s.month = r.month
AND (s.quant between r.prev_avg and r.next_avg 
OR  s.quant between r.next_avg and r.prev_avg)
GROUP BY r.products, r.month, r.prev_avg, r.next_avg

order by r.products, month
```

## **<ins> Query 2 </ins>**
### For customer and product, show the average sales before, during and after eachquarter (e.g., for Q2, show average sales of Q1 and Q3. For “before” Q1 and “after” Q4, display <NULL>. The “YEAR” attribute is not considered for this query – for example, both Q1 of 2007 and Q1 of 2008 are considered Q1 regardless of the year.
## **<ins> Code </ins>**
```sql 
WITH q1 AS (
	SELECT cust customer, prod as Product, month months, ceiling(month/3.0) qtr, quant
	FROM sales
),
q2 AS
	(SELECT q1.customer, q1.Product, avg(quant) as avg_quant, q1.qtr
	FROM q1
	GROUP BY customer, Product, qtr
	),
q3 AS (
select m1.customer Customer, m1.qtr QTR, m1.Product product, m2.avg_quant AS before_avg
from q2 m1 full outer join q2 m2
on m1.Product = m2.Product and m1.customer = m2.customer and m1.qtr - 1 = m2.qtr
),
q4 AS (
select m1.customer Customer, m1.qtr QTR, m1.Product product, m2.avg_quant AS after_avg
from q2 m1 full outer join q2 m2
on m1.Product = m2.Product and m1.customer = m2.customer and m1.qtr + 1 = m2.qtr
),
q5 AS (
select m1.customer Customer, m1.qtr QTR, m1.Product product, m2.avg_quant AS during_avg
from q2 m1 full join q2 m2
on m1.Product = m2.Product and m1.customer = m2.customer and m1.qtr = m2.qtr
)
select q3.Customer, q3.Product, q3.QTR, q3.before_avg Before_Avg, q5.during_avg During_Avg, q4.after_avg After_Avg
from q3, q4, q5
WHERE q3.product = q4.product and q3.QTR = q4.QTR and q3.Customer = q4.Customer AND
q4.product = q5.product and q4.QTR = q5.QTR and q4.QTR = q5.QTR 
and q3.product = q5.product and q3.QTR = q5.QTR and q3.Customer = q5.Customer
ORDER by q3.Customer, q3.product, q3.qtr
```

## **<ins> Query 3 </ins>**
### For each customer, product and state combination, compute (1) the product’s average sale of this customer for the state (i.e., the simple AVG for the group-by attributes – this is the easy part), (2) the average sale of the product and the state but for all of the other customers and (3) the customer’s average sale for the given state, but for all of the other products.
## **<ins> Code </ins>**
```sql 
WITH q1 AS
(
SELECT cust customer, prod AS Product, state as st, avg(quant) as prod_avg
FROM sales s
GROUP BY cust, prod, state
),
q2 AS 
(
SELECT q1.customer, q1.st, q1.Product, avg(s.quant) as other_prod_avg
FROM q1, sales s
WHERE q1.customer = s.cust and q1.st = s.state AND q1.Product != s.prod
GROUP BY q1.customer, q1.Product, q1.st 
),
q3 AS (
SELECT q1.customer, q1.st, q1.Product, avg(s.quant) as other_cust_avg
FROM q1, sales s
WHERE q1.customer != s.cust and q1.st = s.state AND q1.Product = s.prod
GROUP BY q1.customer, q1.Product, q1.st
)
SELECT q1.customer Customer, q1.Product, q1.st State, q1.prod_avg Prod_Avg, q3.other_cust_avg Other_Cust_Avg, q2.other_prod_avg Other_Prod_Avg
FROM q1, q2, q3
WHERE q1.customer = q2.customer AND q1.Product = q2.Product AND q1.st = q2.st
AND q2.customer = q3.customer AND q2.Product = q3.Product AND q2.st = q3.st
AND q3.customer = q1.customer AND q3.Product = q1.Product AND q3.st = q1.st

ORDER BY Customer, Product, State
```


## **<ins> Query 4 </ins>**
### For each product, find the median sales quantity (assume an odd number of sales for simplicity of presentation). (NOTE – “median” is defined as “denoting or relating to a value or quantity lying at the midpoint of a frequency distribution of observed values or quantities, such that there is an equal probability of falling above or below it.” E.g., Median value of the list {13, 23, 12, 16, 15, 9, 29} is 15.
## **<ins> Code </ins>**
