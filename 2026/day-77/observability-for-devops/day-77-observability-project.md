# Day 77: Observability Project: Full Stack with Docker Compose

## Overview
Day 77 brings together everything built over the past 4 days into a **production-style observability stack**.

This project integrates:
- Metrics (Prometheus + Node Exporter + cAdvisor)
- Logs (Loki + Promtail)
- Traces (OpenTelemetry Collector)
- Visualization (Grafana)

All services are orchestrated using **Docker Compose**, forming a complete, end-to-end observability platform.

---

###  Architecture Diagram


                    +----------------------+
                    |      Grafana         |
                    | Dashboards + Explore |
                    +----------+-----------+
                               |
    ---------------------------+---------------------------
    |                          |                          |
    v                          v                          v


+---------------+        +----------------+        +----------------------+
|  Prometheus   |        |      Loki      |        |  OTEL Collector      |
|  (Metrics)    |        |    (Logs)      |        |     (Traces)         |
+-------+-------+        +--------+-------+        +----------+-----------+
|                         |                           |
v                         v                           v

+---------------+        +----------------+        +----------------------+
| Node Exporter |        |   Promtail     |        |   Notes App          |
| cAdvisor      |        | (Log Shipper)  |        |  (Generates Data)    |
+---------------+        +----------------+        +----------------------+

---

# Stack Components

| Service | Purpose | Port |
|--------|--------|------|
| Prometheus | Metrics collection | 9090 |
| Node Exporter | Host metrics | 9100 |
| cAdvisor | Container metrics | 8080 |
| Grafana | Visualization | 3000 |
| Loki | Log aggregation | 3100 |
| Promtail | Log collection | 9080 |
| OTEL Collector | Trace processing | 4317 / 4318 |
| Notes App | Sample application | 8000 |

---

### Task 1: Stack Deployment

### Commands
```bash
git clone https://github.com/LondheShubham153/observability-for-devops.git
cd observability-for-devops
docker compose up -d
docker compose ps
```

### Result

* All 8 services running successfully
* No container crashes or restarts

---

### Task 2: Metrics Pipeline Validation

### Prometheus Targets

* All targets show **UP**

  * prometheus
  * node-exporter
  * cadvisor
  * otel-collector

### Sample Queries

```promql
up
```

```promql
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

```promql
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

```promql
rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
```

```promql
topk(3, container_memory_usage_bytes{name!=""})
```

### Outcome

* Real-time CPU, memory, and container metrics visible
* Full metrics pipeline validated

---

### Task 3: Logs Pipeline Validation

### Generate Logs

```bash
for i in $(seq 1 50); do
  curl -s http://localhost:8000 > /dev/null
  curl -s http://localhost:8000/api/ > /dev/null
done
```

### LogQL Queries

```logql
{job="docker"}
```

```logql
{container_name="notes-app"}
```

```logql
{job="docker"} |= "error"
```

```logql
sum by (container_name) (rate({job="docker"}[5m]))
```

### Outcome

* Logs visible in Grafana Explore
* Promtail successfully shipping logs to Loki
* Log-to-metric transformation working

---

### Task 4: Traces Pipeline Validation

### Send Test Trace

```bash
curl -X POST http://localhost:4318/v1/traces \
-H "Content-Type: application/json" \
-d '{...}'
```

### Verify

```bash
docker logs otel-collector
```

### Outcome

* Parent span: HTTP request
* Child span: Database query
* Attributes visible (HTTP + DB)
* Trace pipeline fully validated

---

### Task 5: Production Overview Dashboard

### Dashboard Name

```
Production Overview
```

---

### Row 1 - System Health

```promql
CPU: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

```promql
Memory: (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

```promql
Disk: (1 - node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100
```

```promql
Targets: sum(up) / count(up)
```

---

### Row 2 - Container Metrics

```promql
rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100
```

```promql
container_memory_usage_bytes{name!=""} / 1024 / 1024
```

```promql
count(container_last_seen{name!=""})
```

---

### Row 3 - Logs (Loki)

```logql
{container_name="notes-app"}
```

```logql
sum(rate({job="docker"} |= "error" [5m]))
```

```logql
sum by (container_name) (rate({job="docker"}[5m]))
```

---

### Row 4 - Observability Health

```promql
prometheus_target_interval_length_seconds{quantile="0.99"}
```

```promql
otelcol_receiver_accepted_metric_points
```

---

### Task 6: Comparison with Reference

| Component      | Your Version | Reference Repo       | Difference           |
| -------------- | ------------ | -------------------- | -------------------- |
| Prometheus     | Basic setup  | Structured jobs      | Better organization  |
| Loki           | Minimal      | Production config    | Storage improvements |
| Promtail       | Static       | Dynamic discovery    | Better labeling      |
| OTEL           | Simple       | Structured pipelines | Scalable design      |
| Grafana        | Manual       | Auto-provisioned     | Infra-as-code        |
| Docker Compose | Incremental  | Unified stack        | Clean orchestration  |

---

### 5-Day Observability Journey

| Day | Focus                              |
| --- | ---------------------------------- |
| 73  | Prometheus fundamentals            |
| 74  | Node Exporter + cAdvisor + Grafana |
| 75  | Loki + Promtail                    |
| 76  | OpenTelemetry + tracing            |
| 77  | Full stack integration             |

---

### Production Improvements

* Add Alertmanager (Slack/PagerDuty alerts)
* Use distributed tracing backend (Tempo/Jaeger)
* Enable HTTPS + authentication
* Configure log retention policies
* Implement high availability (HA)
* Move to Kubernetes for scalability

---

### Self-Hosted vs Managed

| Feature     | Self-Hosted | Managed   |
| ----------- | ----------- | --------- |
| Cost        | Low         | High      |
| Control     | Full        | Limited   |
| Setup       | Complex     | Easy      |
| Flexibility | High        | Moderate  |
| Maintenance | Manual      | Automated |

---

### Highlights

* Observability = Metrics + Logs + Traces
* Prometheus uses pull-based metrics
* Loki uses label-based log indexing
* Promtail ships logs efficiently
* OpenTelemetry standardizes telemetry
* Grafana unifies everything

---

## Insight

> Monitoring tells you *something is wrong*.
> Observability tells you *why it’s wrong*.

---

# Summary

This project demonstrates a **complete observability stack** built from scratch using open-source tools.

It mirrors real-world production architectures and provides:

* Full system visibility
* Debugging capability across layers
* Scalable and extensible design

---
