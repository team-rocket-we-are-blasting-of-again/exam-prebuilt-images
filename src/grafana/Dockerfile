FROM tobiaszimmer/exam-gateway-subscription:java-17 as builder

FROM grafana/grafana:7.1.0

COPY datasource.yml /etc/grafana/provisioning/datasources/datasource.yml
COPY dashboard.yml /etc/grafana/provisioning/dashboards/default.yml
COPY dashboards /var/lib/grafana/dashboards

USER root
COPY --chown=root:root --from=builder /usr/local/bin/subscribe /usr/local/bin/subscribe
COPY --chown=root:root subscribe-and-start.sh /usr/local/bin/subscribe-and-start
RUN chmod +x /usr/local/bin/subscribe && \
    chmod +x /usr/local/bin/subscribe-and-start && \
    apk add curl
USER grafana

COPY gateway-routes.json /gateway-routes.json

ENV GF_SECURITY_ADMIN_USER admin
ENV GF_SECURITY_ADMIN_PASSWORD admin

ENTRYPOINT ["subscribe-and-start"]