#build
docker build -t pg_docker_exec:latest .
#run
docker run --rm -d -p 5432:5432 --name pg_docker_exec -v /tmp/pgdata:/var/lib/postgresql/data pg_docker_exec:latest
#stop
docker stop pg_docker_exec
#attach
docker exec -it pg_docker_exec psql -U postgres