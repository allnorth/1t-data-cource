CREATE TABLE IF NOT EXISTS product
( product_id Int32
, product_name String
, price Decimal32(2)
)
ENGINE = MergeTree()
PRIMARY KEY(product_id);

CREATE TABLE IF NOT EXISTS shop
( shop_id Int32
, shop_name String
)
ENGINE = MergeTree()
PRIMARY KEY(shop_id);

CREATE TABLE IF NOT EXISTS plan
( product_id Int32
, shop_id Int32
, plan_cnt Int32
, plan_date Date
)
ENGINE = MergeTree()
ORDER BY product_id;

CREATE TABLE IF NOT EXISTS shop_dns
( shop_id Int32
, product_id Int32
, date Date
, sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY product_id;

CREATE TABLE IF NOT EXISTS shop_mvideo
( shop_id Int32
, product_id Int32
, date Date
, sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY product_id;

CREATE TABLE IF NOT EXISTS shop_sitilink
( shop_id Int32
, product_id Int32
, date Date
, sales_cnt Int32
)
ENGINE = MergeTree()
ORDER BY product_id;

---------------------------------------------------

INSERT INTO product
VALUES
(1, 'Испорченный телефон', 100.00),
(2, 'Сарафанное радио', 200.00),
(3, 'Патефон', 300.00);

INSERT INTO shop
VALUES
(1, 'dns'),
(2, 'mvideo'),
(3, 'sitilink');

INSERT INTO plan
VALUES
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

INSERT INTO shop_dns
VALUES
(1, 1, '2023-05-08', 9),
(1, 1, '2023-05-28', 5),
(1, 2, '2023-05-21', 5),
(1, 2, '2023-05-29', 9),
(1, 3, '2023-05-12', 9),
(1, 3, '2023-05-31', 8),
(1, 1, '2023-04-08', 5),
(1, 1, '2023-04-28', 5),
(1, 2, '2023-04-21', 5),
(1, 2, '2023-04-29', 9),
(1, 3, '2023-04-12', 9),
(1, 3, '2023-04-20', 9),
(1, 3, '2023-04-30', 8);

INSERT INTO shop_mvideo
VALUES
(2, 1, '2023-05-08', 5),
(2, 1, '2023-05-28', 5),
(2, 2, '2023-05-21', 5),
(2, 2, '2023-05-12', 9),
(2, 3, '2023-05-12', 9),
(2, 3, '2023-05-31', 7),
(2, 1, '2023-04-08', 5),
(2, 1, '2023-04-28', 5),
(2, 2, '2023-04-21', 5),
(2, 2, '2023-04-29', 9),
(2, 3, '2023-04-12', 9),
(2, 3, '2023-04-20', 9),
(2, 3, '2023-04-30', 7);

INSERT INTO shop_sitilink
VALUES
(3, 1, '2023-05-08', 5),
(3, 1, '2023-05-12', 6),
(3, 2, '2023-05-21', 5),
(3, 2, '2023-05-23', 9),
(3, 3, '2023-05-12', 10),
(3, 3, '2023-05-31', 9),
(3, 1, '2023-04-08', 5),
(3, 1, '2023-04-28', 5),
(3, 2, '2023-04-21', 5),
(3, 2, '2023-04-29', 9),
(3, 3, '2023-04-12', 9),
(3, 3, '2023-04-20', 9),
(3, 3, '2023-04-08', 10);

---------------------------------------------------

with sales as (select *
               from shop_dns
               union all
               select *
               from shop_mvideo
               union all
               select *
               from shop_sitilink)

   , sales_calc as (select shop_id
                         , product_id
                         , toYear(sl.date)  as year
                         , toMonth(sl.date) as month
                         , sum(sales_cnt)   as sales_fact_cnt
                         , max(sales_cnt)   as max_sales
                         , max(date)
                    from sales sl
                    group by shop_id
                           , product_id
                           , toYear(sl.date)
                           , toMonth(sl.date))

select p.plan_date                                          as plan_date
           , sh.shop_name                                         as shop_name
           , pr.product_name                                      as product_name
           , sf.sales_fact_cnt                                    as sales_fact_cnt
           , p.plan_cnt                                           as plan_cnt
           , sf.sales_fact_cnt / p.plan_cnt                       as sales_fact_plan
           , sf.sales_fact_cnt * pr.price                         as income_fact
           , p.plan_cnt * pr.price                                as income_plan
           , sf.sales_fact_cnt * pr.price / p.plan_cnt * pr.price as income_fact_plan

      from sales_calc as sf
      join product as pr on sf.product_id = pr.product_id
      join shop as sh on sf.shop_id = sh.shop_id
      join plan as p on sh.shop_id = p.shop_id
          and p.product_id = pr.product_id
          and toYear(p.plan_date) = sf.year
          and toMonth(p.plan_date) = sf.month
      left join (select s.shop_id
                      , s.product_id
                      , s.sales_cnt
                      , toYear(s.date)  as year
                      , toMonth(s.date) as month
                      , max(date)       as date_max_sales
                 from sales s
                 group by s.shop_id
                        , s.product_id
                        , s.sales_cnt
                        , toYear(s.date)
                        , toMonth(s.date)
      ) as md on md.sales_cnt = sf.max_sales
          and md.shop_id = sh.shop_id
          and md.product_id = pr.product_id
          and toYear(p.plan_date) = md.year
          and toMonth(p.plan_date) = md.month

      group by sh.shop_name
             , pr.product_name
             , sf.sales_fact_cnt
             , p.plan_date
             , p.plan_cnt
             , sf.max_sales
             , pr.price

order by p.plan_date
       , sh.shop_name
       , pr.product_name;