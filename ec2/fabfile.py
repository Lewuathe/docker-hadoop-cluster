#!/usr/bin/env python

from fabric.api import sudo, run

def uname():
    run('uname')

def prepare():
    sudo('yum install git docker -y')
    sudo('service docker start')
    sudo('gpasswd -a ec2-user docker')

def install_docker_hadoop_cluster():
    run('git clone https://github.com/Lewuathe/docker-hadoop-cluster.git')

def deploy():
    prepare()
    install_docker_hadoop_cluster()
