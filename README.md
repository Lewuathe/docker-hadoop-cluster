# docker-hadoop-cluster

Multiple node cluster on Docker for self development.

# Build images

## hadoop-base

Base image of hadoop service. This image includes JDK, hadoop package configurations etc. This image can include your self-build hadoop package.
In order to bind, tar.gz package assumed be put under `hadoop-base` directory. 

```
$ cp hadoop-3.0.0-SNAPSHOT.tar.gz hadoop-base
$ cd hadoop-base
$ docker build -t lewuathe/hadoop-base 
```

## hadoop-master

This image includes master service such as namenode and resource manager.

```
$ cd hadoop-master
$ docker build -t lewuathe/hadoop-master
```

## hadoop-slave

This image includes slave service such as datanode and node manager.

```
$ cd hadoop-slave
$ docker build -t lewuathe/hadoop-slave
```

# Running cluster

First master node should be launched.

```
$ docker run -d -p 50070:50070 -p 8088:8088 --name nn lewuathe/hadoop-master
```

Second slave node is launched.

```
$ docker run --name dn1 lewuathe/hadoop-slave
```

# Login cluster

```
$ docker exec -it nn bash
bash-4.1# cd /usr/local/hadoop
bash-4.1# bin/hadoop version
Hadoop 3.0.0-SNAPSHOT
Source code repository git://git.apache.org/hadoop.git -r 0c7d3f480548745e9e9ccad1d318371c020c3003
Compiled by lewuathe on 2015-09-13T01:12Z
Compiled with protoc 2.5.0
From source with checksum 9174a352ac823cdfa576f525665e99
This command was run using /usr/local/hadoop-3.0.0-SNAPSHOT/share/hadoop/common/hadoop-common-3.0.0-SNAPSHOT.jar
```

# License

[Apache License Version2.0](http://www.apache.org/licenses/LICENSE-2.0)
This images are modified version of [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker).
