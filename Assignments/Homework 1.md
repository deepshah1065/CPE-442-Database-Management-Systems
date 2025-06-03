# <p align="center"><ins>Programming Assignment 1</ins></p>
## **<ins> Objective </ins>**
### In this assignment, you will express “complex” OLAP queries in SQL. The key point of the exercise is to observe the complexity of expressing the type of such queries despite the relatively simple ideas of the queries themselves. Your mission (in addition to writing the SQL queries) is to consider the reasons for the complexity of the expression of these queries.

## **<ins> Query 1 </ins>**
### For each customer, compute the minimum and maximum sales quantities along with the corresponding products (purchased), dates (i.e., dates of those minimum and maximum sales quantities) and the states in which the sale transactions took place. If there are >1 occurrences of the min or max, display all. For the same customer, compute the average sales quantity.
## **<ins> Code </ins>**
```sql 
WITH q1 AS (
	SELECT cust, min(quant) min_quant, max(quant) max_quant, avg(quant) avg_quant
	FROM sales
	GROUP BY cust
),
q2 AS (
	SELECT q1.cust Customer_Name, q1.min_quant Minimum_Quantity, s.prod Minimum_Product, s.state Minimum_State, s.date Minimum_Date
	FROM q1, sales s
	WHERE q1.cust = s.cust AND q1.min_quant = s.quant 
),
q3 AS (
	SELECT q1.cust Customer_Name, q1.max_quant Maximum_Quantity, s.prod Maximum_Product, s.state Maximum_State, s.date Maximum_Date
	FROM q1, sales s
	WHERE q1.cust = s.cust AND q1.max_quant = s.quant
)
	SELECT q2.Customer_Name as Customer, q2.Minimum_Quantity Min_Q, q2.Minimum_Product 	Min_Prod, q2.Minimum_Date Min_Date, q2.Minimum_State St, q3.Maximum_Quantity Max_Q, q3.Maximum_Product Max_Prod, q3.Maximum_Date Date, q3.Maximum_State St,
	q1.avg_quant Avg_Q
	FROM q1, q2, q3
	WHERE q1.cust = q2.Customer_Name AND q2.Customer_Name = q3.Customer_Name
	ORDER BY cust
```
## **<ins> Query 2 </ins>**
### For each year and month combination, find the “busiest” and the “slowest” day (those days with the most and the least total sales quantities of products sold) and the corresponding total sales quantities (i.e., SUMs).
## **<ins> Code </ins>**
```sql 
WITH q1 AS (
	SELECT year, month, day, sum(quant) sum_quant 
	FROM sales
	GROUP BY year, month, day
),
q2 AS(
	SELECT q1.year, q1.month, MAX(sum_quant) AS busiest_total_quant
	FROM q1
	GROUP BY year, month
),
q3 AS(
	SELECT q1.year, q1.month, MIN(sum_quant) AS slowest_total_quant
	FROM q1
	GROUP BY year, month
	),	
q4 AS(
	SELECT q1.year, q1.month, q1.day AS busiest_day, busiest_total_quant
	FROM q1, q2
	WHERE q1.year = q2.year AND q1.month = q2.month AND q1.sum_quant = q2.busiest_total_quant
	),
q5 AS(
	SELECT q1.year, q1.month, q1.day AS slowest_day, slowest_total_quant
	FROM q1, q3
	WHERE q1.year = q3.year AND q1.month = q3.month AND q1.sum_quant = q3.slowest_total_quant	
)
	SELECT q4.year, q4.month, q4.busiest_day, q4.busiest_total_quant busiest_total_q, q5.slowest_day, q5.slowest_total_quant slowest_total_q
	FROM q4, q5
	WHERE q4.year = q5.year AND q4.month = q5.month
	ORDER BY YEAR, MONTH
```
## **<ins> Query 3 </ins>**
### For each customer, find the “most favorite” product (the product that the customer purchased the most) and the “least favorite” product (the product that the customer purchased the least).
## **<ins> Code </ins>**
```sql
With Q1 as (
SELECT cust, prod, count(quant) count_quant
FROM sales
GROUP BY cust, prod
),

Q2 as (
SELECT Q1.cust, max(count_quant) most_fav_count, min(count_quant) least_fav_count
FROM Q1
GROUP BY cust
),

Q3 as (
SELECT Q1.cust, prod as most_fav_prod
FROM Q1, Q2
WHERE Q1.cust = Q2.cust AND Q1.count_quant = Q2.most_fav_count
),

Q4 as (
SELECT Q1.cust, prod as least_fav_prod
FROM Q1, Q2
WHERE Q1.cust = Q2.cust AND Q1.count_quant = Q2.least_fav_count
)

SELECT Q4.cust as customer, Q3.most_fav_prod, Q4.least_fav_prod
FROM Q3, Q4
WHERE Q3.cust = Q4.cust 
ORDER BY customer
```

