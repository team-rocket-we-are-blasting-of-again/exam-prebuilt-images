# Microservice Monitoring

This repository contains the images required for monitoring specific services. Each service has to emit prometheus data, which these containers would then listen on.

## About

We want to monitor how the specific services are doing, such as cpu usage.
For this we use prometheus to store all the metrics about our services, and then create a grafana instance which uses the prometheus data to show the data in a dashboard.

All microservice monitoring can be found at `https://monitor-services.jplm.dk` and likewise in staging or test if also deployed

## Guide

This section contains all the information required for you to add your service to the monitoring.

### Dependencies

pom.xml

```xml
<dependencies>
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-actuator</artifactId>
	</dependency>
	<dependency>
		<groupId>io.micrometer</groupId>
		<artifactId>micrometer-registry-prometheus</artifactId>
	</dependency>
</dependencies>
```

Spring boot actuator will enable the ability to send continues data of the application. Such as health and others. All the application data can now be found at `/actuator`.

The micrometer-registry-prometheus dependencies adds one more endpoint `/actuator/prometheus` which will be the one that out prometheus container subscribes to

### Configuration

Almost no configuration is, since Spring does most of the heavy lifting.

application.properties

```properties
management.endpoints.web.exposure.include=*
```

This enables all actuator paths.

### Securing the endpoints

**Disclaimer** this security is only required if your service is an external service that we expose to the outside.

**If your external service does not currently have security implemented, please visit [follow this guide](https://github.com/team-rocket-we-are-blasting-of-again/exam-gateway-subscription)**

Because these metrics are quite sensitive, we have to secure them. Prometheus allows us to use basic authentication for this.

The authorization method has to be BASIC, because we only want our own internal login to work for these endpoints, and no external roles should be allowed to use them.

We need to configure your `gateway-routes.json` so that all the actuator endpoints can be authenticated using basic authentication.

Example new config

```json
[
  {
    "requestPath": "/restaurant/**",
    "forwardUri": "http://restaurant:8080",
    "routePathDto": [
      {
        "path": "/restaurant/actuator/**",
        "method": "BASIC",
        "rolesAllowed": []
      },
      {
        "path": "/restaurant/**",
        "method": "BEARER",
        "rolesAllowed": ["RESTAURANT"]
      }
    ]
  }
]
```

Notice that the path that is `/restaurant/actuator/**` has been moved to the top.
This is because the first of a route will be the first one used.
So if you changed them to the other way around, the actuator route would always be authorized using Bearer authentication.

### Subscribing your metric data to prometheus

Add the service to the list of hosts in the prometheus kubernetes deployment whatever environment that makes sense:

[GitOps Repository](https://github.com/team-rocket-we-are-blasting-of-again/exam-gitops)

environments/{test|staging|prod}/service-monitoring.tf

```terraform
resource "kubernetes_deployment" "prometheus" {
  # ...
  env {
    name  = "PROMETHEUS_HOSTS"
    value = gateway:8080,your-deployed-service:PORT
  }
  # ...
}
```

Make sure that there are no spaces between the commas and the services, because that would break the starting of the service.
