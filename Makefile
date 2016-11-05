all:
	docker build -t lewuathe/hadoop-base:latest hadoop-base
	docker build -t lewuathe/hadoop-master:latest hadoop-master
	docker build -t lewuathe/hadoop-slave:latest hadoop-slave
	docker-compose build

.PHONY: test clean

run:
	docker-compose up -d
	echo "Please check http://localhost:8080"

down:
	docker-compose down
