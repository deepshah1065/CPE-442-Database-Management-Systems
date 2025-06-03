-- Deep Shah
-- 5/2/25
-- Professor Kim
-- CPE 442: Homework 2
-- I pledge my honor that I have abided by the Stevens Honor System. ~ Deep Shah
-- CWID: 20014228

/* Query 1 */
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

/*Query 2*/
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

/*Query 3 */
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

/* Query 4 */
With base_table as 
(
	SELECT distinct prod, quant
	FROM sales
),

q1 as 
(
	SELECT s1.prod Product, s1.quant Quant, count(s1.quant) as pos
	FROM base_table s1 JOIN sales s2
	ON s1.prod = s2.prod AND s2.quant <= s1.quant 
	GROUP BY s1.prod, s1.quant
),
q2 AS (
	SELECT prod as Product, ceiling(count(quant)/2) as median_pos
	FROM sales
	GROUP BY Product
),
q3 AS 
(
SELECT q1.Product Product, q1.Quant, q1.Pos, q2.Median_Pos
FROM q1 JOIN q2 
ON q1.Product = q2.Product 
WHERE q1.pos >= q2.median_pos
),
q4 AS 
(
SELECT q3.Product product, min(pos) as Median_Quant
FROM q3
GROUP BY Product
)
SELECT q4.product, q1.Quant Median_Quant
FROM q1, q4
WHERE q1.Product = q4.Product and q1.Pos = q4.Median_Quant
ORDER BY Product