## **<ins> Query 4 </ins>**
### For each customer and product combination, show the average sales quantities for the four seasons, Spring, Summer, Fall and Winter in four separate columns – Spring being the 3 months of March, April and May; and Summer the next 3 months (June, July and August); and so on – ignore the YEAR component of the dates (i.e., 10/25/2016 is considered the same date as 10/25/2017, etc.). Additionally, compute the average for the “whole” year (again ignoring the YEAR component, meaning simply compute AVG) along with the total quantities (SUM) and the counts (COUNT).
## **<ins> Code </ins>**
```sql
/* SPRING */
WITH q1 as (
	SELECT cust, prod, avg(quant) spring_avg
	FROM sales
	WHERE month in (3,4,5)
	GROUP BY cust, prod
),

/* SUMMER */
q2 as (
	SELECT cust, prod, avg(quant) summer_avg
	FROM sales
	WHERE month in (6,7,8)
	GROUP BY cust, prod	
),

/* FALL */
q3 AS (
	SELECT cust, prod, avg(quant) fall_avg
	FROM sales
	WHERE month in (9,10,11)
	GROUP BY cust, prod	
),
/* WINTER */
q4 AS (
	SELECT cust, prod, avg(quant) winter_avg
	FROM sales
	WHERE month in (12,1,2)
	GROUP BY cust, prod	
),
q5 AS (
	SELECT cust, prod, avg(quant) average_quantity, sum(quant) sum_quantity, count(quant) count_quantity
	FROM sales
	GROUP BY cust, prod	
)
	SELECT q1.cust as customer, q1.prod as product, q1.spring_avg, q2.summer_avg, q3.fall_avg, q4.winter_avg, q5.average_quantity average, q5.sum_quantity total, q5.count_quantity count
	FROM q1, q2, q3, q4, q5
	WHERE q1.cust = q2.cust AND q1.prod = q2.prod AND 
	q2.cust = q3.cust AND q2.prod = q3.prod AND
	q3.cust = q4.cust AND q3.prod = q4.prod AND
	q4.cust = q5.cust AND q4.prod = q5.prod
	ORDER BY customer
```

## **<ins> Query 5 </ins>**
### For each product, output the maximum sales quantities for each quarter in 4 separate columns. Like the first report, display the corresponding dates (i.e., dates of those corresponding maximum sales quantities). Ignore the YEAR component of the dates (i.e., 10/25/2016 is considered the same date as 10/25/2017, etc.). 
## **<ins> Code </ins>**
```sql
/*Quarter 1*/
With q1 as (
SELECT prod, max(quant) quant1_max
FROM sales
WHERE month in (1,2,3)
GROUP BY prod
),

q2 as (
SELECT q1.prod, q1.quant1_max, s.date quant1_max_date 
FROM sales s, q1  
WHERE q1.prod = s.prod AND q1.quant1_max = s.quant
AND s.month in (1,2,3)
),

/*Quarter 2*/
q3 as (
SELECT prod, max(quant) quant2_max
FROM sales
WHERE month in (4,5,6)
GROUP BY prod
),

q4 as (
SELECT q3.prod, q3.quant2_max, s.date quant2_max_date
FROM sales s, q3 
WHERE q3.prod = s.prod AND q3.quant2_max = s.quant
AND s.month in (4,5,6)
),

/*Quarter 3*/
q5 as (
SELECT prod, max(quant) quant3_max
FROM sales
WHERE month in (7,8,9)
GROUP BY prod
), 
q6 as (
SELECT q5.prod, q5.quant3_max, s.date quant3_max_date
FROM sales s, q5 
WHERE q5.prod = s.prod AND q5.quant3_max = s.quant
AND s.month in (7,8,9)
),

/*Quarter 4*/
q7 as (
SELECT prod, max(quant) quant4_max
FROM sales
WHERE month in (10,11,12)
GROUP BY prod
),

q8 as (
SELECT q7.prod, q7.quant4_max, s.date quant4_max_date
FROM sales s, q7
WHERE q7.prod = s.prod AND q7.quant4_max = s.quant
AND s.month in (10,11,12)
)


SELECT q1.prod, q1.quant1_max Q1_MAX, q2.quant1_max_date DATE,
q3.quant2_max Q2_MAX, q4.quant2_max_date DATE,
q5.quant3_max Q3_MAX, q6.quant3_max_date DATE,
q7.quant4_max Q4_MAX, q8.quant4_max_date DATE
FROM q1, q2, q3, q4, q5, q6, q7, q8
WHERE q1.prod = q2.prod AND q2.prod = q3.prod AND q3.prod = q4.prod 
AND q4.prod = q5.prod AND q5.prod = q6.prod AND q5.prod = q6.prod 
AND q6.prod = q7.prod AND q7.prod = q8.prod

ORDER BY prod 
```






