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

-------------- UTILIZANDO WINDOW FUNCTION--------------------------------- UTILIZANDO WINDOW FUNCTION-------------------

1)Calcular a quantide total de vendas por funcionario

SELECT DISTINCT
	E.last_name, 
	SUM(OD.quantity * OD.unit_price) OVER (PARTITION BY E.employee_id) AS vendas_total_por_funcionario
FROM orders O
JOIN order_details OD ON O.order_id = OD.order_id
JOIN employees E ON O.employee_id = E.employee_id
ORDER BY vendas_total_por_funcionario DESC;

2) Calcular a quantide total de vendas por funcionario e fazer o ranking de quem vendeu mais.

WITH vendas_funcionarios AS (

	SELECT DISTINCT
		E.last_name, 
		SUM(OD.quantity * OD.unit_price) OVER (PARTITION BY E.employee_id) AS vendas_total_por_funcionario
	FROM orders O
	JOIN order_details OD ON O.order_id = OD.order_id
	JOIN employees E ON O.employee_id = E.employee_id
)

SELECT
	last_name, 
	vendas_total_por_funcionario,
	RANK() OVER (ORDER BY vendas_total_por_funcionario DESC) AS ranking_por_funcionario
FROM vendas_funcionarios
ORDER BY vendas_total_por_funcionario DESC;

3) Média do valor do frete por país 

SELECT DISTINCT
	ship_country,
	AVG(freight) OVER (PARTITION BY ship_country) AS total_frete_por_pais

FROM orders
ORDER BY ship_country;

4)Quantos produtos únicos existem? Quantos produtos no total? Qual é o valor total pago?

SELECT DISTINCT
	order_id,
	COUNT(order_id) OVER (PARTITION BY order_id) AS quantidade_produtos_unicos,
	SUM(quantity) OVER (PARTITION BY order_id ) AS quantidade_total_produtos,
	SUM(unit_price * quantity) OVER (PARTITION BY order_id ) AS valor_total
		
FROM order_details
ORDER BY order_id;

5)Quais são os valores mínimo, máximo e médio de frete pago por cada cliente? (tabela orders)

SELECT DISTINCT

	customer_id,
	MIN(freight) OVER (PARTITION BY customer_id) AS valor_minimo_cliente,
	AVG(freight) OVER (PARTITION BY customer_id) AS valor_médio_cliente,
	MAX(freight) OVER (PARTITION BY customer_id) AS valor_máximo_cliente
	
FROM orders
ORDER BY customer_id;

6)Classificação (ranking) dos produtos com maior valor de venda POR order ID

SELECT
	OD.order_id,
	P.product_name,
	(OD.unit_price * OD.quantity) AS total_de_vendas,
	ROW_NUMBER () OVER (ORDER BY(OD.unit_price * OD.quantity) DESC ) AS order_row_number,
	RANK () OVER (ORDER BY(OD.unit_price * OD.quantity)DESC ) AS order_rank,
	DENSE_RANK () OVER (ORDER BY(OD.unit_price * OD.quantity)DESC ) AS order_dense_rank

FROM order_details OD
JOIN products P ON OD.product_id = P.product_id;

7)Ordenando os custos de envio pagos pelos clientes de acordo com suas datas de pedido

SELECT 
	O.customer_id,
	S.company_name,
	O.order_date,
	LAG(freight) OVER (PARTITION BY customer_id ORDER BY O.order_date ASC) AS valor_frete_anterior,
	freight AS valor_frete_atual,
	LEAD(freight) OVER (PARTITION BY customer_id ORDER BY O.order_date ASC) AS valor_frete_posterior
	
FROM 
	orders O
JOIN 
	shippers S ON O.ship_via = S.shipper_id
ORDER BY 
	O.customer_id;