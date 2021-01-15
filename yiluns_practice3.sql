-- START Q3
CREATE VIEW yiluns.style AS
SELECT *, (REPLACE(REPLACE(
		  REPLACE(
		  REPLACE(
		  (attributes::JSON ->> 'Ambience'), '''', '"'),'False', '"False"'), 'True', '"True"'),'None','"None"'))::JSON style
FROM businesses

SELECT COUNT(*) * 1.0 / (SELECT COUNT(*) FROM yiluns.style) AS percentage_casual
FROM yiluns.style
WHERE style ->> 'casual' = 'True';
-- END Q3

-- START Q4
CREATE VIEW yiluns.category AS
SELECT business_id, name, categories, string_to_array(categories, ', ') AS category_array
FROM businesses

CREATE OR REPLACE VIEW yiluns.shopping AS 
SELECT *
FROM (
SELECT name, business_id, unnest(category_array) AS category
FROM yiluns.category) shopping 
WHERE category = 'Shopping'

SELECT ys.name, AVG(stars) average_rating, COUNT(*) num_ratings
FROM yiluns.shopping ys
JOIN public.reviews pr ON ys.business_id = pr.business_id
GROUP BY ys.name 
ORDER BY 2 DESC
LIMIT 3;
-- END Q4

-- START Q5
SELECT *
FROM(
SELECT business_id, checkin_date, ROW_NUMBER() OVER(PARTITION BY business_id) checkin_number
FROM (
	SELECT business_id, unnest(date_array) AS checkin_date
	FROM (
		SELECT business_id, string_to_array(date, ', ') date_array
		FROM checkins) t1) date_parsed_table) filter_table
WHERE checkin_number = 100
ORDER BY business_id;
-- END Q5

-- START Q6
CREATE VIEW yiluns.user_friend AS (
SELECT user_id, unnest(friends_array) friend_id
FROM (
SELECT user_id, string_to_array(friends, ', ') friends_array, review_count
FROM users
WHERE review_count < 4) friends_array)

SELECT ysf.user_id, AVG(review_count)
FROM yiluns.user_friend ysf
JOIN users u ON u.user_id = ysf.friend_id
GROUP BY 1
ORDER BY 2 DESC;
-- END Q6

-- START Q8
SELECT f.name, COUNT(DISTINCT b.bookid)
FROM facilities f
JOIN bookings b USING(facid)
GROUP BY f.name
ORDER BY 2 DESC
LIMIT 5;
-- END Q8

-- START Q9
SELECT memid, firstname, surname, SUM(membercost) total_revenue
FROM members m
NATURAL JOIN bookings b 
NATURAL JOIN facilities f
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 3;
-- END Q9

-- START Q18
SELECT standard_amt_usd,
	   SUM(standard_amt_usd) OVER(ORDER BY occurred_at) running_total
FROM orders
-- END Q18

-- START Q20
SELECT DISTINCT r.*, COUNT(sr.name) OVER(PARTITION BY r.name) sales_reps
FROM region r
JOIN sales_reps sr ON r.id=sr.region_id;
-- END Q20

-- START Q21
SELECT standard_qty, DATE_TRUNC('month', occurred_at)::DATE,
	SUM(standard_qty) OVER(ORDER BY occurred_at)
FROM orders;
-- END Q21

-- START Q22
SELECT account_id, total_amt_usd, occurred_at,
	ROW_NUMBER() OVER(PARTITION BY account_id) AS big_order_number
FROM orders
WHERE total_amt_usd > 10000
-- END Q22

-- START Q26
SELECT id, account_id, total, 
	RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
-- END Q26


