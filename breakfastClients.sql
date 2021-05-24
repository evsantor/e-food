SELECT user_id,
   COUNT(order_id) AS frequency,
   SUM(basket) AS monetary
FROM `bi-2019-test.ad_hoc.orders_jan2021`
GROUP BY user_id;

