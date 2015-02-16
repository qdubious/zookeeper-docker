FROM centos:6.6

MAINTAINER "Abhilash S T P"

RUN yum -y update; yum install -y vim unzip tar untar wget epel-release
RUN yum --enablerepo=epel -y install docker-io

RUN wget -q --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz -O /tmp/jdk-7u75-linux-x64.tar.gz
RUN tar zxf /tmp/jdk-7u75-linux-x64.tar.gz -C /opt

ENV JAVA_HOME /opt/jdk1.7.0_75

RUN wget -q http://mirrors.koehn.com/apache/zookeeper/current/zookeeper-3.4.6.tar.gz -O /tmp/zookeeper-3.4.6.tar.gz
RUN tar xfz /tmp/zookeeper-3.4.6.tar.gz -C /opt
RUN mv /opt/zookeeper-3.4.6/conf/zoo_sample.cfg /opt/zookeeper-3.4.6/conf/zoo.cfg
ENV ZK_HOME /opt/zookeeper-3.4.6
RUN sed -i 's|/tmp/zookeeper|$ZK_HOME/data|g' $ZK_HOME/conf/zoo.cfg; mkdir -p $ZK_HOME/data

EXPOSE 2181 2888 3888

CMD /opt/zookeeper-3.4.6/bin/zkServer.sh start-foreground
