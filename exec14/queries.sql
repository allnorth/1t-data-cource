set hive.exec.dynamic.partition.mode=nonstrict;

drop table if exists temp_people;
drop table if exists temp_organizations;
drop table if exists temp_customers;
drop table if exists people;
drop table if exists organizations;
drop table if exists customers;

CREATE TABLE IF NOT EXISTS temp_customers
(
    id                string,
    customer_id       string,
    company           string,
    email             string,
    subscription_date date,
    year              int,
    group_id          int
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE
tblproperties("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS temp_people
(
    id                string,
    user_id           string,
    email             string,
    date_of_birth     date,
    group_id          string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE
tblproperties("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS temp_organizations
(
    id                  string,
    organization_id     string,
    name                string,
    group_id            string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE
tblproperties("skip.header.line.count"="1");

CREATE TABLE IF NOT EXISTS customers
(
    id                int,
    customer_id       string,
    company           string,
    email             string,
    subscription_date date
)
PARTITIONED BY (group_id int, year int)
CLUSTERED BY (id) INTO 10 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

CREATE TABLE IF NOT EXISTS people
(
    id int,
    user_id string,
    email   string,
    date_of_birth     date
)
PARTITIONED BY (group_id int)
CLUSTERED BY (id) INTO 10 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

CREATE TABLE IF NOT EXISTS organizations
(
    id                  int,
    organization_id     string,
    name                string
)
PARTITIONED BY (group_id int)
CLUSTERED BY (id) INTO 10 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA INPATH '/user/user/hive_files/customers.csv' OVERWRITE INTO TABLE temp_customers;
LOAD DATA INPATH '/user/user/hive_files/people.csv' OVERWRITE INTO TABLE temp_people;
LOAD DATA INPATH '/user/user/hive_files/organizations.csv' OVERWRITE INTO TABLE temp_organizations;

INSERT INTO customers partition (group_id, year) select * from temp_customers;
INSERT INTO people partition (group_id) select * from temp_people;
INSERT INTO organizations partition (group_id) select * from temp_organizations;

with tbl as (select company, subscription_year, age_group, count(age_group) as cnt
             from   (   select  c.company,
                                year(c.subscription_date) as subscription_year,
                                case
                                    when year(`current_date`()) - year(p.date_of_birth) between 0 and 18
                                    then '0-18'
                                    when year(`current_date`()) - year(p.date_of_birth) between 19 and 25
                                    then '18-25'
                                    when year(`current_date`()) - year(p.date_of_birth) between 26 and 35
                                    then '25-35'
                                    when year(`current_date`()) - year(p.date_of_birth) between 36 and 45
                                    then '35-45'
                                    when year(`current_date`()) - year(p.date_of_birth) between 46 and 55
                                    then '45-55'
                                    when year(`current_date`()) - year(p.date_of_birth) between 56 and 65
                                    then '55-65'
                                    when year(`current_date`()) - year(p.date_of_birth) > 65
                                    then 'more 65'
                                end as age_group
                        from people p
                        join customers c on p.email = c.email) as t
                        group by company, subscription_year, age_group
                    )


select t.company, t.subscription_year, t.age_group
from tbl t
join    (   select company, subscription_year, max(cnt)
            from tbl
            group by company, subscription_year
        ) as tt on tt.company = t.company and tt.subscription_year = t.subscription_year