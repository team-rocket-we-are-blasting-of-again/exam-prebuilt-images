#!/usr/bin/env bash

sed -i "s/{{USERNAME}}/${USERNAME}/g" /etc/prometheus/prometheus.yml
sed -i "s/{{PASSWORD}}/${PASSWORD}/g" /etc/prometheus/prometheus.yml
the_hosts=${PROMETHEUS_HOSTS//,/\",\"}
sed -i "s/{{PROMETHEUS_HOSTS}}/${the_hosts}/g" /etc/prometheus/prometheus.yml

/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/prometheus \
    --web.console.libraries=/usr/share/prometheus/console_libraries \
    --web.console.templates=/usr/share/prometheus/consoles
