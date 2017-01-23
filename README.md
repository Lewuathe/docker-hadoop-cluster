# docker-hadoop-cluster [![Build Status](https://travis-ci.org/Lewuathe/docker-hadoop-cluster.svg?branch=master)](https://travis-ci.org/Lewuathe/docker-hadoop-cluster)

Multiple node cluster on Docker for self development.
docker-hadoop-cluster is suitable for testing your patch for Hadoop which has multiple nodes.

# Build images from your Hadoop source code

Base image of hadoop service. This image includes JDK, hadoop package configurations etc. This image can include your self-build hadoop package.
In order to bind, tar.gz package assumed be put under `hadoop-base` directory.

```bash
$ cd docker-hadoop-cluster
$ cp /path/to/hadoop-3.0.0-alpha3-SNAPSHOT.tar.gz hadoop-base
$ make
```

Once you build `hadoop-base` image, you can launch hadoop cluster by using docker-compose.

```
$ docker-compose up -d
```

or

```
$ make run
```

See http://localhost:9870 for NameNode or http://localhost:8088 for ResourceManager.

```
$ make down
```

shutdowns your cluster.

# Build images from the latest trunk

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

| Image name | Pulls | Stars |
|:-----|:-----|:-----|
| lewuathe/hadoop-base   | [![hadoop-base](https://img.shields.io/docker/pulls/lewuathe/hadoop-base.svg)](https://hub.docker.com/r/lewuathe/hadoop-base/)       | ![hadoop-base](https://img.shields.io/docker/stars/lewuathe/hadoop-base.svg)   |
| lewuathe/hadoop-master | [![hadoop-master](https://img.shields.io/docker/pulls/lewuathe/hadoop-master.svg)](https://hub.docker.com/r/lewuathe/hadoop-master/) | ![hadoop-master](https://img.shields.io/docker/stars/lewuathe/hadoop-master.svg) |
| lewuathe/hadoop-slave  | [![hadoop-slave](https://img.shields.io/docker/pulls/lewuathe/hadoop-slave.svg)](https://hub.docker.com/r/lewuathe/hadoop-slave/)    | ![hadoop-slave](https://img.shields.io/docker/stars/lewuathe/hadoop-slave.svg)  |

# License

[Apache License Version2.0](http://www.apache.org/licenses/LICENSE-2.0)
This images are modified version of [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker).
