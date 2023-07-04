CREATE TABLE mart
( plan_date Date
, shop_name String
, product_name String
, sales_fact_cnt Int32
, plan_cnt Int32
, sales_fact_plan Decimal32(2)
, income_fact Decimal32(2)
, income_plan Decimal32(2)
, income_fact_plan Decimal32(2)
, avg_sales_date Decimal32(2)
, max_sales Int32
, date_max_sales Date
, date_max_sales_is_promo Boolean
, promo_len Int32
, promo_sales_cnt Int32
, promo_sales_fact_cnt Decimal32(2)
, promo_income Decimal32(2)
, promo_income_fact Decimal32(2)
)
ENGINE = PostgreSQL('postgres', 'testdb', 'mart', 'postgres', 'postgres');