#!/bin/bash

# Start SSH service
service ssh start
if [ -z "$HOST_IP" ]; then
    HOST_IP=localhost
fi

# Pre-accept SSH host keys to avoid prompts
ssh-keyscan -H localhost >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts 2>/dev/null
ssh-keyscan -H ${HOSTNAME} >> ~/.ssh/known_hosts 2>/dev/null

sleep 2.5
/opt/zookeeper/bin/zkServer.sh start
# Wait for Zookeeper to be ready
echo "Waiting for Zookeeper to be ready..."
sleep 5
# Keep container running
tail -f /dev/null