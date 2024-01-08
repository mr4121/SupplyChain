use supply_db ;


Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.



use supply_db ;
 
SELECT
Product_Name, Product_Id
FROM
(
SELECT
prod_info.Product_Name , prod_info.Product_Id
FROM
product_info AS prod_info
LEFT JOIN
category AS cat
ON prod_info.Category_Id =cat.Id
WHERE
LOWER(cat.Name) LIKE '%golf%'
ORDER BY Product_id 
) as summary;
 

-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/

use supply_db ;

SELECT
Product_Name,
Sales
FROM
(
SELECT
prod_info.Product_Name,
SUM(Sales) AS Sales,
RANK() OVER(ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM
orders AS ord
LEFT JOIN
ordered_items AS ord_itm
ON ord.Order_Id = ord_itm.Order_Id
LEFT JOIN
product_info AS prod_info
ON ord_itm.Item_Id=prod_info.Product_Id
LEFT JOIN
category AS cat
ON prod_info.Category_Id =cat.Id
WHERE
LOWER(cat.Name) LIKE '%golf%'
GROUP BY 1
ORDER BY 2 DESC
) AS summary
WHERE Sales_Rank<=10;


/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

use supply_db ;

SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
LEFT JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
GROUP BY 1
order by Orders desc
;
 

/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

use supply_db ;


WITH Seg_Orders AS
(
SELECT
cust.Segment AS customer_segment,
COUNT(ord.Order_Id) AS Orders
FROM
orders AS ord
LEFT JOIN
customer_info AS cust
ON ord.Customer_Id = cust.Id
WHERE Real_Shipping_Days=6
GROUP BY 1
)
SELECT
a.customer_segment,
ROUND(a.Orders/SUM(b.Orders)*100,1) AS percentage_order_split
FROM
Seg_Orders AS a
JOIN
Seg_Orders AS b
GROUP BY 1
ORDER BY 2 DESC;

