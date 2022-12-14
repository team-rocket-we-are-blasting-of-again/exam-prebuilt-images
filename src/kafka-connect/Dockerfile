FROM bitnami/kafka:3.3.1

COPY connectors /opt/bitnami/kafka/connectors
COPY connect-distributed.properties /opt/bitnami/kafka/config/connect-distributed.properties

COPY start.sh /start.sh

ENV BOOTSTRAP_SERVERS kafka:9092

EXPOSE 8083
CMD [ "sh", "/start.sh" ]
