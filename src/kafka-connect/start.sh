#!/usr/bin/env bash

sed -i "s/{{BOOTSTRAP_SERVERS}}/${BOOTSTRAP_SERVERS}/g" /opt/bitnami/kafka/config/connect-distributed.properties

/opt/bitnami/kafka/bin/connect-distributed.sh /opt/bitnami/kafka/config/connect-distributed.properties &

sleep infinity
