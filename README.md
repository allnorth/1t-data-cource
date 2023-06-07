## Задение 1
### Введение в git

## Задание 2
### Введение в Docker

## Задание 2 ПРО
### Описание проекта
Проект предоставляет следующие возможности:
1. добавлять/изменять/удалять данные в базе данных 
2. производить расчет данных с помощью python-скрипта

### Pазвертывение проекта
Для локального запуска проекта необходимо выполнить следующние шаги
1. Установить [docker](https://docs.docker.com/get-docker/)

### Использование проекта
Запуск проекта:
```docker compose up --build -d```

Подключение к базе данных:
```docker exec -it postgres psql -U postgres```

Просмотр результатов расчета:
```docker logs app```

Перезапуск расчета:
```docker restart app```

Остановка проекта:
```docker compose down```

### Содержание проекта
В проекте используются следующие технологии:
1. PostgreSQL
2. Python
3. Docker

