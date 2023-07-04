# Open-telemetry observability

Sample configuration for Kbot that send logs to [OpenTelemetry Collector] and metrics to [OpenTelemetry Collector] or [Prometheus].

## Prerequisites

- [Docker]
- [Docker Compose]

## How to run

```bash
export TELE_TOKEN=<TOKEN>
docker-compose up
```

## Grafana demo

Grafana start page
![grafana01](demo/grafana_demo01.jpg)

Prometeus metrics

![grafana02](demo/grafana_demo02.jpg)

Loki logs

![grafana03](demo/grafana_demo03.jpg)
