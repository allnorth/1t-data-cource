#Обединяем pdf-файлы
pdfunite voyna-i-mir-tom-1.pdf voyna-i-mir-tom-2.pdf voyna-i-mir-tom-3.pdf voyna-i-mir-tom-4.pdf  out.pdf

#Копируем в контейнер
docker cp out.pdf docker-hadoop-hive-parquet-datanode-1:/tolstoi/out.pdf

#Создаём новый католог
hadoop fs -mkdir /user/user/tolstoi

#Копируем файл в hdfs
hadoop fs -put /tolstoi/out.pdf /user/user/tolstoi/out.pdf

#Выводим содержание личной папки
hadoop fs -ls /user/user/tolstoi

Found 1 items
-rw-r--r--   3 root user    6592792 2023-08-13 07:17 /user/user/tolstoi/out.pdf

#Предоставляем права на чтение и выполнение
hadoop fs -chmod +rx /user/user/tolstoi/out.pdf

#Проверка прав
hadoop fs -ls /user/user/tolstoi

Found 1 items
-rwxr-xr-x   3 root user    6592792 2023-08-13 07:17 /user/user/tolstoi/out.pdf

#Вывод места, занимаемого файлом
hadoop fs -du -s -h /user/user/tolstoi/out.pdf

6.3 M  /user/user/tolstoi/out.pdf

#Изменяем фактор репликации
hadoop fs -setrep 2 /user/user/tolstoi/out.pdf

#ИЗМЕНЕНИЙ НЕТ - ТАК КАК ИСПОЛЬЗУЕТСЯ ОДНА ДАТАНОДА

hadoop fsck /user/user/tolstoi/out.pdf

Connecting to namenode via http://namenode:50070/fsck?ugi=root&path=%2Fuser%2Fuser%2Ftolstoi%2Fout.pdf
FSCK started by root (auth:SIMPLE) from /172.21.0.8 for path /user/user/tolstoi/out.pdf at Sun Aug 13 07:42:13 UTC 2023
.
/user/user/tolstoi/out.pdf:  Under replicated BP-1050568740-172.21.0.2-1691909190335:blk_1073741831_1007. Target Replicas is 2 but found 1 replica(s).
Status: HEALTHY
 Total size:    6592792 B
 Total dirs:    0
 Total files:   1
 Total symlinks:                0
 Total blocks (validated):      1 (avg. block size 6592792 B)
 Minimally replicated blocks:   1 (100.0 %)
 Over-replicated blocks:        0 (0.0 %)
 Under-replicated blocks:       1 (100.0 %)
 Mis-replicated blocks:         0 (0.0 %)
 Default replication factor:    3
 Average block replication:     1.0
 Corrupt blocks:                0
 Missing replicas:              1 (50.0 %)
 Number of data-nodes:          1
 Number of racks:               1
FSCK ended at Sun Aug 13 07:42:13 UTC 2023 in 2 milliseconds


The filesystem under path '/user/user/tolstoi/out.pdf' is HEALTHY

#Количество строк в файле
hadoop fs -cat /user/user/tolstoi/out.pdf | wc -l

44924