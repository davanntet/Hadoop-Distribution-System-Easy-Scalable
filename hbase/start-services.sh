#!/bin/bash

# Start SSH service
service ssh start
if [ -z "$HOST_IP" ]; then
    HOST_IP=localhost
fi

sed -i "s|\${HOST_IP}|$HOST_IP|" $HBASE_HOME/conf/hbase-site.xml
sed -i "s|\${NAMENODE_HOST}|$NAMENODE_HOST|" $HBASE_HOME/conf/hbase-site.xml
sed -i "s|\${HOSTNAME}|$HOSTNAME|" $HBASE_HOME/conf/hbase-site.xml
sed -i "s|\${HMASTER_HOST}|$HMASTER_HOST|" $HBASE_HOME/conf/hbase-site.xml
sed -i "s|\${ZOOKEEPER_HOST}|$ZOOKEEPER_HOST|" $HBASE_HOME/conf/hbase-site.xml
echo "Using HOST_IP: $HOST_IP"

# sed -i "s|<name>dfs.datanode.hostname</name>.*|<name>dfs.datanode.hostname</name><value>$HOST_IP</value>|" $HADOOP_HOME/etc/hadoop/hdfs-site.xml

# Pre-accept SSH host keys to avoid prompts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H ${HOSTNAME} >> ~/.ssh/known_hosts 2>/dev/null

# Start HBase
echo "Starting HBase..."
echo "Waiting for HDFS to be ready..."
sleep 5
# $HBASE_HOME/bin/start-hbase.sh
if [ "$ROLE" == "master" ]; then
    echo "Starting HBase Master..."
    $HBASE_HOME/bin/hbase-daemon.sh start master
elif [ "$ROLE" == "regionserver" ]; then
    echo "Starting HBase RegionServer..."
    $HBASE_HOME/bin/hbase-daemon.sh start regionserver
else
    echo "No ROLE defined, starting HBase Master by default..."
    $HBASE_HOME/bin/start-hbase.sh
fi

# Wait for HBase to be ready
echo "Waiting for HBase to be ready..."
sleep 5
hbase thrift start &
echo "All services started. Hadoop Web UI: http://localhost:9870, HBase Web UI: http://localhost:16010"

# Keep container running
tail -f /dev/null