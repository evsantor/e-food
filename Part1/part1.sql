WITH orders_cities_subset AS (
   SELECT *
   FROM `bi-2019-test.ad_hoc.orders_jan2021`
   WHERE city IN (
       SELECT city
       FROM `bi-2019-test.ad_hoc.orders_jan2021`
       GROUP BY city
       HAVING COUNT(order_id) > 500
   )
),
orders_breakfast_cities_subset AS (
   SELECT *
   FROM orders_cities_subset
   WHERE user_id IN (
       SELECT DISTINCT user_id
       FROM orders_cities_subset
       WHERE cuisine_parent = 'Breakfast'
   )
),
breakfast_orders_users_count AS (
   SELECT city,
           COUNT(order_id) AS breakfast_orders,
           COUNT(DISTINCT user_id) AS breakfast_users
   FROM orders_breakfast_cities_subset
   WHERE cuisine_parent = 'Breakfast'
   GROUP BY city
),
avg_basket_table AS (
   SELECT city, AVG(basket) AS avg_basket
   FROM orders_breakfast_cities_subset
   GROUP BY city
)
SELECT BOUC.city, breakfast_orders, breakfast_users, avg_basket
FROM breakfast_orders_users_count AS BOUC INNER JOIN avg_basket_table
   ON BOUC.city = avg_basket_table.city
ORDER BY breakfast_orders DESC LIMIT 10;

