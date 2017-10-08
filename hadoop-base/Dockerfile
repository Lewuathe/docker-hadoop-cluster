#
# This image is modified version of sequenceiq/hadoop-docker
#   * sequenceiq/hadoop-docker <https://github.com/sequenceiq/hadoop-docker>
#
# The modifications are
#   * Use local hadoop package
#   * Change template files to indicate docker master node
#   * Modify bootstrap script
#
# Author: Kai Sasaki
# Date:   2015 Sep,13
#
# Creates multi node hadoop cluster on Docker

FROM ubuntu:17.10
MAINTAINER lewuathe

USER root

# install dev tools
RUN apt-get update && \
	apt-get install -y tar sudo openssh-server openssh-client rsync

# passwordless ssh
COPY conf/.ssh/* /root/.ssh/
RUN sed -i "/^[^#]*UsePAM/ s/.*/#&/" /etc/ssh/sshd_config && \
	echo "UsePAM no" >> /etc/ssh/sshd_config && \
	echo "Port 2122" >> /etc/ssh/sshd_config && \
	rm -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
	rm -f /etc/ssh/ssh_host_rsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
	rm -f /root/.ssh/id_rsa    && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
	cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
	chmod 600 /root/.ssh/config && \
	chown -R root:root /root/.ssh

# java

ARG JAVA_HOME=/usr/java/default

ENV JAVA_HOME ${JAVA_HOME}
ENV PATH      $PATH:$JAVA_HOME/bin

RUN mkdir -p ${JAVA_HOME} && \
	wget 'http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz' --header='Cookie: oraclelicense=accept-securebackup-cookie' -O - | \
	tar --strip-components=1 -xz -C ${JAVA_HOME}

# hadoop

ARG HADOOP_VERSION=3.0.0-beta1
ARG HADOOP_HOME=/usr/local/hadoop

ENV HADOOP_VERSION     ${HADOOP_VERSION}
ENV HADOOP_HOME        ${HADOOP_HOME}
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME   ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_YARN_HOME   ${HADOOP_HOME}
ENV HADOOP_CONF_DIR    ${HADOOP_HOME}/etc/hadoop
ENV YARN_CONF_DIR      ${HADOOP_HOME}/etc/hadoop
ENV HADOOP_LOG_DIR     /var/log/hadoop
ENV PATH 			   $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

RUN mkdir -p ${HADOOP_HOME} && \
	wget http://apache.javapipe.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O - | \
	tar --strip-components=1 -xz -C ${HADOOP_HOME}

COPY conf/hadoop/* $HADOOP_HOME/etc/hadoop/

RUN mkdir $HADOOP_LOG_DIR && \
	mkdir $HADOOP_HOME/input && \
	cp $HADOOP_HOME/etc/hadoop/*.xml $HADOOP_HOME/input && \
	sed -i "s!^# export JAVA_HOME.*!export JAVA_HOME=${JAVA_HOME}\nexport H=${HADOOP_HOME}\nexport HADOOP_HOME=${HADOOP_HOME}\n!" $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
	sed -i "s!^# export HADOOP_CONF_DIR.*!export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop/!" $HADOOP_HOME/etc/hadoop/hadoop-env.sh

RUN $HADOOP_HOME/bin/hdfs namenode -format

# fixing the libhadoop.so like a boss
RUN mkdir -p /tmp/native && \
	wget http://dl.bintray.com/sequenceiq/sequenceiq-bin/hadoop-native-64-2.7.0.tar -O - | tar -x -C /tmp/native && \
	rm -rf ${HADOOP_HOME}/lib/native && \
	mv /tmp/native ${HADOOP_HOME}/lib

# workingaround docker.io build error
RUN chmod +x ${HADOOP_HOME}/etc/hadoop/*-env.sh

RUN service ssh start

# Hdfs ports
EXPOSE 9000 50010 50020 50070 50075 50090
# See https://issues.apache.org/jira/browse/HDFS-9427
EXPOSE 9871 9870 9820 9869 9868 9867 9866 9865 9864
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088 8188
#Other ports
EXPOSE 49707 2122