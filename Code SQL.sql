# PARTIE A
# 1)
SELECT title, length
FROM film
WHERE length > 120 
ORDER BY length DESC;

# 2)
SELECT length, title
FROM film
WHERE 
length > (SELECT AVG (length) FROM film);

# 3)
SELECT 
      f.title,
      l.name AS language,
      c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON l.language_id = l.language_id

# 4)
SELECT 
     f.title,
     COUNT(r.rental_id) AS nombre_locations
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY nombre_locations DESC
LIMIT 5;

# 5)
SELECT
      f.title,
      SUM(p.amount) AS revenu_total
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY revenu_total DESC
LIMIT 5;

# 6)
CREATE OR REPLACE VIEW vip_clients AS
SELECT c.customer_id, c.first_name, c.last_name,SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > 100;

# 7)
INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Lina', 'Ibouchichene', NOW());
SELECT * FROM actor WHERE first_name = 'Lina' AND last_name = 'Ibouchichene';

DELETE FROM film_actor
WHERE actor_id = 211;
DELETE FROM actor
WHERE actor_id = 211;

# 8)
SELECT 
      c.first_name,
      c.last_name,
      SUM(p.amount) AS total_paye
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > (SELECT AVG(amount_total) 
FROM (SELECT SUM(amount) AS amount_total
FROM payment
GROUP BY customer_id ) AS moyennes);

#PARTIE B
# 1: CREATION BASE DE DONNEE

CREATE DATABASE RESUME_SHOP;
USE RESUME_SHOP;
CREATE TABLE customers ( 
customer_id INT AUTO_INCREMENT PRIMARY KEY,
 first_name VARCHAR(30),
 last_name VARCHAR(30),
 email VARCHAR(30)
 );  
SHOW tables

USE RESUME_SHOP; 
CREATE TABLE ORDERS( 
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT,
order_date DATE,
total int
 ); 
 Show tables

USE RESUME_SHOP; 
CREATE TABLE Products( 
product_id INT AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(90),
product_name VARCHAR(90),
unit_price float
 ); 
 Show tables
 
 
use RESUME_SHOP;
CREATE TABLE OrderItems ( 
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
product_id int,
quantity int
 );
SHOW TABLES;

INSERT INTO customers(first_name, last_name, email)
 VALUES ('Charles','Ducrocs', 'charlesducrocs@gmail.fr');
Select* from customers

INSERT INTO customers(first_name, last_name, email)
 VALUES ('Maissa','Decrac', 'maissadec@gmail.fr');
Select* from customers

INSERT INTO customers(first_name, last_name, email)
 VALUES ('Tony','Tang', 'tonytang@gmail.fr');
Select* from customers

INSERT INTO customers(first_name, last_name, email)
 VALUES ('Sana','Don Santos', 'sdonsantos@gmail.fr');
Select* from customers

INSERT INTO customers(first_name, last_name, email)
 VALUES ('Karl','dona', 'Kdona@gmail.fr');
Select*from customers

# Insertion d'éléments au sein d'autres variables (orders).

INSERT INTO orders (customer_id, order_date, total)
 VALUES (1, '2024-08-15', 860);
Select* from orders

INSERT INTO orders (customer_id, order_date, total)
 VALUES (2, '2024-06-12', 250);
Select* from orders

INSERT INTO orders (customer_id, order_date, total)
 VALUES (3,'2024-08-24', 720);
Select* from orders

INSERT INTO orders (customer_id, order_date, total)
 VALUES (4, '2024-12-26', 490);
Select* from orders

INSERT INTO orders (customer_id, order_date, total)
 VALUES (5,'2025-01-15', 388);
Select* from orders

#Insertion d'éléments supplémentaire ( table Products)

INSERT INTO products (category, product_name,unit_price)
VALUES ('Legume','courgette', 2.99);
Select* from products

INSERT INTO products (category, product_name,unit_price)
VALUES ('Biscuit','coockies', 2.50);
Select* from products


INSERT INTO products (category, product_name,unit_price)
VALUES ('Fruit','myrtille', 2.05);
Select* from products

INSERT INTO products (category, product_name,unit_price)
VALUES ('Legume','chou-fleur', 1.99);
Select* from products

INSERT INTO products (category, product_name,unit_price)
VALUES ('Fruit','kiwi', 1.05);
Select* from products

# Insertion d'éléments au sein d'autres variables (orderitems). 

INSERT INTO orderitems (order_id,product_id, quantity)
 VALUES ( 1 , 4, 450);
Select* from orderitems

INSERT INTO orderitems (order_id,product_id, quantity)
 VALUES ( 1 , 5, 170);
Select* from orderitems


INSERT INTO orderitems (order_id,product_id, quantity)
 VALUES ( 2 , 2, 650);
Select* from orderitems

INSERT INTO orderitems (order_id,product_id, quantity)
 VALUES ( 3 , 3, 990);
Select* from orderitems

INSERT INTO orderitems (order_id,product_id, quantity)
 VALUES ( 4 , 1, 870);
Select* from orderitems


# SECTION 2
# 3)  
 SELECT 
    orders.order_id,
    customers.first_name,
    customers.last_name,
    products.product_name,
    orderitems.quantity,
    orders.total
FROM (
    SELECT order_id, total
    FROM orders
    ORDER BY total DESC
    LIMIT 3
) AS top_orders
INNER JOIN 
orders ON top_orders.order_id = orders.order_id
INNER JOIN 
customers ON orders.customer_id = customers.customer_id
INNER JOIN 
orderitems ON orders.order_id = orderitems.order_id
INNER JOIN 
products ON orderitems.product_id = products.product_id
ORDER BY orders.total DESC;

#4) 

SELECT 
    c.first_name,
    c.last_name,
    DATE_FORMAT(o.order_date, '%m') AS mois,
    SUM(o.total) AS montant_total
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, DATE_FORMAT(o.order_date, '%m')
HAVING SUM(o.total) > 500;

# 5
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity * p.unit_price) AS total_revenue,
    SUM(oi.quantity) AS total_quantity
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 3;

#6)
CREATE VIEW HighValueOrders AS
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    o.total AS order_total,
    SUM(oi.quantity) AS total_products
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.total
HAVING o.total > 400;

#INDEX 
CREATE INDEX idx_orders_total ON Orders(total);
CREATE INDEX idx_orders_customer ON Orders(customer_id);



