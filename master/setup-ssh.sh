#!/bin/sh
echo "creating ssh key for hadoop-master"
docker exec -it hadoop-master ssh-keygen -t rsa -b 4096
echo "moving ssh key for hadoop-master"
docker exec hadoop-master bash -c 'cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys'
echo "change owner for hadoop-master"
docker exec hadoop-master bash -c 'chmod og-wx ~/.ssh/authorized_keys'
docker exec hadoop-master bash -c 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no localhost'

docker exec -it hadoop-master bash -c 'ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave1'
docker exec -it hadoop-master bash -c 'ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave2'

docker exec hadoop-master /usr/local/hadoop/bin/hdfs namenode -format
docker exec -it hadoop-master /usr/local/hadoop/sbin/start-all.sh namenode -format
