#!/bin/bash

print_usage() {
  echo "Usage: $0 [launch|destroy]"
  echo ""
  echo "    launch: Launch hadoop cluster on docker"
  echo "    destroy: Remove hadoop cluster on docker"
  echo ""
}

if [ $# -eq 0 ]; then
  print_usage
fi


DATANODE_NUM=3

launch_cluster() {
  docker run -d -p 50070:50070 -p 8088:8088 --name nn -h nn lewuathe/hadoop-master
  for i in `seq 1 $DATANODE_NUM`; do
    docker run -d --name dn${i} -h dn${i} lewuathe/hadoop-slave
  done
}

destroy_cluster() {
  docker kill nn; docker rm nn
  for i in `seq 1 $DATANODE_NUM`; do
    docker kill dn${i}; docker rm dn${i}
  done
}

case $1 in
    launch) launch_cluster
        ;;
    destroy) destroy_cluster
        ;;
esac

exit 0

