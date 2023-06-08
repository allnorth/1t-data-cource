#сборка проекта
docker compose build

#запуск проекта
docker compose up -d

#перезапуск проекта
docker compose restart

#остановка проекта
docker compose down

#подключение к базе данных
docker exec -it postgres psql -U postgres -d testdb

#логи с результатами выполнения python-скрипта
docker logs app

#запуск расчета
docker restart app
