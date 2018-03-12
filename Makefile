all: build
	docker build -t lewuathe/hadoop-base:latest hadoop-base
	docker build -t lewuathe/hadoop-master:latest hadoop-master
	docker build -t lewuathe/hadoop-slave:latest hadoop-slave
	docker-compose build

.PHONY: test clean

run:
	docker-compose up -d
	echo "http://localhost:9870 for HDFS"
	echo "http://localhost:8088 for YARN"

down:
	docker-compose down

build:
ifeq ($(CIRCLECI),"true")
	sudo apt-get install autoconf automake libtool curl make g++ unzip
	wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
	tar -xzvf protobuf-2.5.0.tar.gz
	cd protobuf-2.5.0
	./configure && make && sudo make install && sudo ldconfig
	cd ..
	wget http://ftp.riken.jp/net/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.zip
	unzip apache-maven-3.5.2-bin.zip
	mvn -version
	cd hadoop
	mvn clean package -DskipTests -Pdist -Dtar | grep "Building Apache Hadoop"
	cp hadoop-dist/target/hadoop-3.2.0-SNAPSHOT.tar.gz ../hadoop-base
endif