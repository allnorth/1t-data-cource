#Копируем файлы в контейнер
docker cp customers.csv docker-hadoop-hive-parquet-datanode-1:/customers.csv
docker cp people.csv docker-hadoop-hive-parquet-datanode-1:/people.csv
docker cp organization.csv docker-hadoop-hive-parquet-datanode-1:/organization.csv

#Создаём новый католог
hadoop fs -mkdir /user/user/hive_files

#Копируем файл в hdfs
hadoop fs -put /customers.csv /user/user/hive_files/customers.csv
hadoop fs -put /people.csv /user/user/hive_files/people.csv
hadoop fs -put /organization.csv /user/user/hive_files/organization.csv

#Предоставляем права на чтение
hadoop fs -chmod 755 /user/user/hive_files/customers.csv
hadoop fs -chmod 755 /user/user/hive_files/people.csv
hadoop fs -chmod 755 /user/user/hive_files/organization.csv