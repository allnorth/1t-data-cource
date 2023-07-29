create table exchange_rate
( id serial primary key
	, rate_dt date
	, rate_amt decimal
);

create table rates_by_month
( id serial primary key
, start_date date
, end_date date
, currency varchar
, max_rate_dt date
, min_rate_dt date
, max_rate_amt decimal
, min_rate_amt decimal
, avg_rate_amt decimal
, last_date_rate_amt decimal
);