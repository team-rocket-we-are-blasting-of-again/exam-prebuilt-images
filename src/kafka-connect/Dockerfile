FROM bitnami/kafka:3.3.1

COPY connectors /opt/bitnami/kafka/connectors
COPY connect-distributed.properties /opt/bitnami/kafka/config/connect-distributed.properties

EXPOSE 8083
CMD [ "/opt/bitnami/kafka/bin/connect-distributed.sh", "/opt/bitnami/kafka/config/connect-distributed.properties", "&" ]
