#!/bin/bash

# Start SSH service
service ssh start
if [ -z "$HOST_IP" ]; then
    HOST_IP=localhost
fi

sed -i "s|\${HOST_IP}|$HOST_IP|" $HADOOP_HOME/etc/hadoop/hdfs-site.xml
sed -i "s|\${HOST_IP}|$HOST_IP|" $HADOOP_HOME/etc/hadoop/core-site.xml
# sed -i "s|\${HOST_IP}|$HOST_IP|" $HBASE_HOME/conf/hbase-site.xml
echo "Using HOST_IP: $HOST_IP"

# sed -i "s|<name>dfs.datanode.hostname</name>.*|<name>dfs.datanode.hostname</name><value>$HOST_IP</value>|" $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Pre-accept SSH host keys to avoid prompts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts 2>/dev/null
# ssh-keyscan -H ${HOSTNAME} >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H namenode >> ~/.ssh/known_hosts 2>/dev/null
# Format namenode if it hasn't been formatted
if [ ! -d "/data/hadoop/hdfs/namenode/current" ]; then
    echo "Formatting namenode..."
    $HADOOP_HOME/bin/hdfs namenode -format -force
fi

# Start Hadoop services
echo "Starting datanode services."

# Start NameNode daemon
hdfs --daemon start namenode

# (Optional) Start SecondaryNameNode daemon (for checkpoints)
hdfs --daemon start secondarynamenode

# (If using YARN) Start ResourceManager daemon
yarn --daemon start resourcemanager
# Wait for HDFS to be ready
echo "Waiting for HDFS to be ready..."
hdfs dfsadmin -safemode leave
hdfs dfs -chmod 777 /
sleep 5

# Create HBase directory in HDFS if it doesn't exist
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /hbase

tail -f /dev/null