create table product
( product_id bigint primary key
	, product_name varchar
	, price decimal
);

create table shop
(shop_id bigint primary key
, shop_name varchar
);

create table plan
(product_id bigint references product(product_id)
, shop_id bigint references shop(shop_id)
, plan_cnt decimal
,plan_date date
);

create table shop_dns
( shop_id bigint references shop(shop_id)
, product_id bigint references product(product_id)
, date date
, sales_cnt bigint
);

create table shop_mvideo
( shop_id bigint references shop(shop_id)
, product_id bigint references product(product_id)
, date date
, sales_cnt bigint
);

create table shop_sitilink
( shop_id bigint references shop(shop_id)
, product_id bigint references product(product_id)
, date date
, sales_cnt bigint
);

create table promo
( promo_id bigint primary key
, product_id bigint references product(product_id)
, shop_id bigint references shop(shop_id)
, discount decimal
, promo_date date
);

create table mart
( plan_date date
, shop_name varchar
, product_name varchar
, sales_fact_cnt int
, plan_cnt int
, sales_fact_plan decimal
, income_fact decimal
, income_plan decimal
, income_fact_plan decimal
, avg_sales_date decimal
, max_sales int
, date_max_sales date
, date_max_sales_is_promo boolean
, promo_len int
, promo_sales_cnt int
, promo_sales_fact_cnt decimal
, promo_income decimal
, promo_income_fact decimal
);

---------------------------------------------------

insert into product (product_id, product_name, price)
values
(1, 'Испорченный телефон', 100.00),
(2, 'Сарафанное радио', 200.00),
(3, 'Патефон', 300.00);

insert into shop (shop_id, shop_name)
values
(1, 'dns'),
(2, 'mvideo'),
(3, 'sitilink');

insert into plan (product_id, shop_id, plan_cnt, plan_date)
values
(1, 1, 10, '2023-05-31'),
(2, 1, 15, '2023-05-31'),
(3, 1, 20, '2023-05-31'),
(1, 2, 10, '2023-05-31'),
(2, 2, 15, '2023-05-31'),
(3, 2, 20, '2023-05-31'),
(1, 3, 10, '2023-05-31'),
(2, 3, 15, '2023-05-31'),
(3, 3, 20, '2023-05-31'),
(1, 1, 10, '2023-04-30'),
(2, 1, 15, '2023-04-30'),
(3, 1, 20, '2023-04-30'),
(1, 2, 10, '2023-04-30'),
(2, 2, 15, '2023-04-30'),
(3, 2, 20, '2023-04-30'),
(1, 3, 10, '2023-04-30'),
(2, 3, 15, '2023-04-30'),
(3, 3, 20, '2023-04-30');

insert into shop_dns (shop_id, date, product_id, sales_cnt)
values
(1, '2023-05-08', 1, 9),
(1, '2023-05-28', 1, 5),
(1, '2023-05-21', 2, 5),
(1, '2023-05-29', 2, 9),
(1, '2023-05-12', 3, 9),
(1, '2023-05-31', 3, 8),
(1, '2023-04-08', 1, 5),
(1, '2023-04-28', 1, 5),
(1, '2023-04-21', 2, 5),
(1, '2023-04-29', 2, 9),
(1, '2023-04-12', 3, 9),
(1, '2023-04-20', 3, 9),
(1, '2023-04-30', 3, 8);

insert into shop_mvideo (shop_id, date, product_id, sales_cnt)
values
(2, '2023-05-08', 1, 5),
(2, '2023-05-28', 1, 5),
(2, '2023-05-21', 2, 5),
(2, '2023-05-12', 2, 9),
(2, '2023-05-12', 3, 9),
(2, '2023-05-31', 3, 7),
(2, '2023-04-08', 1, 5),
(2, '2023-04-28', 1, 5),
(2, '2023-04-21', 2, 5),
(2, '2023-04-29', 2, 9),
(2, '2023-04-12', 3, 9),
(2, '2023-04-20', 3, 9),
(2, '2023-04-30', 3, 7);

insert into shop_sitilink (shop_id, date, product_id, sales_cnt)
values
(3, '2023-05-08', 1, 5),
(3, '2023-05-12', 1, 6),
(3, '2023-05-21', 2, 5),
(3, '2023-05-23', 2, 9),
(3, '2023-05-12', 3, 10),
(3, '2023-05-31', 3, 9),
(3, '2023-04-08', 1, 5),
(3, '2023-04-28', 1, 5),
(3, '2023-04-21', 2, 5),
(3, '2023-04-29', 2, 9),
(3, '2023-04-12', 3, 9),
(3, '2023-04-20', 3, 9),
(3, '2023-04-08', 3, 10);

