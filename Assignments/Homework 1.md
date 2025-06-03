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
	SELECT q2.Customer_Name as Customer, q2.Minimum_Quantity Min_Q, q2.Minimum_Product Min_Prod, q2.Minimum_Date Min_Date, q2.Minimum_State St,
	q3.Maximum_Quantity Max_Q, q3.Maximum_Product Max_Prod, q3.Maximum_Date Date, q3.Maximum_State St,
	q1.avg_quant Avg_Q
	FROM q1, q2, q3
	WHERE q1.cust = q2.Customer_Name AND q2.Customer_Name = q3.Customer_Name
	ORDER BY cust;
### **<ins> Code </ins>**
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
	SELECT q2.Customer_Name as Customer, q2.Minimum_Quantity Min_Q, q2.Minimum_Product Min_Prod, q2.Minimum_Date Min_Date, q2.Minimum_State St,
	q3.Maximum_Quantity Max_Q, q3.Maximum_Product Max_Prod, q3.Maximum_Date Date, q3.Maximum_State St,
	q1.avg_quant Avg_Q
	FROM q1, q2, q3
	WHERE q1.cust = q2.Customer_Name AND q2.Customer_Name = q3.Customer_Name
	ORDER BY cust

## **<ins> Query 1 </ins>**
### For each customer, compute the minimum and maximum sales quantities along with the corresponding products (purchased), dates (i.e., dates of those minimum and maximum sales quantities) and the states in which the sale transactions took place. If there are >1 occurrences of the min or max, display all. For the same customer, compute the average sales quantity.
## **<ins> Code </ins>**
```sql 




