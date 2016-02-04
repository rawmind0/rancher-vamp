FROM rawmind/rancher-jvm8:0.0.2-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

#Set environment
ENV VAMP_VERSION=0.8.2 \
    VAMP_HOME=/opt/vamp 
ENV VAMP_RELEASE=vamp-${VAMP_VERSION}.jar

RUN mkdir -p ${VAMP_HOME}/log ${VAMP_HOME}/conf ${VAMP_HOME}/jar && cd ${VAMP_HOME}/jar \
  && wget https://bintray.com/artifact/download/magnetic-io/downloads/vamp/${VAMP_RELEASE} 

# Add start.sh and config bin
ADD start.sh /usr/bin/start.sh
ADD conf/* /usr/bin/
RUN chmod +x /usr/bin/*.sh 

WORKDIR /opt/vamp

ENTRYPOINT /usr/bin/start.sh
