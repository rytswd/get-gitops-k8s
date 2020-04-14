# Istio

Istio has multiple installation options.

The setup here illustrates 2 approaches - using `istioctl`, and also Istio Operator.

Using Helm is another approach, and is documented [here](https://istio.io/docs/setup/install/helm/). As described there, Helm installation is likely to become deprecated in future.

---

# Istio with Get GitOps K8s

This repository is by default uses Istio Operator.

This allows installing into restricted environments such as `kind`.

However, please note that Istio recommends using `istioctl` for the production setup.

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

Operator version is 1.5.1.

The following installation package versions are recommended for use with this version of the operator:
  1.5.0

The following installation package versions are supported for upgrade by this version of the operator:
  >=1.4.0
   <1.6

$ istioctl manifest generate > ./stack/istio/istioctl/istio-install.yaml

$ shasum -a 256 ./stack/istio/istioctl/istio-install.yaml
45f26f1c5cbd91e70d2bd5a960b4da719284686b329ba31468f18fe27f27f150  ./stack/istio/istioctl/istio-install.yaml
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
$ curl -L https://istio.io/downloadIstio | sh -

# OR, if you need a specific version

$ curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.5.1 sh -
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
