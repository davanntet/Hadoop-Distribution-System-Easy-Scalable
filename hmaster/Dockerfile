FROM ubuntu:24.04

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

# Download and install HBase
RUN wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz && \
    tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz && \
    mv hbase-${HBASE_VERSION} $HBASE_HOME && \
    rm hbase-${HBASE_VERSION}-bin.tar.gz

COPY config/* $HBASE_CONF_DIR/

# Set permissions
RUN chmod +x ${HBASE_HOME}/bin/*

RUN apt update && \
    apt install sudo -y && \
    apt-get install -y iproute2 && \
    rm -rf /var/lib/apt/lists/*

RUN rm -f ${HBASE_HOME}/lib/client-facing-thirdparty/log4j-slf4j-impl-2.17.2.jar
# Expose ports
# HBase ports
EXPOSE 16010 16020 16030 2181 9090

# Create startup script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

WORKDIR $HADOOP_HOME

CMD ["/start-services.sh"]
    