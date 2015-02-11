FROM centos:6.6

MAINTAINER "Abhilash S T P"

RUN yum -y update; yum install -y openssh-server unzip tar untar wget docker-io

RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz -O /tmp/jdk-7u75-linux-x64.tar.gz
RUN tar zxf /tmp/jdk-7u75-linux-x64.tar.gz -C /opt

ENV JAVA_HOME /opt/jdk-7u75-linux-x64
ENV PATH=$PATH:$JAVA_HOME/bin

RUN wget -q http://mirrors.koehn.com/apache/zookeeper/current/zookeeper-3.4.6.tar.gz -O /tmp/zookeeper-3.4.6.tar.gz
RUN tar xfz /tmp/zookeeper-3.4.6.tar.gz -C /opt
RUN mv /opt/zookeeper-3.4.6/conf/zoo_sample.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ENV ZK_HOME /opt/zookeeper-3.4.6
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22 2181 2888 3888

WORKDIR $ZK_HOME
VOLUME ["/opt/zookeeper-3.4.6/conf", "/opt/zookeeper-3.4.6/data"]
RUN service sshd start
CMD ["$ZK_HOME/bin/zkServer.sh","start-foreground"]
