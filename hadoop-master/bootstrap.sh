#!/bin/bash

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/NAMENODE/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
#sed s/NAMENODE/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/hdfs-site.xml.template > /usr/local/hadoop/etc/hadoop/hdfs-site.xml
#sed s/RESOURCEMANAGER/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/yarn-site.xml.template.template > /usr/local/hadoop/etc/hadoop/yarn-site.xml.template

service ssh start

nohup $HADOOP_HOME/bin/hdfs   namenode        2>> $HADOOP_LOG_DIR/namenode.err        >> $HADOOP_LOG_DIR/namenode.out &
nohup $HADOOP_HOME/bin/yarn   resourcemanager 2>> $HADOOP_LOG_DIR/resourcemanager.err >> $HADOOP_LOG_DIR/resourcemanager.out &
nohup $HADOOP_HOME/bin/yarn   timelineserver  2>> $HADOOP_LOG_DIR/timelineserver.err  >> $HADOOP_LOG_DIR/timelineserver.out &
nohup $HADOOP_HOME/bin/mapred historyserver   2>> $HADOOP_LOG_DIR/historyserver.err   >> $HADOOP_LOG_DIR/historyserver.out &

if [[ $1 == "-d" ]]; then
    while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
