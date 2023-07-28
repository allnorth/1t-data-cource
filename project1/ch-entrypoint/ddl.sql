CREATE TABLE client_data
( client_id Int32
, gender text
, age_category text
, email text
, most_bought_product text
, most_bought_brand text
, cnt_order int
)
ENGINE = PostgreSQL('postgres', 'testdb', 'client_data', 'postgres', 'postgres', 'mart');