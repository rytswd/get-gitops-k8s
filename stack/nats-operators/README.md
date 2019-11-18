# NATS Operator + NATS Streaming Operator

## NATS Operator

The YAML files are taken from:
https://github.com/nats-io/nats-operator/tree/v0.6.0#namespace-scoped-installation

```bash
$ curl -L https://github.com/nats-io/nats-operator/releases/download/v0.6.0/00-prereqs.yaml > stack/nats-operator/templates/nats-op-prereqs.yaml
$ curl -L https://github.com/nats-io/nats-operator/releases/download/v0.6.0/10-deployment.yaml > stack/nats-operator/templates/nats-op-deployment.yaml
```

## NATS Streaming Operator

```bash
$ curl -L https://raw.githubusercontent.com/nats-io/nats-streaming-operator/074bc8110bbb60de2a97007d9cc271304b07f081/deploy/default-rbac.yaml > stack/nats-operator/templates/stan-op-rbac.yaml
$ curl -L https://raw.githubusercontent.com/nats-io/nats-streaming-operator/074bc8110bbb60de2a97007d9cc271304b07f081/deploy/deployment.yaml > stack/nats-operator/templates/stan-op-deployment.yaml
```
