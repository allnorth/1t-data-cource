INSERT INTO stage."order" (order_id, order_date, product_id, product_name, price, brand, model, category, buyer_cookie, amount)
VALUES
  (1, '2023-07-07', 1, 'pr1', 100, 'br1', 'md1', 'cat1', 'cookie1', 10)
, (2, '2023-07-07', 1, 'pr1', 100, 'br1', 'md1', 'cat1', 'cookie2', 8)
, (3, '2023-07-07', 2, 'pr2', 200, 'br2', 'md2', 'cat2', 'cookie1', 13)
, (4, '2023-07-07', 3, 'pr3', 300, 'br3', 'md3', 'cat3', 'cookie2', 21)
, (5, '2023-07-07', 4, 'pr4', 400, 'br4', 'md4', 'cat4', 'cookie3', 3);

INSERT INTO stage.client (client_id, buyer_cookie, full_name, gender, birth_date, email, phone)
VALUES
  (1, 'cookie1', 'fn1', 'm', '1991-01-01', 'em1@mail.com', '84951234561')
, (2, 'cookie2', 'fn2', 'w', '1992-01-01', 'em2@mail.com', '84951234562')
, (3, 'cookie3', 'fn3', 'm', '1993-01-01', 'em3@mail.com', '84951234563');

INSERT INTO core.hub_order (external_id, record_source, load_date)
SELECT DISTINCT order_id, 'source', now()
FROM stage."order";

INSERT INTO core.hub_product (external_id, record_source, load_date)
SELECT DISTINCT product_id, 'source', now()
FROM stage."order";

INSERT INTO core.hub_client (external_id, record_source, load_date)
SELECT DISTINCT client_id, 'source', now()
FROM stage.client;

INSERT INTO core.hub_date (external_id, record_source, load_date)
SELECT DISTINCT to_char(order_date, 'YYYYMMDD')::integer, 'source', now()
FROM stage."order";

INSERT INTO core.sat_order (order_key, record_source, load_date, amount, created_at, updated_at, deleted_at)
SELECT DISTINCT ho.order_key, ho.record_source, ho.load_date, amount, now(), null::timestamp, null::timestamp
FROM core.hub_order ho
JOIN stage.order so on so.order_id = ho.external_id;

INSERT INTO core.sat_product (product_key, record_source, load_date, product_name, brand, model, category, created_at, updated_at, deleted_at)
SELECT DISTINCT hp.product_key, hp.record_source, hp.load_date, so.product_name, so.brand, so.model, so.category, now(), null::timestamp, null::timestamp
FROM core.hub_product hp
JOIN stage.order so on so.product_id = hp.external_id;

INSERT INTO core.sat_client (client_key, record_source, load_date, buyer_cookie, full_name, gender, birth_date, email, phone, created_at, updated_at, deleted_at)
SELECT DISTINCT hc.client_key, hc.record_source, hc.load_date, sc.buyer_cookie, sc.full_name, sc.gender, sc.birth_date, sc.email, sc.phone, now(), null::timestamp, null::timestamp
FROM core.hub_client hc
JOIN stage.client sc ON sc.client_id = hc.external_id;

INSERT INTO core.sat_date (date_key, record_source, load_date, date, week, month, year, created_at, updated_at, deleted_at)
SELECT DISTINCT date_key, record_source, load_date, order_date, extract(week from order_date), extract(month from order_date), extract(year from order_date), now(), null::timestamp, null::timestamp
FROM core.hub_date hd
JOIN stage."order" so ON to_char(order_date, 'YYYYMMDD')::integer = hd.external_id;

INSERT INTO core.link_order_client (load_date, order_key, client_key, date_from, date_to)
SELECT now(), ho.order_key, hc.client_key, now(), null::timestamp
FROM core.hub_order ho
JOIN stage."order" so on so.order_id = ho.external_id
JOIN stage.client sc on sc.buyer_cookie = so.buyer_cookie
JOIN core.hub_client hc ON hc.external_id = sc.client_id;

INSERT INTO core.link_order_product (load_date, order_key, product_key, date_from, date_to)
SELECT now(), ho.order_key, hp.product_key, now(), null::timestamp
FROM core.hub_order ho
JOIN stage."order" so ON so.order_id = ho.external_id
JOIN core.hub_product hp ON hp.external_id = so.product_id;

INSERT INTO core.link_order_date (load_date, order_key, date_key, date_from, date_to)
SELECT now(), order_key, date_key, now(), null::timestamp FROM core.hub_order ho
JOIN stage."order" so ON so.order_id = ho.external_id
JOIN core.hub_date hd ON hd.external_id = to_char(so.order_date, 'YYYYMMDD')::integer;

INSERT INTO mart.client_data (client_id, gender, age_category, email, phone, most_bought_product, most_bought_brand, cnt_order)
WITH tbl AS (	select loc.client_key, sp.product_name, sp.brand, sum(so.amount) as sum
				from core.link_order_product lop
				join core.link_order_client loc on loc.order_key = lop.order_key
				join core.sat_order so on so.order_key = lop.order_key
				join core.sat_product sp on sp.product_key = lop.product_key
				group by	loc.client_key,
							sp.product_name,
							sp.brand
				order by sum desc)

SELECT tt.client_id
		, tt.gender
		,	CASE
				WHEN date_part('year',age(tt.birth_date)) < 16
				THEN 'child'
				WHEN date_part('year',age(tt.birth_date)) between 16 and 60
				THEN 'adult'
				WHEN date_part('year',age(tt.birth_date)) > 60
				THEN 'old'
			END AS age_category
		, tt.email
		, tt.phone
		, tt.most_bought_product
		, tt.most_bought_brand
		, tt.cnt_order

FROM (	SELECT	  hc.external_id AS client_id
				, sc.gender
				, sc.birth_date
				, sc.email
				, sc.phone
				, t.product_name as most_bought_product
				, t.brand as most_bought_brand
				, count(loc.order_key) as cnt_order

		FROM core.hub_client hc
		JOIN core.sat_client sc ON sc.client_key = hc.client_key
		JOIN core.link_order_client loc on hc.client_key = loc.client_key
		JOIN core.link_order_product lop on loc.order_key = lop.order_key
		JOIN core.sat_product sp ON sp.product_key = lop.product_key
		JOIN LATERAL (SELECT product_name, brand FROM tbl WHERE tbl.client_key = hc.client_key limit 1) as t ON true

		GROUP BY hc.external_id
				, sc.gender
				, sc.birth_date
				, sc.email
				, sc.phone
				, t.product_name
				, t.brand
		) as tt;