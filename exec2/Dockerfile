FROM postgres:latest

ENV POSTGRES_PASSWORD=mypostgrespass
ENV POSTGRES_USER=postgres
ENV POSTGRES_DATABASE=postgres

COPY init.sql /docker-entrypoint-initdb.d/init.sql