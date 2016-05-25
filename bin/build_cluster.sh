#!/bin/bash

PROGNAME=$(basename $0)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_usage() {
  echo "Usage: $0 [launch|destroy]"
  echo ""
  echo "    launch  : Launch hadoop cluster on docker"
  echo "    destroy : Remove hadoop cluster on docker"
  echo "    build   : Build docker images with local hadoop binary"
  echo ""
  echo "    Options:"
  echo "        -h,  --help      : Print usage"
  echo "        -s, --slaves : Specify the number of slaves"
  echo ""
}

if [ $# -eq 0 ]; then
  print_usage
fi

DATANODE_NUM=3
CLUSTER_NAME=default_cluster

for OPT in "$@"
do
    case "$OPT" in
        '-h'|'--help' )
            print_usage
            exit 1
            ;;
        '-s'|'--slaves' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit 1
            fi
            DATANODE_NUM="$2"
            shift 2
            ;;
        '-c'|'--cluster' )
            CLUSTER_NAME="$2"
            shift 2
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            ;;
    esac
done

launch_cluster() {
  if ! docker network inspect hadoop-network > /dev/null ; then
    echo "Creating hadoop-network"
    docker network create --driver bridge hadoop-network
  fi
  echo "Launching master server"
  docker run -d -p 9870:9870 -p 8088:8088 -p 19888:19888 -p 8188:8188 --net hadoop-network --name master -h master lewuathe/hadoop-master:latest
  echo "Launching slave servers"
  for i in `seq 1 $DATANODE_NUM`; do
    docker run -d -p 990${i}:9864 -p 804${i}:8042 --name slave${i} -h slave${i} --net hadoop-network lewuathe/hadoop-slave:latest
  done
}

destroy_cluster() {
  docker kill master; docker rm master
  for i in `seq 1 $DATANODE_NUM`; do
    docker kill slave${i}; docker rm slave${i}
  done
  docker network rm hadoop-network
}

build_images() {
  cd $DIR/../hadoop-base
  docker build -f Dockerfile-local -t lewuathe/hadoop-base:latest .
  cd $DIR/../hadoop-master
  docker build -t lewuathe/hadoop-master:latest .
  cd $DIR/../hadoop-slave
  docker build -t lewuathe/hadoop-slave:latest .
}

case $1 in
    launch) launch_cluster
        ;;
    destroy) destroy_cluster
        ;;
    build) build_images
        ;;
esac

exit 0
