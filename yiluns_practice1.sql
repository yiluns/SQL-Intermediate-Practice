-- START Q1
SELECT CONCAT(e.firstname, ' ', e.lastname) employeename, o.orderid, orderdate,
	   CONCAT(c.companyname) customername
FROM employees e 
JOIN orders o ON e.employeeid = o.employeeid
JOIN customers c ON o.customerid = c.customerid
ORDER BY o.orderdate;
-- END Q1

-- START Q2
SELECT c.categoryname, p.supplierid, p.unitsinstock remainingunits
FROM products p
JOIN categories c ON c.categoryid = p.categoryid
WHERE p.discontinued = 0 AND p.unitsinstock = 0;
-- END Q2

-- START Q3
SELECT c.customerid, c.companyname, c.contactname, c.contacttitle
FROM customers c
JOIN orders o ON c.customerid = o.customerid
GROUP BY 1,2,3,4
HAVING COUNT(*) < 5;
-- END Q3

-- START Q4
SELECT c.categoryname, COUNT(*) number_of_products
FROM products p
JOIN categories c ON c.categoryid = p.categoryid
WHERE unitsinstock > 0 
GROUP BY 1;
-- END Q4

-- START Q5
SELECT COUNT(DISTINCT c.customerid) num_customers
FROM customers c
JOIN orders o ON o.customerid = c.customerid
JOIN order_details od ON od.orderid = o.orderid
JOIN products p ON p.productid = od.productid
JOIN categories ca ON ca.categoryid = p.categoryid
WHERE ca.categoryname = 'Seafood';
-- END Q5

-- START Q6
SELECT c.country, COUNT(DISTINCT c.customerid) nonactive_customers
FROM customers c
LEFT JOIN orders o ON c.customerid = o.customerid
WHERE o.orderid IS NULL
GROUP BY c.country;
-- END Q6

-- START Q7
SELECT e.employeeid, CONCAT(e.firstname, ' ', e.lastname) employeename, 
		SUM(od.unitprice * od.quantity) total_ordered_value
FROM employees e 
JOIN orders o ON e.employeeid = o.employeeid
JOIN order_details od ON od.orderid = o.orderid
WHERE e.title != 'Vice President, Sales'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 3;
-- END Q7

-- START Q8
SELECT c.companyname, COUNT(*) total_orders, 
(SELECT COUNT(*) FROM orders o2 
WHERE o2.customerid = c.customerid AND o2.shippeddate < o2.requireddate) on_time_orders
FROM customers c
JOIN orders o ON o.customerid = c.customerid
GROUP BY c.companyname, c.customerid
ORDER BY COUNT(*) DESC;
-- END Q8

-- START Q9
SELECT s.companyname, COUNT(DISTINCT o.orderid) shipped_orders
FROM shippers s
JOIN orders o ON s.shipperid = o.shipvia
GROUP BY s.companyname
ORDER BY 2
LIMIT 1;
-- END Q9

-- START Q10
SELECT CONCAT(e.firstname, ' ', e.lastname) employeename, COUNT(DISTINCT o.orderid) num_orders,
		CASE WHEN COUNT(DISTINCT o.orderid) >= 75 THEN 'High Performer'
			 WHEN COUNT(DISTINCT o.orderid) < 75 AND COUNT(DISTINCT o.orderid) >= 50 THEN 'Mid Tier'
			 ELSE 'Low Performer' END AS performance_rating
FROM employees e
JOIN orders o ON e.employeeid = o.employeeid
GROUP BY 1;
-- END Q10

-- START Q11
SELECT CONCAT(em.firstname, ' ', em.lastname) managername, nameem.count num_of_employees_managed
FROM (SELECT reportsto manager, COUNT(*)
FROM employees e
WHERE reportsto IS NOT NULL
GROUP BY reportsto) nameem
JOIN employees em ON nameem.manager = em.employeeid;
-- END Q11
