#!/usr/bin/env sh

cat << EOF > ${VAMP_HOME}/conf/application.conf
vamp {

  info {
    message = "Hi, I'm Vamp! How are you?"
    timeout = 3 # seconds, response timeout for each component (e.g. Persistance, Container Driver...)
  }

  persistence {
    response-timeout = 5 # seconds

    database {
      type = "${VAMP_DB_TYPE}" # elasticsearch or in-memory (no persistence)

      elasticsearch {
        url = "${VAMP_DB_URL}"
        response-timeout = 5 # seconds, timeout for elasticsearch operations
        index = "vamp-persistence"
      }
    }

    key-value-store {
      type = "${VAMP_KEY_TYPE}"  # zookeeper, etcd or consul
      base-path = "${VAMP_KEY_PATH}" # base path for keys, e.g. /vamp/...

      ${VAMP_KEY_TYPE} {
        servers = "${VAMP_KEY_SERVERS}"
        session-timeout = 5000
        connect-timeout = 5000
      }
    }
  }

  container-driver {
    type = "docker"
    url = "tcp://${DOCKER_HOST}:2375"
    response-timeout = 30 # seconds, timeout for container operations
  }

  dictionary {
    default-scale {
      instances: 1
      cpu: 1
      memory: 1GB
    }
    response-timeout = 5 # seconds, timeout for container operations
  }

  rest-api {
    interface = 0.0.0.0
    host = localhost
    port = ${VAMP_API_PORT}
    response-timeout = 10 # seconds, HTTP response time out
    sse {
      keep-alive-timeout = 15 # seconds, timeout after an empty comment (":\n") will be sent in order keep connection alive
    }
  }

  haproxy {
    tcp-log-format  = """{\"ci\":\"%ci\",\"cp\":%cp,\"t\":\"%t\",\"ft\":\"%ft\",\"b\":\"%b\",\"s\":\"%s\",\"Tw\":%Tw,\"Tc\":%Tc,\"Tt\":%Tt,\"B\":%B,\"ts\":\"%ts\",\"ac\":%ac,\"fc\":%fc,\"bc\":%bc,\"sc\":%sc,\"rc\":%rc,\"sq\":%sq,\"bq\":%bq}"""
    http-log-format = """{\"ci\":\"%ci\",\"cp\":%cp,\"t\":\"%t\",\"ft\":\"%ft\",\"b\":\"%b\",\"s\":\"%s\",\"Tq\":%Tq,\"Tw\":%Tw,\"Tc\":%Tc,\"Tr\":%Tr,\"Tt\":%Tt,\"ST\":%ST,\"B\":%B,\"CC\":\"%CC\",\"CS\":\"%CS\",\"tsc\":\"%tsc\",\"ac\":%ac,\"fc\":%fc,\"bc\":%bc,\"sc\":%sc,\"rc\":%rc,\"sq\":%sq,\"bq\":%bq,\"hr\":\"%hr\",\"hs\":\"%hs\",\"r\":%{+Q}r}"""
    }

    logstash {
      index = "logstash-*"
    }

    kibana {
      enabled = true
      elasticsearch.url = "${VAMP_DB_URL}"
      synchronization.period = 5 # seconds, synchronization will be active only if period is greater than 0
    }

    aggregation {
      window = 30 # seconds, aggregation will be active only if than 0
      period = 5  # refresh period in seconds, aggregation will be active only if greater than 0
    }
  }

  pulse {
    elasticsearch {
      url = "${VAMP_DB_URL}"
      index {
        name = "vamp-pulse"
        time-format.event = "YYYY-MM-dd"
      }
    }
    response-timeout = 30 # seconds, timeout for pulse operations
  }

  operation {

    synchronization {
      initial-delay = 5 # seconds
      period = 4 # seconds, synchronization will be active only if period is greater than 0

      mailbox {
        // Until we get available akka.dispatch.NonBlockingBoundedMailbox
        mailbox-type = "akka.dispatch.BoundedMailbox"
        mailbox-capacity = 10
        mailbox-push-timeout-time = 0s
      }

      timeout {
        ready-for-deployment =  600 # seconds
        ready-for-undeployment =  600 # seconds
      }
    }

    gateway {
      port-range = 40000-45000
      response-timeout = 5 # seconds, timeout for container operations
    }

    sla.period = 5 # seconds, sla monitor period
    escalation.period = 5 # seconds, escalation monitor period

    workflow {
      http {
        timeout = 30 # seconds, maximal http request waiting time
      }
      info {
        timeout = 10 // seconds
        component-timeout = 5 // seconds
      }
    }
  }

}
EOF

cat ${VAMP_HOME}/conf/application.conf



