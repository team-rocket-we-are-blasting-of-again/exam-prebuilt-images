FROM grafana/grafana:8.3.5

COPY datasource.yml /etc/grafana/provisioning/datasources/datasource.yml
COPY dashboard.yml /etc/grafana/provisioning/dashboards/default.yml
COPY dashboards /var/lib/grafana/dashboards

ENV GF_SECURITY_ADMIN_USER admin
ENV GF_SECURITY_ADMIN_PASSWORD admin
