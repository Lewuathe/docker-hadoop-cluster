# docker-hadoop-cluster [![Build Status](https://travis-ci.org/Lewuathe/docker-hadoop-cluster.svg?branch=master)](https://travis-ci.org/Lewuathe/docker-hadoop-cluster)

Multiple node cluster on Docker for self development.
docker-hadoop-cluster is suitable for testing your patch for Hadoop which has multiple nodes.

# Pull image
If you want to use latest hadoop version in docker cluster, all you have to do is pull build images.
Just after that, you can run your cluster on Docker.

```bash
$ docker pull lewuathe/hadoop-base
$ docker pull lewuathe/hadoop-master
$ docker pull lewuathe/hadoop-slave
```

# Build images

## hadoop-base

Base image of hadoop service. This image includes JDK, hadoop package configurations etc. This image can include your self-build hadoop package.
In order to bind, tar.gz package assumed be put under `hadoop-base` directory.

```bash
$ cp hadoop-3.0.0-alpha1-SNAPSHOT.tar.gz hadoop-base
$ cd hadoop-base
$ docker build -f Dockerfile-local -t lewuathe/hadoop-base .
```

Once you build `hadoop-base` image, you can launch hadoop cluster by using docker-compose.

```
$ docker-compose up -d
```

See http://localhost:9870 for NameNode or http://localhost:8088 for ResourceManager.


When you want to create released hadoop image(it's 2.7.0 currently), you can build with `Dockerfile`

```bash
$ docker build -t lewuathe/hadoop-base .
```

## hadoop-master

This image includes master service such as namenode and resource manager.

```bash
$ cd hadoop-master
$ docker build -t lewuathe/hadoop-master .
```

## hadoop-slave

This image includes slave service such as datanode and node manager.

```bash
$ cd hadoop-slave
$ docker build -t lewuathe/hadoop-slave .
```

Or you can build images with build_cluster.sh command.

```bash
$ cd docker-hadoop-cluster
$ bin/build_cluster.sh build
```

# Running cluster

First master node should be launched.

```bash
$ docker run -d -p 50070:50070 -p 8088:8088 --net hadoop-network --name master -h master lewuathe/hadoop-master
```

Second slave node is launched.

```bash
$ docker run -d --name slave1 -h slave1 --net hadoop-network lewuathe/hadoop-slave
```

Or you can use build script.

```bash
$ bin/build_cluster.sh --slaves 5 launch
$ bin/build_cluster.sh --slaves 5 destroy
```

docker-hadoop-cluster also uploads the latest image which refers HEAD of trunk. They are deployed on [Docker Hub](https://hub.docker.com/r/lewuathe/).
If you want to try the trunk (though it can be unstable), `docker-compose.yml` like below is needed. It will launch 3 slave Hadoop cluster.

```
version: '2'

services:
  master:
    image: lewuathe/hadoop-master
    ports:
      - "9870:9870"
      - "8088:8088"
      - "19888:19888"
      - "8188:8188"
    container_name: "master"
  slave1:
    image: lewuathe/hadoop-slave
    container_name: "slave1"
    depends_on:
      - master
    ports:
      - "9901:9864"
      - "8041:8042"
  slave2:
    image: lewuathe/hadoop-slave
    container_name: "slave2"
    depends_on:
      - master
    ports:
      - "9902:9864"
      - "8042:8042"
  slave3:
    image: lewuathe/hadoop-slave
    container_name: "slave3"
    depends_on:
      - master
    ports:
      - "9903:9864"
      - "8043:8042"

```

# Login cluster

```bash
$ docker exec -it master bash
bash-4.1# cd /usr/local/hadoop
bash-4.1# bin/hadoop version
Hadoop 3.0.0-SNAPSHOT
Source code repository git://git.apache.org/hadoop.git -r 0c7d3f480548745e9e9ccad1d318371c020c3003
Compiled by lewuathe on 2015-09-13T01:12Z
Compiled with protoc 2.5.0
From source with checksum 9174a352ac823cdfa576f525665e99
This command was run using /usr/local/hadoop-3.0.0-SNAPSHOT/share/hadoop/common/hadoop-common-3.0.0-SNAPSHOT.jar
```

# Deploy on EC2

We can run docker-hadoop-cluster on EC2 instance with `ec2/` script.

```
$ python ec2/ec2.py -k <Key Name> -s <Security Group ID> -n <Subnet ID> launch
```

This script launch EC2 instance and prepare prerequisites to launch docker-hadoop-cluster.

# Docker Hub

* [hadoop-base](https://hub.docker.com/r/lewuathe/hadoop-base/)
* [hadoop-master](https://hub.docker.com/r/lewuathe/hadoop-master/)
* [hadoop-slave](https://hub.docker.com/r/lewuathe/hadoop-slave/)

# License

[Apache License Version2.0](http://www.apache.org/licenses/LICENSE-2.0)
This images are modified version of [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker).
