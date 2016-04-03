# docker-hadoop-cluster

Multiple node cluster on Docker for self development.

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
$ cp hadoop-3.0.0-SNAPSHOT.tar.gz hadoop-base
$ cd hadoop-base
$ docker build -f Dockerfile-local -t lewuathe/hadoop-base .
```

Once you build `hadoop-base` image, you can launch hadoop cluster by using docker-compose.

```
$ docker-compose up -d
```

See http://<Docker IP>:50070 or http://<Docker IP>:8088.


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

# Docker Hub

* [hadoop-base](https://hub.docker.com/r/lewuathe/hadoop-base/)
* [hadoop-master](https://hub.docker.com/r/lewuathe/hadoop-master/)
* [hadoop-slave](https://hub.docker.com/r/lewuathe/hadoop-slave/)

# License

[Apache License Version2.0](http://www.apache.org/licenses/LICENSE-2.0)
This images are modified version of [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker).
