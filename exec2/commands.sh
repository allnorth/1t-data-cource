#сборка проекта
docker compose build

#запуск проекта
docker compose up -d

#перезапуск проекта
docker compose restart

#остановка проекта
docker compose down

#логи с результатами выполнения python-скрипта
docker logs app-1

#запуск расчета
docker restart app-1