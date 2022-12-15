#!/usr/bin/env bash

sed -i "s/{{USERNAME}}/${USERNAME}/g" /etc/prometheus/prometheus.yml
sed -i "s/{{PASSWORD}}/${PASSWORD}/g" /etc/prometheus/prometheus.yml

the_hosts=""
services=$(echo "$PROMETHEUS_HOSTS" | tr "," "\n")
for service in $services ; do
    name=$(echo "$service" | cut -d':' -f 1)
    port=$(echo "$service" | cut -d':' -f 2)
    the_hosts="$the_hosts\"$name.production.svc.cluster.local:$port\","
    the_hosts="$the_hosts\"$name.staging.svc.cluster.local:$port\","
    the_hosts="$the_hosts\"$name.test.svc.cluster.local:$port\","
done

# Remove the last comma
the_hosts=$(echo "$the_hosts" | sed 's/.$//')
sed -i "s/\"{{PROMETHEUS_HOSTS}}\"/${the_hosts}/g" /etc/prometheus/prometheus.yml

/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/prometheus \
    --web.console.libraries=/usr/share/prometheus/console_libraries \
    --web.console.templates=/usr/share/prometheus/consoles
