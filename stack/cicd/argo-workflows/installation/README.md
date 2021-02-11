# Argo Workflows Install with K8s

The yaml file in this folder is generated by the following command:

```bash
$ curl -sSL https://raw.githubusercontent.com/argoproj/argo/stable/manifests/install.yaml > ./stack/argo-workflows/base/argo-workflows-install.yaml
$ shasum -a 256 ./stack/argo-workflows/base/argo-workflows-install.yaml
c2204332e216e14cd68de058aeb2b4703eeb2adc0a72c67a043ad04657754375  ./stack/argo-workflows/base/argo-workflows-install.yaml
```

- **Last Update**: 1st April, 2020
- **Version**: v2.7.0
- **Evidence**:
  ```
  $ curl -sSL https://raw.githubusercontent.com/argoproj/argo/v2.7.0/manifests/install.yaml | shasum -a 256
  ...
  c2204332e216e14cd68de058aeb2b4703eeb2adc0a72c67a043ad04657754375  -
  ```

# Kustomize

As mentioned in https://github.com/argoproj/argo/issues/2376, ConfigMap needs to be corrected.

Rather than updating the original YAML file provided by Argo repository, this directory is set up with Kustomize and patch to be applied in a separate file.