# Prometheus Operator Install with K8s

The yaml file in this folder is generated by the following command:

```bash
$ curl -sSL "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.43.1/bundle.yaml" > ./stack/prometheus-operator/prometheus-operator-install.yaml
$ shasum -a 256 ./stack/prometheus-operator/prometheus-operator-install.yaml
f722a98e8dfc5017a30dfda02c6a13070982c79c586a6205033d6000a8609570  ./stack/prometheus-operator/prometheus-operator-install.yaml
```

- **Last Update**: 5th October, 2020
- **Version**: v1.7.8
- **Evidence**:
  ```
  $ curl -sSL "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.43.1/bundle.yaml" | shasum -a 256
  ...
  f722a98e8dfc5017a30dfda02c6a13070982c79c586a6205033d6000a8609570  -
  ```