#!/usr/bin/env bash

set -e

function log {
    echo `date` $ME - $@
}

function checkrancher {
    log "checking rancher network..."
    a="1"
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`" 
        sleep 1
    done

    b="1"
    while [ $b -eq 1 ]; 
    do
        b="`ping -c 1 rancher-metadata &> /dev/null; echo $?`"
        sleep 1 
    done
}

VAMP_API_PORT=${VAMP_API_PORT:-"8080"}
VAMP_DB_TYPE=${VAMP_DB_TYPE:-"elasticsearch"} # elasticsearch or in-memory (no persistence)
VAMP_DB_URL=${VAMP_DB_URL:-"http://elasticsearch:9200"}
VAMP_KEY_TYPE=${VAMP_KEY_TYPE:-"zookeeper"}  # zookeeper, etcd or consul
VAMP_KEY_PATH=${VAMP_KEY_PATH:-"/vamp"} # base path for keys, e.g. /vamp/...
VAMP_KEY_SERVERS=${VAMP_KEY_SERVERS:-"zookeeper:2181"}
VAMP_HEAP_OPTS=${VAMP_HEAP_OPTS:-"-Xmx1G -Xms1G"}
VAMP_DRIVER_URL=${VAMP_DRIVER_URL:-"unix:///var/run/docker.sock"}
   
checkrancher

export VAMP_API_PORT VAMP_DB_TYPE VAMP_DB_URL VAMP_KEY_TYPE VAMP_KEY_PATH VAMP_KEY_SERVERS VAMP_HEAP_OPTS VAMP_DRIVER_URL

${VAMP_HOME}/scripts/application.conf.sh 
${VAMP_HOME}/scripts/logback.xml.sh

log "[ Starting vamp service... ]"
java $VAMP_HEAP_OPTS -Dlogback.configurationFile=${VAMP_HOME}/conf/logback.xml -Dconfig.file=${VAMP_HOME}/conf/application.conf -jar ${VAMP_HOME}/jar/${VAMP_RELEASE}
