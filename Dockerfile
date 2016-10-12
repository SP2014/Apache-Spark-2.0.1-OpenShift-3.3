# Run latest version of Apache Spark 2.0.1 in a RHEL7 container
FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER Ganesh R, gradhakr@nilanet.com

# Upgrade the system
RUN yum -y upgrade
RUN yum -y install wget tar gunzip

# Download OpenJDK 8
RUN yum -y install java-1.8.0-openjdk-devel

# Set the Java & Spark Home env variables
ENV JAVA_HOME /usr/lib/jvm/java-openjdk 
ENV SPARK_DIR /Spark
ENV SPARK_REL spark-2.0.1-bin-hadoop2.7

# Download Apache Spark 2.0.1 (approx. 179mb)
RUN wget --no-cookies --no-check-certificate "http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.7.tgz" -O /tmp/spark.tgz

# Switch directory 
WORKDIR ${SPARK_DIR}

# Unzip the file into current working directory
RUN tar -xzf /tmp/spark.tgz

# Export java bin directory
RUN export PATH=${JAVA_HOME}/bin:${PATH}

# Expose Spark master on default port 7077 on the container
EXPOSE 7077

# Expose Spark master webui (MasterWebUI) port 8080 on the container
EXPOSE 8080

# Expose Spark REST Server (StandaloneRestServer) port 6066 on the container
EXPOSE 6066

# Change perms for spark directory
RUN chmod -R 777 ./${SPARK_REL}

# Start the Apache Spark master server.
CMD ["./${SPARK_REL}/sbin/start-master.sh"]
