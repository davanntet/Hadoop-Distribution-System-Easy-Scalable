FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk -y \
    wget \
    curl \
    ssh \
    rsync \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz && \
    tar -xzf apache-zookeeper-3.8.4-bin.tar.gz && \
    mv apache-zookeeper-3.8.4-bin /opt/zookeeper && \
    rm apache-zookeeper-3.8.4-bin.tar.gz

RUN mkdir -p /opt/zookeeper/data
COPY config/* /opt/zookeeper/conf/
# Create startup script
COPY start-services.sh /start-services.sh
RUN chmod +x /start-services.sh

WORKDIR /opt/zookeeper

CMD ["/start-services.sh"]


