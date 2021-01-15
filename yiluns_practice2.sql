-- START Q1
SELECT u.user_id, AVG(r.stars) AS average_star_rating
FROM users u
JOIN reviews r USING(user_id)
GROUP BY 1
HAVING COUNT(*) > 2
ORDER BY 2 DESC
LIMIT 5;
-- END Q1

-- START Q2
SELECT unnest(catearray) category, SUM(review_count*stars)/SUM(review_count) weighted_average_stars,
 	   COUNT(DISTINCT business_id) num_businesses
FROM (
SELECT business_id, stars, review_count, categories, string_to_array(categories, ', ') catearray
FROM businesses) catearray
GROUP BY 1
HAVING COUNT(DISTINCT business_id) > 3
ORDER BY 2 DESC;
-- END Q2

-- START Q3
SELECT u.name username, b.name businessname, COUNT(DISTINCT t.date) tips_left, COUNT(DISTINCT r.review_id) reviews_left
FROM users u
JOIN tips t ON u.user_id=t.user_id
JOIN reviews r ON u.user_id=r.user_id AND t.business_id=r.business_id
JOIN businesses b ON r.business_id=b.business_id
GROUP BY 1, 2
ORDER BY 2;
-- END Q3

-- SELECT Q4
SELECT user_id, fans, username, text
FROM (
SELECT users5.user_id, fans, users5.name AS username, r.text, b.name busi_name
FROM (
SELECT user_id, name, fans
FROM users 
WHERE fans >= 5) users5
JOIN reviews r ON users5.user_id=r.user_id
JOIN businesses b ON r.business_id=b.business_id) burling
WHERE busi_name='Burlington Coat Factory';
-- END Q4

-- START Q5
SELECT with_withoutips.type_of_user, AVG(r.stars) avg_stars
FROM (SELECT u.user_id,
	  CASE WHEN COUNT(t.business_id) > 0
			THEN 'Users with tips' 
	  		ELSE 'Users without tips' END AS type_of_user
	  FROM users u 
	  LEFT JOIN tips t ON u.user_id = t.user_id
	  GROUP BY u.user_id) with_withoutips
JOIN reviews r USING(user_id)
GROUP BY 1;
-- END Q5

-- START Q6
SELECT COALESCE(attributes::JSON ->> 'BusinessAcceptsCreditCards', 'False') accepts_credit_cards,
  COALESCE(attributes::JSON ->> 'RestaurantsTakeOut', 'False') offers_takeout, AVG(stars) average_stars
FROM businesses b 
GROUP BY 1,2
ORDER BY 3 DESC
-- END Q6

-- START Q7
WITH contract AS (
SELECT e.contractprice, ROW_NUMBER() OVER (PARTITION BY e.entertainerid ORDER BY e.startdate) AS num
FROM engagements e),
	 order56 AS (
SELECT c.contractprice, CASE WHEN c.num <= 5 THEN 'First Five Engagements'
							 ELSE '6th and Beyond Engagements' END AS engagement_category
FROM contract c)
SELECT order56.engagement_category, AVG(order56.contractprice)
FROM order56
GROUP BY order56.engagement_category;
-- END Q7

-- START Q8
SELECT AVG(contractprice) avg_contract_price, 
       MAX(startdate) most_recent_start_date, 
	   COUNT(*) num_engagements
FROM (SELECT e.contractprice, e.startdate 
FROM engagements e
WHERE e.contractprice > (SELECT AVG(en.contractprice) FROM engagements en))cp;
-- END Q8

-- START Q9
SELECT m.gender, ms.stylename, COUNT(DISTINCT m.memberid) num_members
FROM entertainer_styles es
JOIN entertainer_members em ON es.entertainerid = em.entertainerid
JOIN members m ON em.memberid = m.memberid
JOIN musical_styles ms ON es.styleid = ms.styleid
GROUP BY 1,2
HAVING COUNT(DISTINCT m.memberid) > 4
ORDER BY 3 DESC;
-- END Q9
