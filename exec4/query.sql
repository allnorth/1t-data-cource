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
				END						as date_max_sales_is_promo
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