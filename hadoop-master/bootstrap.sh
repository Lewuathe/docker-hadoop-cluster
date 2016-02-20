#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/NAMENODE/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
#sed s/NAMENODE/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml.template > /usr/local/hadoop/etc/hadoop/hdfs-site.xml
#sed s/RESOURCEMANAGER/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/yarn-site.xml.template.template > /usr/local/hadoop/etc/hadoop/yarn-site.xml.template

service sshd start
nohup $HADOOP_PREFIX/bin/hdfs namenode 2>> /var/log/hadoop/namenode.err > /var/log/hadoop/namenode.out &
nohup $HADOOP_PREFIX/bin/yarn resourcemanager 2>> /var/log/hadoop/resourcemanager.err > /var/log/hadoop/resourcemanager.out &
nohup $HADOOP_PREFIX/bin/yarn timelineserver 2>> /var/log/hadoop/timelineserver.err > /var/log/hadoop/timelineserver.out &
nohup $HADOOP_PREFIX/bin/mapred historyserver 2>> /var/log/hadoop/historyserver.err > /var/log/hadoop/historyserver.out &

if [[ $1 == "-d" ]]; then
    while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
