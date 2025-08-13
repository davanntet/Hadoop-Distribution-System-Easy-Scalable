FROM ubuntu:22.04

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION=3.3.4
ENV HBASE_VERSION=2.4.18
ENV HADOOP_HOME=/opt/hadoop
ENV HBASE_HOME=/opt/hbase
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$HBASE_HOME/bin

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk-headless \
    wget \
    curl \
    ssh \
    rsync \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH for Hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Download and install Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
    rm hadoop-${HADOOP_VERSION}.tar.gz


# Create necessary directories
RUN mkdir -p /tmp/hadoop-logs \
    && mkdir -p /opt/hadoop/logs \
    && mkdir -p /opt/hbase/logs \
    && mkdir -p /data/hadoop/hdfs/datanode

# Configure Hadoop
COPY config/* $HADOOP_CONF_DIR/

# Set permissions
RUN chmod +x ${HADOOP_HOME}/sbin/* \
    && chmod -R 777 /data/hadoop/hdfs \
    && chmod -R 777 /data/hadoop/hdfs/datanode

RUN apt update && \
    apt install sudo -y && \
    apt-get install -y iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f ${HBASE_HOME}/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar
# Expose ports
EXPOSE 9870 9000 8088 8042 19888 9864 8020

# Create startup script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

WORKDIR $HADOOP_HOME

CMD ["/start-services.sh"]
    