# Istio

Istio has multiple installation options.

The setup here illustrates 2 approaches - using `istioctl`, and also Istio Operator.

Using Helm is another approach, and is documented [here](https://istio.io/docs/setup/install/helm/). As described there, Helm installation is likely to become deprecated in future.

---

# Istio with Get GitOps K8s

This repository is by default uses `istioctl` installation, as it is the official recommendation for the production setup.

Istio Operator pattern poses a question of Operator holding significant permission, which may cause some security concerns, the same way Helm v2 had in the past.

---

# Technical Details

## `istioctl` CLI

Istio has a dedicated CLI `istioctl`. It is a tool for debugging and analysing Istio, and also can be used to install Istio.

### Install `istioctl`

You can find more in [Istio Getting Started doc](https://istio.io/docs/setup/getting-started/). If you are on macOS, you can also install it from Homebrew.

### Generate Istio Installation Definition YAML

`istioctl` can be used interactively to install Istio. This is the recommended approcah by Istio, but this won't work for declarative GitOps approach.

In order for Argo CD to pick up and install Istio, we use `istioctl manifest generate` to create the YAML file.

```shell
$ istioctl manifest versions

Binary version is 1.6.4.

This version of istioctl can:
  Install Istio 1.6.0
  Update Istio from >=1.5.0 to 1.6.0
  Update Istio from  <1.7 to 1.6.0

$ istioctl manifest generate --set profile=demo --set values.grafana.enabled=false --set values.kiali.enabled=false > ./stack/istio/istioctl/istio-install.yaml

$ shasum -a 256 ./stack/istio/istioctl/istio-install.yaml
65787205184dc7a3453862552367dac59461f6b99f9c3d279a6a8597a49f8c37  ./stack/istio/istioctl/istio-install.yaml
```

## Istio Operator

Istio Operator is a CRD to install Istio.

Having the operator installed, you can easily install the Istio Control Plane by providing an IstioOperator.

### Install Istio Operator with `istioctl`

If you would like to simply install Istio Operator, you can run `istioctl operator init`.

However, this approach does not generate any YAML file you can statically save.

### Generate Istio Operator Installation YAML with Helm

Because `istioctl` does not provide a way, the only way to create Istio Operator installation YAML is by using Helm.

Firstly, you need to download the target Istio version.

```shell
$ curl -sSL https://istio.io/downloadIstio | sh -

# OR, if you need a specific version

$ curl -sSL https://istio.io/downloadIstio | ISTIO_VERSION=1.5.1 sh -
```

Then, you can create the YAML by `helm template`.

```shell
$ helm template istio-1.5.1/install/kubernetes/operator/operator-chart/ \
  --set hub=docker.io/istio \
  --set tag=1.5.1 \
  --set operatorNamespace=istio-operator \
  --set istioNamespace=istio-system > ./stack/istio/istio-operator/istio-operator-install.yaml

$ shasum -a 256 ./stack/istio/istio-operator/istio-operator-install.yaml
7b02849ee198be732e5ecfd77cce8f229c202546834c02b930ce6fc202c483b5  ./stack/istio/istio-operator/istio-operator-install.yaml
```

- **Last Update**: 15th April, 2020
- **Version**: v1.5.1
- **Evidence**: Unfortunately, there is no source to verify against

### TODO: Move this somewhere

```bash
# control-plane only
istioctl manifest generate \
  -f ./stack/istio/istio-operator/control-plane-only.yaml\
    > ./stack/istio/control-plane/istio-install.yaml

# demo
istioctl manifest generate \
  -f ./stack/istio/istio-operator/demo.yaml\
    > ./stack/istio/demo/istio-install.yaml
```
