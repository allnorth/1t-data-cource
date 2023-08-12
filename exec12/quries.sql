CREATE TABLE products
( product_id serial primary key NOT NULL
, product_name varchar NOT NULL
, price decimal NOT NULL
)
DISTRIBUTED BY (product_id);

CREATE TABLE sale_facts
( date_id int8 NOT NULL
, product_id int8 NULL references products(product_id)
, amount int8 NULL
)
DISTRIBUTED BY (date_id);

CREATE TABLE dates
( date_id serial not null
, date timestamp not null
, year int8 not null
, month int8 not null
, day int8 not null
)
DISTRIBUTED BY (date_id);

INSERT INTO products (product_name, price)
VALUES
('pr1', 100),
('pr2', 110),
('pr3', 120),
('pr3', 130),
('pr4', 140),
('pr5', 150);

INSERT INTO dates (date, year, month, day)
SELECT '2023-01-02'::timestamp, date_part('year', '2023-01-02'::timestamp),date_part('month', '2023-01-02'::timestamp), date_part('day', '2023-01-02'::timestamp) union all
SELECT '2023-02-01'::timestamp, date_part('year', '2023-02-01'::timestamp),date_part('month', '2023-02-01'::timestamp), date_part('day', '2023-02-01'::timestamp) union all
SELECT '2023-04-09'::timestamp, date_part('year', '2023-04-09'::timestamp),date_part('month', '2023-04-09'::timestamp), date_part('day', '2023-04-09'::timestamp);


INSERT INTO sale_facts (date_id, product_id, amount)
VALUES
(1, 1, 2),
(1, 2, 1),
(1, 3, 3),
(2, 2, 4),
(2, 2, 5),
(2, 3, 1),
(3, 1, 1),
(3, 2, 2),
(1, 1, 2),
(1, 2, 1),
(1, 3, 3),
(2, 2, 4),
(2, 2, 5),
(2, 3, 1),
(3, 1, 1),
(3, 2, 2);

EXPLAIN ANALYZE
SELECT p.product_name, sum(sf.amount)
FROM sale_facts sf
JOIN dates d ON sf.date_id = d.date_id
JOIN products p ON sf.product_id = p.product_id
WHERE product_name = 'pr2' AND date = '2023-02-01'::timestamp
GROUP BY p.product_name;