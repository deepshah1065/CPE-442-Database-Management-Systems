# **<ins> Programming Assignment 1 </ins>**
## **<ins> Objective </ins>**
### In this assignment, you will express “complex” OLAP queries in SQL. The key point of the exercise is to observe the complexity of expressing the type of such queries despite the relatively simple ideas of the queries themselves. Your mission (in addition to writing the SQL queries) is to consider the reasons for the complexity of the expression of these queries.

## **<ins> Query 1 </ins>**
### **<ins> Question </ins>**
#### For each customer, compute the minimum and maximum sales quantities along with the corresponding products (purchased), dates (i.e., dates of those minimum and maximum sales quantities) and the states in which the sale transactions took place. If there are >1 occurrences of the min or max, display all. For the same customer, compute the average sales quantity.
### **Code**
<pre> ```sql WITH q1 AS ( SELECT cust, MIN(quant) AS min_quant, MAX(quant) AS max_quant, AVG(quant) AS avg_quant FROM sales GROUP BY cust ), q2 AS ( SELECT q1.cust AS Customer_Name, q1.min_quant AS Minimum_Quantity, s.prod AS Minimum_Product, s.state AS Minimum_State, s.date AS Minimum_Date FROM q1, sales s WHERE q1.cust = s.cust AND q1.min_quant = s.quant ), q3 AS ( SELECT q1.cust AS Customer_Name, q1.max_quant AS Maximum_Quantity, s.prod AS Maximum_Product, s.state AS Maximum_State, s.date AS Maximum_Date FROM q1, sales s WHERE q1.cust = s.cust AND q1.max_quant = s.quant ) SELECT q2.Customer_Name AS Customer, q2.Minimum_Quantity AS Min_Q, q2.Minimum_Product AS Min_Prod, q2.Minimum_Date AS Min_Date, q2.Minimum_State AS Min_St, q3.Maximum_Quantity AS Max_Q, q3.Maximum_Product AS Max_Prod, q3.Maximum_Date AS Max_Date, q3.Maximum_State AS Max_St, q1.avg_quant AS Avg_Q FROM q1, q2, q3 WHERE q1.cust = q2.Customer_Name AND q2.Customer_Name = q3.Customer_Name ORDER BY cust; ``` </pre>

