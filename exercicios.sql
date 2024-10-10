2)
SELECT order_id, order_date,customer_id
FROM orders
WHERE customer_id = 'ALFKI';

3)
SELECT COUNT(order_id)
FROM orders;

4)
SELECT OD.order_id, P.product_name, OD.quantity, OD.unit_price
FROM  order_details OD
JOIN products P ON OD.product_id = P.product_id
OU
SELECT O.order_id, P.product_name, OD.quantity, OD.unit_price
FROM  order_details OD
JOIN products P ON OD.product_id = P.product_id
JOIN orders O ON OD.order_id = O.order_id

5)
SELECT order_id, SUM(unit_price * quantity) AS valor_total
FROM order_details
GROUP BY order_id;

6)
SELECT P.product_name, SUM(OD.unit_price * OD.quantity) AS valor_total
FROM order_details OD
JOIN products P ON OD.product_id = P.product_id
GROUP BY P.product_name
ORDER BY valor_total DESC
LIMIT 5;

7)
SELECT E.last_name, COUNT(O.order_id) AS quantidade_pedidos
FROM orders O
JOIN employees E ON O.employee_id = E.employee_id
GROUP BY E.last_name
ORDER BY quantidade_pedidos DESC
LIMIT 3;

8)
SELECT P.product_name, S.company_name
FROM products P
JOIN suppliers S ON P.supplier_id = S.supplier_id
GROUP BY S.company_name,P.product_name
ORDER BY S.company_name;

12)
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 1;

13)
SELECT order_id, COUNT(product_id) AS quantidade_produtos
FROM order_details
GROUP BY order_id
HAVING COUNT(product_id) > 5

14)
SELECT P.product_name, AVG(OD.unit_price * OD.quantity) AS venda_media
FROM order_details OD
JOIN products P ON OD.product_id = P.product_id
GROUP BY P.product_name
ORDER BY P.product_name

15)
SELECT S.company_name, P.product_name
FROM products P
JOIN suppliers S ON P.supplier_id = S.supplier_id
GROUP BY S.company_name,P.product_name,P.category_id
HAVING(P.category_id) = 3;