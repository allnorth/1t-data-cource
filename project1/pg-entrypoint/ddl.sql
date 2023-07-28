CREATE SCHEMA stage;

CREATE TABLE stage.order
( order_id int
, order_date date
, product_id int
, product_name varchar
, price decimal
, brand varchar
, model varchar
, category varchar
, buyer_cookie varchar
, amount int
);

CREATE TABLE stage.client
( client_id int
, buyer_cookie varchar
, full_name varchar
, gender varchar
, birth_date date
, email varchar
, phone varchar
);

CREATE TABLE stage.promo
( promo_id int
, product_name varchar
, date_from date
, date_to date
, amount decimal
);

CREATE SCHEMA core;

CREATE TABLE core.hub_order
( order_key serial primary key
, external_id int
, record_source varchar
, load_date timestamp
);

CREATE TABLE core.sat_order
( order_key int primary key references core.hub_order(order_key)
, record_source varchar
, load_date timestamp
, amount int
, created_at timestamp
, updated_at timestamp
, deleted_at timestamp
);

CREATE TABLE core.hub_product
( product_key serial primary key
, external_id int
, record_source varchar
, load_date timestamp
);

CREATE TABLE core.sat_product
( product_key int primary key references core.hub_product(product_key)
, record_source varchar
, load_date timestamp
, product_name varchar
, brand varchar
, model varchar
, category varchar
, created_at timestamp
, updated_at timestamp
, deleted_at timestamp
);

CREATE TABLE core.hub_client
( client_key serial primary key
, external_id int
, record_source varchar
, load_date timestamp
);

CREATE TABLE core.sat_client
( client_key int primary key references core.hub_client(client_key)
, record_source varchar
, load_date timestamp
, buyer_cookie varchar
, full_name varchar
, gender varchar
, birth_date date
, email varchar
, phone varchar
, created_at timestamp
, updated_at timestamp
, deleted_at timestamp
);

CREATE TABLE core.hub_date
( date_key serial primary key
, external_id int
, record_source varchar
, load_date timestamp
);

CREATE TABLE core.sat_date
( date_key int primary key references core.hub_client(client_key)
, record_source varchar
, load_date timestamp
, date date
, week int
, month int
, year int
, created_at timestamp
, updated_at timestamp
, deleted_at timestamp
);

CREATE TABLE core.hub_promo
( promo_key serial primary key
, external_id int
, record_source varchar
, load_date timestamp
);

CREATE TABLE core.sat_promo
( promo_key int primary key references core.hub_promo(promo_key)
, record_source varchar
, load_date timestamp
, amount decimal
, created_at timestamp
, updated_at timestamp
, deleted_at timestamp
);

CREATE TABLE core.link_order_client
( link_order_client_key serial primary key
, load_date timestamp
, order_key int references core.hub_order(order_key)
, client_key int references core.hub_client(client_key)
, date_from timestamp
, date_to timestamp
);

CREATE TABLE core.link_order_product
( link_order_product_key serial primary key
, load_date timestamp
, order_key int references core.hub_order(order_key)
, product_key int references core.hub_product(product_key)
, date_from timestamp
, date_to timestamp
);

CREATE TABLE core.link_order_date
( link_order_date_key serial primary key
, load_date timestamp
, order_key int references core.hub_order(order_key)
, date_key int references core.hub_date(date_key)
, date_from timestamp
, date_to timestamp
);

CREATE TABLE core.link_promo_product
( link_promo_product_key serial primary key
, load_date timestamp
, promo_key int references core.hub_promo(promo_key)
, product_key int references core.hub_product(product_key)
, date_from timestamp
, date_to timestamp
);

CREATE TABLE core.link_promo_client
( link_promo_client_key serial primary key
, load_date timestamp
, promo_key int references core.hub_promo(promo_key)
, client_key int references core.hub_client(client_key)
, date_from timestamp
, date_to timestamp
);

CREATE TABLE core.link_promo_date
( link_promo_date_key serial primary key
, load_date timestamp
, promo_key int references core.hub_promo(promo_key)
, date_key int references core.hub_date(date_key)
, date_from timestamp
, date_to timestamp
);

CREATE SCHEMA mart;

CREATE TABLE mart.client_data
( client_id int
, gender varchar
, age_category varchar
, email varchar
, phone varchar
, most_bought_product varchar
, most_bought_brand varchar
, cnt_order int
);