insert into promo (promo_id, product_id, shop_id, discount, promo_date)
values
(1, 1, 1, 10.00, '2023-05-08'),
(2, 1, 1, 5.00, '2023-05-20'),
(3, 1, 1, 15.00, '2023-05-12'),
(4, 2, 1, 15.00, '2023-05-12'),
(5, 2, 1, 7.00, '2023-05-04'),
(6, 2, 1, 5.00, '2023-05-18'),
(7, 3, 1, 20.00, '2023-05-12'),
(8, 3, 1, 4.00, '2023-05-04'),
(9, 3, 1, 5.00, '2023-05-18'),
(10, 1, 2, 10.00, '2023-05-08'),
(11, 1, 2, 5.00, '2023-05-20'),
(12, 1, 2, 15.00, '2023-05-12'),
(13, 2, 2, 15.00, '2023-05-12'),
(14, 2, 2, 7.00, '2023-05-04'),
(15, 2, 2, 5.00, '2023-05-18'),
(16, 3, 2, 20.00, '2023-05-12'),
(17, 3, 2, 4.00, '2023-05-04'),
(18, 3, 2, 5.00, '2023-05-18'),
(19, 2, 1, 10.00, '2023-05-08'),
(20, 2, 1, 5.00, '2023-05-20'),
(21, 2, 1, 15.00, '2023-05-12'),
(22, 2, 1, 15.00, '2023-05-12'),
(23, 2, 1, 7.00, '2023-05-04'),
(24, 2, 1, 5.00, '2023-05-18'),
(25, 2, 1, 20.00, '2023-05-12'),
(26, 2, 1, 4.00, '2023-05-04'),
(27, 2, 1, 5.00, '2023-05-18');

---------------------------------------------------

insert into mart
with	  sales as			(	select *
								from shop_dns
								union all
								select *
								from shop_mvideo
								union all
								select *
								from shop_sitilink
							)

		, sales_calc as	(	select		  shop_id
											, product_id
											, date_part('year', sl.date)	as year
											, date_part('month', sl.date)	as month
											, sum(sales_cnt)				as sales_fact_cnt
											, max(sales_cnt) 				as max_sales
											, max(date)
								from		sales sl
								group by	  shop_id
											, product_id
											, date_part('year', sl.date)
											, date_part('month', sl.date)
							)


		, promo_calc as			(	select		  p.shop_id
											, p.product_id
											, date_part('year',p.promo_date)	as year
											, date_part('month', p.promo_date)	as month
											, count(promo_date)					as promo_len
											, sum(sales_cnt)					as promo_sales_cnt
								from		promo p
								left join	sales as s on s.shop_id = p.shop_id
											and s.product_id = p.product_id
											and p.promo_date = s.date
								group by	  p.shop_id
											, p.product_id
											, date_part('year',p.promo_date)
											, date_part('month', p.promo_date)
							)

select		  plan_date
			, shop_name
			, product_name
			, sales_fact_cnt
			, plan_cnt
			, sales_fact_plan
			, income_fact
			, income_plan
			, income_fact/income_plan	as income_fact_plan
			, avg_sales_date
			, max_sales
			, date_max_sales
			,	CASE
					WHEN	(select distinct 1 from promo as p where p.promo_date = date_max_sales) = 1
					THEN	1
					ELSE	0
				END::bool						as date_max_sales_is_promo
			, promo_len
			, promo_sales_cnt
			, promo_sales_fact_cnt
			, promo_income
			, promo_income/income_fact	as promo_income_fact

from		(	select		  p.plan_date
							, sh.shop_name
							, pr.product_name
							, sf.sales_fact_cnt
							, p.plan_cnt
							, sf.sales_fact_cnt/p.plan_cnt							as sales_fact_plan
							, sf.sales_fact_cnt*pr.price							as income_fact
							, p.plan_cnt*pr.price									as income_plan
							, avg(sf.sales_fact_cnt/date_part('day', p.plan_date))	as avg_sales_date
							, sf.max_sales
							,	(	select	max(date)
									from	sales s
									where	s.sales_cnt = sf.max_sales
											and s.shop_id = sh.shop_id
											and s.product_id = pr.product_id
											and date_part('year', p.plan_date) = date_part('year', s.date)
											and date_part('month', p.plan_date) = date_part('month', s.date)
								)													as date_max_sales
							, coalesce(prm.promo_len, 0)							as promo_len
							, coalesce(prm.promo_sales_cnt, 0)						as promo_sales_cnt
							, coalesce(prm.promo_sales_cnt/sf.sales_fact_cnt, 0)	as promo_sales_fact_cnt
							, coalesce(prm.promo_sales_cnt*pr.price, 0)				as promo_income

				from		sales_calc as sf
				join		product as pr on sf.product_id = pr.product_id
				join		shop as sh on sf.shop_id = sh.shop_id
				join		plan as p on sh.shop_id = p.shop_id and p.product_id = pr.product_id
							and date_part('year', p.plan_date) = sf.year
							and date_part('month', p.plan_date) = sf.month
				left join	promo_calc as prm on pr.product_id = prm.product_id
							and sh.shop_id = prm.shop_id
							and sf.year = prm.year
							and sf.month = prm.month

				group by	  sh.shop_id
							, pr.product_id
							, sf.sales_fact_cnt
							, p.plan_date
							, p.plan_cnt
							, sf.max_sales
							, prm.promo_len
							, prm.promo_sales_cnt
			) as t

order by	  plan_date
			, shop_name
			, product_name;