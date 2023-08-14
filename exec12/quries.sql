CREATE TABLE products
( product_id serial primary key NOT NULL
, product_name varchar NOT NULL
, price decimal NOT NULL
)
DISTRIBUTED BY (product_id);

CREATE TABLE sale_facts
( sale_id serial NOT NULL
, product_id int8 NULL references products(product_id)
, amount int8 NULL
, date timestamp NOT NULL
)
DISTRIBUTED BY (sale_id)
PARTITION BY RANGE (date)
( START (date '2023-01-01') INCLUSIVE
   END (date '2024-01-01') EXCLUSIVE
   EVERY (INTERVAL '1 month') );

INSERT INTO products (product_name, price)
VALUES
('pr1', 100),
('pr2', 110),
('pr3', 120),
('pr3', 130),
('pr4', 140),
('pr5', 150);

INSERT INTO sale_facts (product_id, amount, date)
VALUES
(1, 1, '2023-01-02'),
(3, 2, '2023-01-02'),
(1, 3, '2023-01-03'),
(5, 2, '2023-02-02'),
(2, 2, '2023-03-03'),
(3, 3, '2023-03-01'),
(4, 1, '2023-04-04'),
(3, 2, '2023-04-20'),
(5, 1, '2023-05-02'),
(1, 2, '2023-05-12'),
(5, 3, '2023-05-21'),
(2, 2, '2023-06-01'),
(4, 2, '2023-06-09'),
(2, 3, '2023-07-02'),
(2, 1, '2023-07-05'),
(3, 2, '2023-08-02');

EXPLAIN ANALYZE
SELECT p.product_name, sum(sf.amount)
FROM sale_facts sf
JOIN products p ON sf.product_id = p.product_id
WHERE product_name = 'pr2' AND date = '2023-02-01'::timestamp
GROUP BY p.product_name;