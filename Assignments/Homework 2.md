# <p align="center"><ins>Programming Assignment 2</ins></p>
## **<ins> Objective </ins>**
### You will continue with expressing report queries. As with the assignment #1, you will express the queries in standard SQL. The reports below are similar in nature with the reports from the assignment #1; however, there are two main differences between the two: (1) the new reports will require aggregation “outside” the groups (in assignment #1, all of the aggregates were computed for the rows within the groups); (2) some of the aggregates in the new reports will be computed based on other aggregates of the same reports – they are known as “dependent aggregates”.

## **<ins> Query 1 </ins>**
### For each product and month, count the number of sales transactions that were between the previous and the following month's average sales quantities. For January and December, you can display <NULL> or 0; alternatively, you can skip those months (those that do not have averages for the previous and/or following months).
## **<ins> Code </ins>**


## **<ins> Query 2 </ins>**
### For customer and product, show the average sales before, during and after eachquarter (e.g., for Q2, show average sales of Q1 and Q3. For “before” Q1 and “after” Q4, display <NULL>. The “YEAR” attribute is not considered for this query – for example, both Q1 of 2007 and Q1 of 2008 are considered Q1 regardless of the year.
## **<ins> Code </ins>**


## **<ins> Query 3 </ins>**
### For each customer, product and state combination, compute (1) the product’s average sale of this customer for the state (i.e., the simple AVG for the group-by attributes – this is the easy part), (2) the average sale of the product and the state but for all of the other customers and (3) the customer’s average sale for the given state, but for all of the other products.
## **<ins> Code </ins>**


## **<ins> Query 4 </ins>**
### For each product, find the median sales quantity (assume an odd number of sales for simplicity of presentation). (NOTE – “median” is defined as “denoting or relating to a value or quantity lying at the midpoint of a frequency distribution of observed values or quantities, such that there is an equal probability of falling above or below it.” E.g., Median value of the list {13, 23, 12, 16, 15, 9, 29} is 15.
## **<ins> Code </ins>**
