#!/usr/bin/env sh

cat << EOF > ${VAMP_HOME}/conf/logback.xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%cyan(%d{HH:mm:ss.SSS}) %highlight(| %-5level | %-40.40logger{40} | %-40.40X{akkaSource} | %msg%n)</pattern>
        </encoder>

        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>INFO</level>
        </filter>
    </appender>

    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${VAMP_HOME}/log/vamp.log</file>

        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>TRACE</level>
        </filter>

        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>vamp.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>7</maxHistory>
        </rollingPolicy>

        <encoder>
            <pattern>%d{HH:mm:ss.SSS} | %-5level | %-40.40logger{40} | %-40.40X{akkaSource} | %msg%n</pattern>
        </encoder>
    </appender>

    <logger name="io.vamp" level="TRACE"/>
    <logger name="scala.slick" level="WARN"/>
    <logger name="io.vamp.persistence.slick.components" level="INFO" />

    <root level="INFO">
        <appender-ref ref="STDOUT"/>
        <appender-ref ref="FILE" />
    </root>

</configuration>
EOF

